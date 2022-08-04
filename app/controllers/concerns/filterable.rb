module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = where(nil)
      filtering_params.each do |key, value|
        raise StandardError, 'This is an exception' if value.blank? # rubocop:disable Style/RaiseArgs

        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end
