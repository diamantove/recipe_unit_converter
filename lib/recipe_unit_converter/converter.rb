# frozen_string_literal: true

module RecipeUnitConverter
  class Converter
    
  # Базовые коэффициенты: из единицы в миллилитры (для объёма)
  VOLUME_FACTORS = 
  {
    pinch:       0.3125,    # щепотка
    drop:        0.05,      # капля
    teaspoon:    5.0,       # чайная ложка
    tablespoon:  15.0,      # столовая ложка
    fluid_ounce: 29.5735,   # жидкая унция
    cup:         240.0,     # чашка
    pint:        473.176    # пинта
  }.freeze


  # Плотности по умолчанию (грамм на мл)
  DEFAULT_DENSITIES = 
  {
    flour:        0.59,  # мука
    sugar:        0.85,  # сахар
    brown_sugar:  0.721, # коричневый сахар
    salt:         1.20,  # соль
    butter:       0.911, # сливочное масло
    honey:        1.42,  # мёд
    milk:         1.03,  # молоко
    water:        1.00,  # вода
    oil:          0.92,  # растительное масло
    rice:         0.85,  # рис
    oats:         0.43,  # овсянка
    cocoa:        0.64,  # какао-порошок
    peanut_butter:1.10   # арахисовая паста
  }.freeze

  # Пользовательские единицы измерения
  @custom_units    = {}
  # Пользовательские плотности
  @custom_densities = {}

  class << self

    def volume_unit?(unit)
      VOLUME_FACTORS.key?(unit)
    end


  end


  end
end