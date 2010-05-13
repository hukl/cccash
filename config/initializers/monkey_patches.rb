class String
  def convert_umlauts
    self.
      gsub(/ü/,'ue').
      gsub(/ä/,'ae').
      gsub(/ö/,'oe').
      gsub(/Ü/,'Ue').
      gsub(/Ä/,'Ae').
      gsub(/Ö/,'Oe').
      gsub(/ß/,'ss')
  end
end


class Time
  def timestamp
    strftime("%Y-%m-%d %H:%M:%S")
  end
end