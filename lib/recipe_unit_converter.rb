# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

require_relative 'recipe_unit_converter/converter'

module RecipeUnitConverter
  # коэффициенты перевода в миллилитры
  @volume_units = {
    drop:            0.05,       # капля (очень маленький объём)
    pinch:           0.36,       # щепотка (обычно 1/8 ч.л.)
    teaspoon:        5.0,        # чайная ложка
    dessert_spoon:   10.0,       # десертная ложка (~2 ч.л.)
    tablespoon:      15.0,       # столовая ложка
    fluid_ounce:     29.5735,    # жидкая унция
    shot:            44.36,      # рюмка (~1.5 унции)
    gill:            118.294,    # джил (1/4 пинты)
    cup:             240.0,      # чашка (US standard)
    wine_glass:      150.0,      # бокал вина
  }

  # коэффициенты перевода в граммы
  @mass_units = {
    milligram:       0.001,      # миллиграмм
    gram:            1.0,        # грамм
    carat:           0.2,        # карат (ювелирный)
    dram:            1.771845,   # драм (аптечная мера)
    grain:           0.0647989,  # грейн (оружейная мера)
    ounce:           28.3495,    # унция

  }

  @aliases = {
    # объём
    drops:           :drop,
    pinches:         :pinch,
    tsp:             :teaspoon,
    teaspoons:       :teaspoon,
    dst_spoon:       :dessert_spoon,
    dessert_spoons:  :dessert_spoon,
    tbsp:            :tablespoon,
    tablespoons:     :tablespoon,
    fl_oz:           :fluid_ounce,
    fluid_ounces:    :fluid_ounce,
    pony:            :pony,
    shots:           :shot,
    shot:            :shot,
    gill:            :gill,
    gills:           :gill,
    cup:             :cup,
    cups:            :cup,
    wine_glass:      :wine_glass,
    wine_glasses:    :wine_glass,
    ice_cream_scoop: :ice_cream_scoop,
    scoops:          :ice_cream_scoop,
    pt:              :pint,
    pints:           :pint,
    qt:              :quart,
    quarts:          :quart,
    gal:             :gallon,
    gallons:         :gallon,
    imp_gal:         :imp_gallon,
    imp_gallon:      :imp_gallon,
    barrel:          :barrel,
    barrels:         :barrel,
    bushel:          :bushel,
    bushels:         :bushel,
    soda_can:        :soda_can,
    cans:            :soda_can,
    wine_bottle:     :wine_bottle,
    bottles:         :wine_bottle,
    ml:              :milliliter,
    milliliters:     :milliliter,
    cl:              :centiliter,
    centiliters:     :centiliter,
    dl:              :deciliter,
    deciliters:      :deciliter,
    l:               :liter,
    liters:          :liter
  }

  # плотности ингредиентов в г/мл (по умолчанию вода = 1.0)
@densities = {
  water:          1.0,     # вода
  milk:           1.036,   # цельное молоко (3.25% жирности)
  cream:          0.994,   # сливки (жирные)
  flour:          0.59,    # пшеничная мука 
  sugar:          0.85,    # сахар (песок)
  brown_sugar:    0.72,    # коричневый сахар (упакованный)
  powdered_sugar: 0.8,     # сахарная пудра
  butter:         0.911,   # сливочное масло
  margarine:      0.96,    # маргарин
  honey:          1.43,    # мёд

}



  class << self
    attr_reader :volume_units, :mass_units, :aliases, :densities

    def convert(amount, from_unit, to_unit, ingredient: nil)
      amt = BigDecimal(amount.to_s)
      from = normalize_unit(from_unit)
      to   = normalize_unit(to_unit)

      if volume_units.key?(from) && volume_units.key?(to)
        # объем → объем
        (amt * volume_units[from] / volume_units[to]).to_f
      elsif volume_units.key?(from) && mass_units.key?(to)
        # объем → масса через плотность
        dens = density_for(ingredient) || densities[:water]
        grams = amt * volume_units[from] * BigDecimal(dens.to_s)
        (grams / mass_units[to]).to_f
      elsif mass_units.key?(from) && volume_units.key?(to)
        # масса → объем через плотность
        dens = density_for(ingredient) || densities[:water]
        milliliters = amt * mass_units[from] / BigDecimal(dens.to_s)
        (milliliters / volume_units[to]).to_f
      else
        raise ArgumentError, "Unsupported conversion from \#{from} to \#{to}"
      end
    end
  end
end

require_relative 'recipe_unit_converter/extensions/numeric'
