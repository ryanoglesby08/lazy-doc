module LazyDoc
  class Memoizer
    def memoize(attribute)
      attribute_variable_name = "@#{attribute}"
      unless instance_variable_defined?(attribute_variable_name)
        instance_variable_set(attribute_variable_name, yield)
      end

      instance_variable_get(attribute_variable_name)
    end
  end
end