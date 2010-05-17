module Statistics
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def count_time_series(start_timestamp, end_timestamp, step)
      query = <<END
SELECT
  s.timestamp AS timestamp,
  coalesce(t.count, 0) as count
FROM
  (SELECT date_trunc(:step, generate_series(TIMESTAMP :start_timestamp,
                     TIMESTAMP :end_timestamp, INTERVAL :interval)))
   AS s(timestamp)
LEFT OUTER JOIN
  (SELECT COUNT(*) AS count, date_trunc(:step, created_at) AS timestamp 
   FROM #{self.table_name} GROUP BY timestamp)
   AS t ON (s.timestamp = t.timestamp)
ORDER BY s.timestamp ASC;
END
      interpolations = { :start_timestamp => start_timestamp,
                         :end_timestamp   => end_timestamp,
                         :step            => step,
                         :interval        => "1#{step}" }
      time_series = self.find_by_sql([query, interpolations])
    end
  end
end

