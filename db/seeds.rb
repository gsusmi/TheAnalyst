items = [
  {
    name: "Bear Republic Racer V",
    item_type: 'American IPA',
    abv: 7,
    rating_score: 94
  },

  {
    name: "Brewer's Art Resurrection",
    item_type: 'Dubbel',
    abv: 7,
    rating_score: 87
  },

  {
    name: "Ommegang Adoration",
    item_type: 'Belgian Strong Dark Ale',
    abv: 10,
    rating_score: 90
  }
]

items.find_all { |item| !Item.first(name: item[:name]) }.each { |item|
  Item.create(item)
}
