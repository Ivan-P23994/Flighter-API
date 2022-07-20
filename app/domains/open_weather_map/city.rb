class OpenWeatherMap::City
  include Comparable
  attr_reader :id, :lat, :lon, :name
  attr_accessor :temp_k

  def initialize(hash)
    @id = hash[:id]
    @lat = hash[:coord][:lat]
    @lon = hash[:coord][:lon]
    @name = hash[:name]
    @temp_k = hash[:main][:temp]
  end

  def self.parse(hash)
    new(hash)
  end

  def temp
    (temp_k - 273.15).round(2)
  end

  def <=>(other)
    [temp, name.ord] <=> [other.temp, other.name.ord]
  end
end
