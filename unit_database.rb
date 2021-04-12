require "sqlite3"
require_relative "quantity"

DimensionalMismatchError = Class.new(StandardError)

class UnitDatabase
  def initialize(database_filename)
    @db = find_or_create_db(database_filename)
  end

  def add_converstion(cannonical_unit:, unit:, ratio:)
    db.execute(
      "INSERT INTO conversion VALUES (?, ?, ?)",
      [cannonical_unit.to_s, unit.to_s, ratio]
    )
  end

  def conversion_ratio(from:, to:)
    rows = db.execute(
      "SELECT * FROM conversions WHERE unit IN (?, ?)",
      [from.to_s, to.to_s]
    )
    base_unit = common_unit(rows)
    from_row = rows.find { |row| row[0] == base_unit && row[1] == from.to_s }
    to_row = rows.find { |row| row[0] == base_unit && row[1] == to.to_s }

    if from_row && to_row
      to_row[2] / from_row[2]
    else

    end
  end
end