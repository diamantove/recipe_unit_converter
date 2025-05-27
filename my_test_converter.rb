require_relative 'lib/recipe_unit_converter'

include RecipeUnitConverter

# 1. Прямые преобразования объём в объём
puts "3 cups в milliliters: #{RecipeUnitConverter.convert(3, :cups, :milliliters)}"
puts "2 quarts в gallons: #{RecipeUnitConverter.convert(2, 'quarts', 'gallons')}"

# 2. Прямые преобразования масса в масса
puts "500 grams в pounds: #{RecipeUnitConverter.convert(500, :grams, :pounds)}"
puts "2 stone в kilograms: #{RecipeUnitConverter.convert(2, :stone, :kg)}"

# 3. Объём -> масса с учётом плотности
puts "1 cup муки в grams: #{RecipeUnitConverter.convert(1, :cup, :grams, ingredient: :flour)}"
puts "2 tablespoons мёда в grams: #{RecipeUnitConverter.convert(2, :tbsp, :g, ingredient: :honey)}"

# 4. Масса -> объём с учётом плотности
puts "100 grams масла в tablespoons: #{RecipeUnitConverter.convert(100, :grams, :tablespoons, ingredient: :butter)}"
puts "250 grams воды в cups: #{RecipeUnitConverter.convert(250, :g, :cups, ingredient: :water)}"

# 5. Цепочный интерфейс Converter
converter = RecipeUnitConverter::Converter.new
result = converter.amount(5).from(:gallons).to(:liters)
puts "5 gallons в liters (через Converter): #{result}"
result2 = converter.amount(3).from('cups').to('oz')
puts "3 cups в ounces (через Converter): #{result2}"

# 6. Преобразования через методы Numeric
puts "4 teaspoons в milliliters: #{4.teaspoons.to(:milliliters)}"
puts "8 tbsp в fl_oz: #{8.tbsp.to(:fl_oz)}"
puts "3 pounds в kg: #{3.lbs.to(:kg)}"
puts "1 soda_can в cups: #{1.soda_can.to(:cup)}"

# 7. Работа с плотностями
puts "Плотность масла: #{RecipeUnitConverter.density_for(:oil)} г/мл"
RecipeUnitConverter.set_density(:oil, density: 0.95)
puts "Новая плотность масла: #{RecipeUnitConverter.density_for(:oil)} г/мл"

# 8. Добавление пользовательской единицы
RecipeUnitConverter.add_unit(:petit_verre, alias_name: :p_verres, to_ml: 100)
puts "1 petit_verre в ml: #{RecipeUnitConverter.convert(1, :petit_verre, :ml)}"
puts "2 p_verres в cups: #{RecipeUnitConverter.convert(2, :p_verres, :cup)}"

# 9. Список поддерживаемых единиц и алиасов
puts "Поддерживаемые единицы: #{RecipeUnitConverter.supported_units.sort.join(', ')}"
puts "Список алиасов: #{RecipeUnitConverter.unit_aliases.map { |k,v| "#{k}->#{v}" }.join(', ')}"

# 3 cups в milliliters: 720.0
# 2 quarts в gallons: 0.5000002641721769
# 500 grams в pounds: 1.1023122100918887
# 2 stone в kilograms: 12.70058
# 1 cup муки в grams: 141.6
# 2 tablespoons мёда в grams: 42.9
# 100 grams масла в tablespoons: 7.317965605561654
# 250 grams воды в cups: 1.0416666666666667
# 5 gallons в liters (через Converter): 18.92705
# 3 cups в ounces (через Converter): 25.397273320517115
# 4 teaspoons в milliliters: 20.0
# 8 tbsp в fl_oz: 4.05768678039461
# 3 pounds в kg: 1.360776
# 1 soda_can в cups: 1.4791666666666667
# Плотность масла: 0.92 г/мл
# Новая плотность масла: 0.95 г/мл
# 1 petit_verre в ml: 100.0
# 2 p_verres в cups: 0.8333333333333334
# Поддерживаемые единицы: barrel, bushel, carat, centiliter, centner, cup, deciliter, dessert_spoon, dram, drop, fluid_ounce, gallon, gill, grain, gram, ice_cream_scoop, imp_gallon, kilogram, liter, milligram, milliliter, ounce, petit_verre, pinch, pint, pound, quart, shot, soda_can, stick, stone, tablespoon, teaspoon, ton, wine_bottle, wine_glass
# Список алиасов: drops->drop, pinches->pinch, tsp->teaspoon, teaspoons->teaspoon, dst_spoon->dessert_spoon, dessert_spoons->dessert_spoon, tbsp->tablespoon, tablespoons->tablespoon, fl_oz->fluid_ounce, fluid_ounces->fluid_ounce, pony->pony, shots->shot, shot->shot, gill->gill, gills->gill, cup->cup, cups->cup, wine_glass->wine_glass, wine_glasses->wine_glass, ice_cream_scoop->ice_cream_scoop, scoops->ice_cream_scoop, pt->pint, pints->pint, qt->quart, quarts->quart, gal->gallon, gallons->gallon, imp_gal->imp_gallon, imp_gallon->imp_gallon, barrel->barrel, barrels->barrel, bushel->bushel, bushels->bushel, soda_can->soda_can, cans->soda_can, wine_bottle->wine_bottle, bottles->wine_bottle, ml->milliliter, milliliters->milliliter, cl->centiliter, centiliters->centiliter, dl->deciliter, deciliters->deciliter, l->liter, liters->liter, mg->milligram, milligrams->milligram, g->gram, grams->gram, ct->carat, carats->carat, dr->dram, drams->dram, gr->grain, grains->grain, oz->ounce, ounces->ounce, lb->pound, lbs->pound, pounds->pound, stick->stick, sticks->stick, kg->kilogram, kilograms->kilogram, stone->stone, stones->stone, centner->centner, cwt->centner, t->ton, ton->ton, tons->ton, p_verres->petit_verre
