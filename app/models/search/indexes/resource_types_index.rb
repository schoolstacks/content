module Search
  module Indexes

    class ResourceTypesIndex < Index
      def mappings
        {
          resource_type: {
            properties: {
              id: {type: 'string', index: 'not_analyzed'},
              name: {
                type: 'multi_field',
                fields: {
                  name:    {type: 'string', index: 'not_analyzed'},
                  full:    {type: 'string', analyzer: 'full_str'},
                  partial: {type: 'string', analyzer: 'partial_str'}
                }
              }
            }
          }
        }
      end

      def serialize(obj)
        ResourceTypeSerializer.new(obj).as_json
      end
    end

  end
end
