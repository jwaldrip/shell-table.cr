require "../src/shell-table"

table = ShellTable.new(
  labels: ["First Name", "Last Name", "Age"],
  label_color: :yellow,
  rows: [
    ["Jason", "Waldrip", "30"],
    ["Brian", "Dilts", "36"],
  ]
)

puts table
