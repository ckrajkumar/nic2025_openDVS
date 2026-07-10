# Dump KLayout LVS report database to plain text
# Usage: klayout -b -rd lvsdb=path -rd out=path -r dump_lvs_report.rb

lvsdb = $lvsdb || ARGV[0]
out   = $out   || ARGV[1]

unless lvsdb && out
  puts "usage: klayout -b -rd lvsdb=FILE -rd out=FILE -r dump_lvs_report.rb"
  exit 2
end

db = RBA::ReportDatabase::new
db.load(lvsdb)

File.open(out, "w") do |f|
  f.puts "LVS report: #{lvsdb}"
  f.puts "Description: #{db.description}"
  f.puts "Original file: #{db.original_file}"
  f.puts "Generator: #{db.generator}"
  f.puts "Cells: #{db.num_cells}"
  f.puts

  db.each_cell do |cell|
    f.puts "=" * 72
    f.puts "Cell: #{cell.name}"
    f.puts "-" * 72
    cell.each_category do |cat|
      items = cat.each_item
      count = items.size
      next if count == 0
      f.puts "[#{cat.name}] (#{count} item(s))"
      items.each_with_index do |item, i|
        break if i >= 100
        f.puts "  #{item.to_s}"
      end
      f.puts "  ... (#{count - 100} more)" if count > 100
    end
    f.puts
  end
end

puts "Wrote #{out}"
