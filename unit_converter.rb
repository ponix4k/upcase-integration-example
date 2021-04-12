require_relative "quantity"

class UnitConverter
  def initialize(initial_quantity, target_unit, conversion_database)
    @initial_quantity = initial_quantity
    @target_unit = target_unit
    @conversion_database = conversion_database
  end

  def convert
    Quantity.new(
      amount: initial_quantity.amount * conversion_ratio,
      unit: target_unit
    )
  end

  private

  attr_reader :conversion_database, :initial_quantity, :target_unit

  def conversion_ratio
    conversion_database.conversion_ratio(
      from: initial_quantity.unit,
      to: target_unit
    )
  end
end