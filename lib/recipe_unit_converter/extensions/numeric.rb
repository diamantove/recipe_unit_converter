# frozen_string_literal: true
require_relative '../../recipe_unit_converter'


module RecipeUnitConverter
  class Quantity
    attr_reader :amount, :unit

    def initialize(amount, unit)
      @amount = amount
      @unit   = unit
    end

    def to(target_unit, ingredient: nil)
      RecipeUnitConverter.convert(@amount, @unit, target_unit, ingredient: ingredient)
    end
  end
end

class Numeric
  RecipeUnitConverter.supported_units.each do |unit_sym|
    define_method(unit_sym) do
      RecipeUnitConverter::Quantity.new(self, unit_sym)
    end
  end

  RecipeUnitConverter.unit_aliases.each do |alias_sym, canonical_sym|
    define_method(alias_sym) do
      RecipeUnitConverter::Quantity.new(self, canonical_sym)
    end
  end
end
