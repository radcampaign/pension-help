require 'active_record'
require 'active_support/concern'


module Geokit
  module ActsAsMappable
    module ClassMethods

      def with_distance_from(options)
        origin = extract_origin_from_options(options)
        units = extract_units_from_options(options)
        formula = extract_formula_from_options(options)
        distance_column_name = distance_sql(origin, units, formula)
        select("*, #{distance_column_name} distance")
      end

    end
  end
end
