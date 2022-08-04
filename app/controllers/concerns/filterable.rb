module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      #binding.pry
      results = where(nil)
      filtering_params.each do |key, value|
        raise StandardError.new "This is an exception" unless value.present?
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      #binding.pry
      results
    end
  end
end
