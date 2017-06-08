require "../src/shell-table"

table = ShellTable.new
table.labels = ["Col1", "Col2", "Col3", "Col4", "Col5"]
table.label_color = :yellow
table.border_color = :blue
10.times do |r|
  row = table.add_row
  5.times do |c|
    row.add_column "Row ##{r + 1}, Col ##{c + 1}"
  end
end

puts table
