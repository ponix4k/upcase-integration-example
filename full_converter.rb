require "rspec/autorun"
# UnitConverter.new.convert(2, :cup, :liter) # => 0.473
# unitConverter.new.convert(2, :cup, :gram) # DimensionalMismatchError!!!

DimensionalMismatchError = Class.new(StandardError)

Quantity = Struct.new(:amount, :unit)

class UnitConverter
  def initialize(initial_quantity, target_unit)
    @initial_quantity = initial_quantity
    @target_unit = target_unit

  end

  def convert
    Quantity.new(
    @initial_quantity.amount * conversion_factor(from: @initial_quantity.unit, to: @target_unit),
    @target_unit
  )
  end

  private

  CONVERSION_FACTORS = {
    liter: {
      cup: 4.226775,
      liter: 1,
      pint: 2.11338
    },
    gram: {
      gram: 1,
      kilogram: 0.001
    }
  }


  def conversion_factor(from:, to:)
    dimension = common_dimension(from, to)
    if !dimension.nil?
    CONVERSION_FACTORS[dimension][to] / CONVERSION_FACTORS[dimension][from]
    else
      raise(DimensionalMismatchError, "Can't convert from #{from} to #{to}!")
    end
  end

  def common_dimension(from, to)
    CONVERSION_FACTORS.keys.find do |cannonical_unit|
      CONVERSION_FACTORS[cannonical_unit].keys.include?(from) &&
        CONVERSION_FACTORS[cannonical_unit].keys.include?(to)
    end
  end
end

# Test 1
describe UnitConverter do
  describe "#convert" do
    it "translates between objects of the same dimension" do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :liter)

      result = converter.convert

      expect(result.amount).to be_within(0.001).of(0.473)
      expect(result.unit).to eq(:liter)
    end
# Test 2
    it "can convert between quantities of the same unit" do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :cup)

      result = converter.convert

      expect(result.amount).to be_within(0.001).of(2)
      expect(result.unit).to eq(:cup)
    end
# Test 3
    it "rasies an error if the two quatities are of differing dimensions" do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :gram)

      expect { converter.convert }.to raise_error(DimensionalMismatchError)
    end
  end
end