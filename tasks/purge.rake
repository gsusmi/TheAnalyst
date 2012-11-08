task :purge do
  all_items = Item.all
  STDERR.puts "Purging #{all_items.size} items"
  all_items.each { |i| i.destroy }
end
