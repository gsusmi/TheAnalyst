names = ["Bear Republic Racer V",
         "Brewer's Art Resurrection",
         "Ommegang Adoration"]

names.find_all { |name| !Item.first(name: name) }.each { |name|
  Item.create(name: name)
}
