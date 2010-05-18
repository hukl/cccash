module Statistics
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def count_time_series(options)
      defaults = { :start => 1.day.ago,
                   :end   => Time.now,
                   :step  => 'hour' }
      options = defaults.merge(options)

      if options[:conditions]
        where_clause = "WHERE "
        where_clause << sanitize_sql_for_conditions(options[:conditions])
      else
        where_clause = ""
      end

      # FIXME: Currently hardcoded timezone offset, not pretty
      query = <<END
SELECT
  s.timestamp AS timestamp,
  coalesce(t.count, 0) as count
FROM
  (SELECT date_trunc(:step, generate_series(TIMESTAMP :start_timestamp,
                     TIMESTAMP :end_timestamp, INTERVAL :interval)))
   AS s(timestamp)
LEFT OUTER JOIN
  (SELECT COUNT(*) AS count, date_trunc(:step, created_at + INTERVAL '2hour') AS timestamp 
   FROM #{self.table_name} #{where_clause} GROUP BY timestamp)
   AS t ON (s.timestamp = t.timestamp)
ORDER BY s.timestamp ASC;
END
      interpolations = { :start_timestamp => options[:start].to_s(:db),
                         :end_timestamp   => options[:end].to_s(:db),
                         :step            => options[:step],
                         :interval        => "1#{options[:step]}" }
      time_series = self.find_by_sql([query, interpolations])
    end
  end
end

