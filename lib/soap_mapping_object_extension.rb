module SOAP
  module Mapping
    class Object

      def each(&block)
        find_records.each(&block)
      end

      def count(&block)
        find_records.count &block
      end

      def to_hash
        result = {}.with_indifferent_access
        __xmlele.map do |name, value|
          result[name.name.underscore] = case value
                                         when SOAP::Mapping::Object
                                           value.to_hash
                                         when Array
                                           value.map{|v| v.is_a?(SOAP::Mapping::Object) ? v.to_hash : v}
                                         else
                                           value
                                         end
        end
        result
      end

      protected

      def find_records
        tmp = return_obj_by_condition(self, '.*')
        if tmp2 = return_obj_by_condition(tmp,'records')
          if item = return_obj_by_condition(tmp2, 'record')
            if item.is_a?(Array)
              return item
            else
              return [item]
            end
          end
        end
        return []
      end

      def return_obj_by_condition(obj, condition)
        (obj.methods - SOAP::Mapping::Object.instance_methods).each do |i|
          if i =~ Regexp.new(condition, true)
            return obj.send(i)
          end
        end
        false
      end

    end
  end
end
