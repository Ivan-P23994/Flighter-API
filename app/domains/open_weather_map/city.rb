class OpenWeatherMap::City # rubocop:disable Style/ClassAndModuleChildren
  include Comparable
  attr_reader :id, :lat, :lon, :name
  attr_accessor :temp_k

  def initialize(raw_hash)
    hash = raw_hash.deep_symbolize_keys
    @id = hash[:id]
    @lat = hash[:coord][:lat]
    @lon = hash[:coord][:lon]
    @name = hash[:name]
    @temp_k = hash[:main][:temp]
  end

  def self.parse(raw_hash)
    hash = raw_hash.deep_symbolize_keys
    new(hash)
  end

  def temp
    (temp_k - 273.15).round(2)
  end

  def <=>(other)
    [temp, name.ord] <=> [other.temp, other.name.ord]
  end
end
