# RecipeUnitConverter

Ruby-гем для конвертации кулинарных единиц измерения, специально разработанный для работы с рецептами. Легко переводите ложки в граммы, литры в чашки и обратно с понятным и удобным API.

## Установка

Добавьте в ваш `Gemfile`:

```ruby
gem 'recipe_unit_converter'
```

Затем выполните:

```bash
bundle install
```

Или установите гем напрямую:

```bash
gem install recipe_unit_converter
```

## Использование

### Простейшая конвертация

Модульный метод:

```ruby
require 'recipe_unit_converter'

# Конвертация 2 столовых ложек в граммы (по умолчанию для воды)
grams = RecipeUnitConverter.convert(2, :tablespoons, :grams)
# => 29.574
```

### Цепочный интерфейс

```ruby
converter = RecipeUnitConverter::Converter.new
result    = converter.amount(3)
                     .from(:cups)
                     .to(:milliliters)
# => 710.0
```

### Расширение класса Numeric

Подключите расширения:

```ruby
require 'recipe_unit_converter/extensions/numeric'

# Теперь можно вызывать напрямую у чисел:
ounces = 5.grams.to(:ounces)
# => 0.176367

# Или задавать единицы inline:
cups = 250.ml.to(:cups)
# => 1.056688
```

## Поддерживаемые единицы

Ниже перечислены единицы объёма и массы, поддерживаемые гемом (доступны синонимы, сокращения и множественные формы):

* **Объём:**

  * \:pinch, \:pinches (щепотка)
  * \:drop, \:drops (капля)
  * \:teaspoon, \:tsp, \:teaspoons (чайная ложка)
  * \:tablespoon, \:tbsp, \:tablespoons (столовая ложка)
  * \:fluid\_ounce, \:fl\_oz, \:fluid\_ounces (жидкая унция)
  * \:cup, \:cups (чашка)
  * \:pint, \:pt, \:pints (пинта)
  * \:quart, \:qt, \:quarts (кварта)
  * \:gallon, \:gal, \:gallons (галлон)
  * \:milliliter, \:ml, \:milliliters (миллилитр)
  * \:centiliter, \:cl, \:centiliters (сантилитр)
  * \:deciliter, \:dl, \:deciliters (децилитр)
  * \:liter, \:l, \:liters (литр)

* **Масса:**

  * \:milligram, \:mg, \:milligrams (миллиграмм)
  * \:gram, \:g, \:grams (грамм)
  * \:kilogram, \:kg, \:kilograms (килограмм)
  * \:ounce, \:oz, \:ounces (унция)
  * \:pound, \:lb, \:pounds (фунт)
  * \:stone, \:st, \:stones (камень, британская мера)

Дополнительно можно добавить свои пользовательские единицы через метод `RecipeUnitConverter.add_unit(name, alias: ..., to_ml: ...)` для объёма или `to_g: ...` для массы.

## Конвертация с учётом плотности ингредиента.

По умолчанию используется плотность воды для переводов объём ↔ масса. Для указания другого ингредиента передайте ключ `ingredient`:

```ruby
# Конвертация 2 столовых ложек сахара в граммы
sugar_grams = RecipeUnitConverter.convert(2, :tablespoons, :grams, ingredient: :sugar)
# => 25.6  # (плотность сахара 0.8 g/ml)
```

### Пользовательские плотности

```ruby
# Задаём плотность для мёда (g/ml)
RecipeUnitConverter.set_density(:honey, density: 1.42)

# Конвертация объёма мёда в массу
honey_grams = RecipeUnitConverter.convert(1, :cup, :grams, ingredient: :honey)
# => 340.0  # 1 cup = 240 ml × 1.42 g/ml
```

## Описание API

### `RecipeUnitConverter.convert(amount, from_unit, to_unit, ingredient: nil)`

* `amount` (`Numeric`) — значение для конвертации
* `from_unit` (`Symbol`/`String`) — исходная единица
* `to_unit` (`Symbol`/`String`) — целевая единица
* `ingredient` (`Symbol`/`String`, опционально) — ключ ингредиента для поиска плотности

**Возвращает**: `Float` — результат конвертации

### `RecipeUnitConverter.supported_units`

**Пример:**

```ruby
RecipeUnitConverter.supported_units
# => [:teaspoon, :tablespoon, :cup, :gram, ...]
```
**Возвращает**: `Array` — список всех поддерживаемых единиц измерения

### `RecipeUnitConverter.unit_aliases`

`{ tsp: :teaspoon, tbsp: :tablespoon, g: :gram, ml: :milliliter, ... }`

**Возвращает**: `Hash` — Отображение всех синонимов и псевдонимов единиц, например:

### `RecipeUnitConverter.density_for(ingredient)`

**Пример:**

```ruby
RecipeUnitConverter.density_for(:honey)
# => 1.42
```

**Возвращает**: `Float` — текущая плотность ингредиента, если она задана.

### Класс `RecipeUnitConverter::Converter`

Цепочный интерфейс:

```ruby
converter = RecipeUnitConverter::Converter.new
```

Методы:

* `#amount(value)` — задаёт число для конвертации
* `#from(unit)` — указывает исходную единицу
* `#to(unit, ingredient: nil)` — выполняет конвертацию, опционно передаёт ингредиент

**Пример:**

```ruby
converter.amount(4).from(:cups).to(:grams, ingredient: :flour)
```

### Расширения для `Numeric` (опционально)

После `require 'recipe_unit_converter/extensions/numeric'` у каждого `Numeric` появляются:

* `#to(unit, ingredient: nil)` — конвертация в указанную единицу
* метод-алиасы единиц: `#teaspoons`, `#tablespoons`, `#cups`, `#ml`, `#l`, `#grams`, `#kg`, `#ounces`, `#pounds`

**Пример:**

```ruby
3.tablespoons.to(:grams)
250.ml.to(:cups)
```

## Пользовательские единицы

Можно добавить новые единицы или псевдонимы:

```ruby
# Добавляем щепотку (0.36 ml)
RecipeUnitConverter.add_unit(:pinch, alias: :pinches, to_ml: 0.36)

# Конвертация щепоток в чайные ложки
t = RecipeUnitConverter.convert(5, :pinches, :teaspoons)
```

## Примеры

```ruby
# 2 литра в чашки
two_liters = RecipeUnitConverter.convert(2, :liters, :cups)
# => 8.4535

# Цепочный API
result = RecipeUnitConverter::Converter.new
               .amount(100)
               .from(:grams)
               .to(:ounces)
# => 3.5274
```
