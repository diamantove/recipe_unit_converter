# frozen_string_literal: true

require_relative "recipe_unit_converter/version"
require_relative "recipe_unit_converter/converter"
require_relative "recipe_unit_converter/extensions/numeric"

module RecipeUnitConverter
  class Error < StandardError; end
end
