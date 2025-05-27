# frozen_string_literal: true
require_relative '../recipe_unit_converter'

module RecipeUnitConverter
  class Converter
    def initialize
      @amount = nil
      @from   = nil
    end

    def amount(value)
      @amount = value
      self
    end

    def from(unit)
      @from = unit
      self
    end

    def to(unit, ingredient: nil)
      RecipeUnitConverter.convert(@amount, @from, unit, ingredient: ingredient)
    end
  end
end
