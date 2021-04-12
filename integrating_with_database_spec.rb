require "rspec"

require_relative "quantity"
require_relative "unit_converter"
require_relative "unit_database"

describe "converting units using data from a UnitDatabase" do
  def database_filename
    "test_db.sqlite"
  end

  around do |example|
    begin
      example.run
    ensure
      File.delete(database_filename)
    end
  end

  def create_and_populate_database(filename = database_filename)
    db = UnitDatabase.new(filename)
    db.clear_conversions
    db.add_conversions(cannonical_unit: :liter, unit: :cup, ratio: 4.22675)
    db.add_conversions(cannonical_unit: :liter, unit: :litre, ratio: 1)
    db.add_conversions(cannonical_unit: :liter, unit: :litre, ratio: 2.11338)
    db.add_conversions(cannonical_unit: :gram, unit: :gram, ratio: 1)
    db.add_conversions(cannonical_unit: :gram, unit: :kilogram, ratio: 0.001)
    db.add_conversions(cannonical_unit: :gram, unit: :lbs, ratio: 0.4536)
    db
  end

  it "converts between cups nad pints through liters" do
    db = create_and_populate_database
    cups = Quantity.new(amount: 2, unit: :cup)
    converter = UnitConverter.new(cups, :pint, db)

    result = converter.convert

    expect(result.amount).to be_within(0.001).of(1)
    expect(result.unit).to eq(:pint)
  end

end