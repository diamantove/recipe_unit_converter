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
    ice_cream_scoop: 48.0,       # сервировочная ложка для мороженого
    pint:            473.176,    # пинта
    quart:           946.353,    # кварта
    gallon:          3785.41,    # галлон
    imp_gallon:      4546.09,    # имперский галлон (UK)
    barrel:          117347.764, # баррель (31 галлонов)
    bushel:          35391.2,    # бушель (~35.39 л)
    soda_can:        355.0,      # банка газировки (12 fl oz)
    wine_bottle:     750.0,      # бутылка вина
    milliliter:      1.0,        # миллилитр
    centiliter:      10.0,       # сантилитр
    deciliter:       100.0,      # децилитр
    liter:           1000.0      # литр
  }

  # коэффициенты перевода в граммы
  @mass_units = {
    milligram:       0.001,      # миллиграмм
    gram:            1.0,        # грамм
    carat:           0.2,        # карат (ювелирный)
    dram:            1.771845,   # драм (аптечная мера)
    grain:           0.0647989,  # грейн (оружейная мера)
    ounce:           28.3495,    # унция
    pound:           453.592,    # фунт
    stick:           113.4,      # половина пачки масла (~1/2 stick)
    kilogram:        1000.0,     # килограмм
    stone:           6350.29,    # стоун (14 фунтов)
    centner:         100_000.0,  # центнер (100 кг)
    ton:             1_000_000.0 # метрическая тонна
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
    # масса
    mg:              :milligram,
    milligrams:      :milligram,
    g:               :gram,
    grams:           :gram,
    ct:              :carat,
    carats:          :carat,
    dr:              :dram,
    drams:           :dram,
    gr:              :grain,
    grains:          :grain,
    oz:              :ounce,
    ounces:          :ounce,
    lb:              :pound,
    lbs:             :pound,
    pounds:          :pound,
    stick:           :stick,
    sticks:          :stick,
    kg:              :kilogram,
    kilograms:       :kilogram,
    stone:           :stone,
    stones:          :stone,
    centner:         :centner,
    cwt:             :centner,  # британский центнер (cwt)
    t:               :ton,
    ton:             :ton,
    tons:            :ton
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
  oil:            0.92,    # растительное масло
  olive_oil:      0.915,   # оливковое масло
  vinegar:        1.005,   # уксус (5%)
  yogurt:         1.06,    # йогурт (натуральный)
  sour_cream:     0.978,   # сметана (38% жирности)
  peanut_butter:  1.09,    # арахисовая паста
  ketchup:        1.15,    # кетчуп
  mayonnaise:     0.94,    # майонез
  cocoa_powder:   0.64,    # какао-порошок
  rice:           0.85,    # рис (белый, сухой)
  oats:           0.43,    # овсяные хлопья
  corn_syrup:     1.48,    # кукурузный сироп
  maple_syrup:    1.32,    # кленовый сироп
  molasses:       1.45,    # патока
  tomato_paste:   1.06     # томатная паста
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
      elsif mass_units.key?(from) && mass_units.key?(to)
        # масса → масса
        (amt * mass_units[from] / mass_units[to]).to_f
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

    # Список поддерживаемых единиц
    def supported_units
      (volume_units.keys + mass_units.keys).uniq
    end

    # Список алиасов
    def unit_aliases
      aliases.dup
    end

    # Получить плотность (г/мл) для ингредиента
    def density_for(name)
      return unless name
      densities[name.to_sym]
    end

    # Установить или переопределить плотность
    def set_density(name, density:)
      densities[name.to_sym] = density.to_f
    end

    # Добавить пользовательскую единицу
    def add_unit(name, alias_name: nil, to_ml: nil, to_g: nil)
      sym = name.to_sym
      volume_units[sym] = to_ml.to_f if to_ml
      mass_units[sym]   = to_g.to_f    if to_g
      aliases[alias_name.to_sym] = sym if alias_name
    end

    private
    # Приведение строки/символа к каноническому символу
    def normalize_unit(u)
      sym = u.to_s.downcase.to_sym
      aliases.fetch(sym, sym)
    end

  end
end

require_relative 'recipe_unit_converter/extensions/numeric'
