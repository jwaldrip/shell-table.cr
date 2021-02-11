require "colorize"

class ShellTable
  property labels : Row?
  property rows : Array(Row) = [] of Row
  property padding : Int32 = 1
  property border : Bool = true
  property border_color : Symbol? = nil

  def initialize
  end

  def initialize(rows, labels : Array(String), label_color : Symbol? = nil)
    self.labels = labels
    self.label_color = label_color
    rows.each { |columns| add_row columns }
  end

  def initialize(@rows, @labels = nil, label_color : Symbol? = nil)
    self.label_color = label_color
  end

  def to_s(io : IO)
    puts_top_border(io)
    puts_labels(io)
    puts_rows(io)
    puts_bottom_border(io)
  end

  def labels=(labels)
    @labels = Row.new(labels)
  end

  def label_color=(color : Symbol)
    if l = self.labels
      l.color = color
    end
  end

  def all_rows
    ([labels] + rows).compact
  end

  def add_row(*args, **props)
    Row.new(*args, **props).tap { |row| @rows << row }
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
        print_vertical_border(str, char = '║') if col_index == 0 && border
        print_vertical_border(str, char = '|') if col_index != 0
        print_padding(str) if col_index != 0 || border
        value = column.value.to_s.ljust(max_column_size_at(col_index) + column.ansi_delta)
        color = column.color || row.color
        value = value.colorize(color) if color
        str.print value
        print_padding(str)
        print_vertical_border(str, char = '║') if col_index == max_columns - 1 && border
      end
    end
    io.puts line
  end

  private def max_columns
    all_rows.map(&.columns.size).sort[-1]
  end

  private def max_column_size_at(index : Int32)
    all_rows.map(&.columns[index].not_nil!.size).sort[-1]? || 0
  end

  private def puts_top_border(io)
    puts_border(io, left: "╔", right: "╗", line: "═", sep: "╦")
  end

  private def print_vertical_border(io, char = '|')
    str = char.to_s
    if border_color = @border_color
      str = str.to_s.colorize(border_color)
    end
    io.print str
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
    if border_color = @border_color
      line = line.to_s.colorize(border_color)
    end
    io.puts line
  end
end

require "./shell-table/row"
