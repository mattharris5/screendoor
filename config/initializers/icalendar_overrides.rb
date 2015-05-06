module Icalendar
  module Values

    class DateTime < Value

      def initialize(value, params = {})
        if value.is_a? String
          params['tzid'] = 'UTC' if value.end_with? 'Z'

          begin
            parsed_date = ::DateTime.parse(value)
          rescue ArgumentError => e
            raise ArgumentError.new("Failed to parse \"#{value}\" - #{e.message}")
          end

          super parsed_date, params
        elsif value.respond_to? :to_datetime
          super value.to_datetime, params
        else
          super
        end
      end

    end
  end
end