module Darwinning
  class Gene
    attr_reader :name, :value_range, :invalid_values, :units

    def initialize(options = {})
      @name = options.fetch(:name, '')
      @value_range = Array(options.fetch(:value_range, []))
      @invalid_values = Array(options.fetch(:invalid_values, []))
      @units = options.fetch(:units, '')
      @hash = name.hash ^ value_range.hash ^ invalid_values.hash ^ units.hash
    end

    def ==(o)
      o.class == self.class &&
      o.name == name &&
      o.value_range == value_range &&
      o.invalid_values == invalid_values &&
      o.units == units
    end

    alias eql? ==

    def hash
      return @hash
    end

    def express
      (value_range - invalid_values).sample
    end

    def is_valid_value?(value)
      value_range.include?(value) && !invalid_values.include?(value)
    end
  end

end
