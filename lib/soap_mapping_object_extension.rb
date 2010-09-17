module SOAP
  module Mapping
    class Object

      def each(&block)
        find_records.each(&block)
      end

      def count(&block)
        find_records.count &block
      end

      protected
      
      def find_records
        tmp = match_condition(self, '.*')
        if tmp2 = match_condition(tmp,'records')
          if item = match_condition(tmp2, 'record')
            if item.is_a?(Array)
              return item
            else
              return [item]
            end
          end
        end
        return []
      end

      def match_condition(obj, condition)
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