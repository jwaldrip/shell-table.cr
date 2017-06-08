require "./column"

class ShellTable::Row
  property columns : Array(Column) = [] of Column
  property color : Symbol? = nil

  def initialize
  end

  def initialize(@columns)
  end

  def initialize(columns : Array(_))
    columns.each { |value| add_column value }
  end

  def add_column(*args, **props)
    @columns << Column.new(*args, **props)
  end
end
