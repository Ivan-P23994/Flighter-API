class OpenWeatherMap::City
  include Comparable
  attr_reader :id, :lat, :lon, :name
  attr_accessor :temp_k # TODO: change spec

  def initialize(id:, lat:, lon:, name:, temp_k:)
    @id = id
    @lat = lat
    @lon = lon
    @name = name
    @temp_k = temp_k
  end

  def self.parse(raw_hash)
    hash = raw_hash.deep_symbolize_keys

    new(
      id: hash[:id], name: hash[:name],
      lat: hash.dig(:coord, :lat), lon: hash.dig(:coord, :lon),
      temp_k: hash.dig(:main, :temp)
    )
  end

  def temp
    (temp_k - 273.15).round(2)
  end

  def <=>(other)
    [temp, name.ord] <=> [other.temp, other.name.ord]
  end
end
