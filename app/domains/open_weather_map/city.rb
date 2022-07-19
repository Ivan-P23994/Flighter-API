class OpenWeatherMap::City
  include Comparable
  attr_reader :id, :lat, :lon, :name

  def initialize(id, lat, lon, name, temp_k)
    @id = id
    @lat = lat
    @lon = lon
    @name = name
    @temp_k = temp_k
  end

  def temp
    (@temp_k - 273.15).round(2)
  end

  def <=>(other)
    [other.temp, other.name.ord] <=> [temp, name.ord]
  end
end
