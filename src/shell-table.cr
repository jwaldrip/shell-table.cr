require "colorize"

class ShellTable
  property labels : Row?
  property rows : Array(Row) = [] of Row
  property padding : Int32 = 1
  property border : Bool = true

  def initialize
  end

  def initialize(rows : Array(Array(String)), labels : Array(String), label_color : Symbol? = nil)
    self.labels = labels
    if l = self.labels
      l.color = label_color
    end
    rows.each { |columns| add_row columns }
  end

  def initialize(@rows, @labels = nil, label_color : Symbol? = nil)
    if labels
      labels.color = label_color
    end
  end

  def to_s(io : IO)
    puts_top_border(io)
    puts_labels(io)
    puts_rows(io)
    puts_bottom_border(io)
  end

  private def puts_labels(io : IO)
    return unless labels = @labels
    puts_row(io, labels)
    puts_row_border(io)
  end

  private def puts_rows(io : IO)
    rows.each_with_index do |row, row_index|
      puts_row(io, row)
      puts_row_border(io) if row_index != rows.size - 1
    end
  end

  private def puts_row(io : IO, row : Row)
    line = String.build do |str|
      max_columns.times do |col_index|
        column = row.columns[col_index]? || Column.new
        str.print "║" if col_index == 0 && border
        str.print "|" if col_index != 0
        print_padding(str) if col_index != 0 || border
        value = column.value.to_s.ljust(max_column_size_at col_index)
        color = column.color || row.color
        value = value.colorize(color) if color
        str.print value
        print_padding(str)
        str.print "║" if col_index == max_columns - 1 && border
      end
    end
    io.puts line
  end

  private def max_columns
    all_rows.map(&.columns.size).sort[-1]
  end

  private def max_column_size_at(index : Int32)
    all_rows.map(&.columns[index]?.to_s.size).sort[-1]? || 0
  end

  private def puts_top_border(io)
    puts_border(io, left: "╔", right: "╗", line: "═", sep: "╦")
  end

  private def puts_bottom_border(io : IO)
    puts_border(io, left: "╚", right: "╝", line: "═", sep: "╩")
  end

  private def puts_row_border(io : IO)
    puts_border(io, left: "╠", right: "╣", line: "─", sep: "┼")
  end

  private def print_padding(io : IO)
    io.print " " * padding
  end

  private def puts_border(io : IO, left : String, right : String, line : String, sep : String)
    return unless border
    line = String.build do |str|
      max_columns.times do |col_index|
        str.print left if col_index == 0
        str.print sep if col_index != 0
        str.print line * (max_column_size_at(col_index) + (padding * 2))
        str.print right if col_index == max_columns - 1
      end
    end
    io.puts line
  end

  def labels=(*args, **props)
    @labels = Row.new(*args, **props)
  end

  def all_rows
    ([labels] + rows).compact
  end

  def add_row(*args, **props)
    Row.new(*args, **props).tap { |row| @rows << row }
  end
end

require "./shell-table/row"
