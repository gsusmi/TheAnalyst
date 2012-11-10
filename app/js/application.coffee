jQuery.fn.sortElements = do ->
  sort = [].sort

  (comparator, getSortable) ->
    getSortable = getSortable ? -> this

    placements = @map(->
      sortElement = getSortable.call(this)
      parentNode = sortElement.parentNode

      # Since the element itself will change position, we have
      # to have some way of storing its original position in
      # the DOM. The easiest way is to have a 'flag' node:
      nextSibling = parentNode.insertBefore(
        document.createTextNode(''),
        sortElement.nextSibling
      )

      ->
        if parentNode is this
          throw new Error("You can't sort elements if any one is a descendant of another.")

        # Insert before flag:
        parentNode.insertBefore(this, nextSibling);
        # Remove flag:
        parentNode.removeChild(nextSibling);
    )

    sort.call(this, comparator).each((i) ->
      placements[i].call(getSortable.call(this)))

window.App =
  attachSortHandlers: ->
    $('#sort-top-rated').on('click', @sorter('rating', true))
    $('#sort-abv').on('click', @sorter('abv'))
    $('#sort-name').on('click', @sorter('name'))

  sorter: (extractorName, descending=false) ->
    extractorFn = @[extractorName]
    cachedExtractor = (e) ->
      value = $(e).data(extractorName)
      if !value
        value = { value: extractorFn(e) }
        $(e).data(extractorName, value)
      value.value

    comparator = (a, b) => @compare(cachedExtractor(a), cachedExtractor(b))
    if descending
      comparator = (a, b) => @compare(cachedExtractor(b), cachedExtractor(a))

    ->
      $('.controls a').removeClass('selected')
      $(this).addClass('selected')
      $('li.beer').sortElements(comparator)

  compare: (a, b) -> if a < b then -1 else if a > b then 1 else 0

  abv: (item) ->
    stat = $(item).find('.stat')
    match = stat.text().match(/(\d+(?:[.]\d+)?)%/)
    if match then parseFloat(match[1]) else 100

  rating: (item) ->
    rating = $(item).find('.rating')
    match = rating.text().match(/BA: (\d+)/)
    if match then parseInt(match[1], 10) else 0

  name: (item) ->
    $(item).find('.name').text().toLowerCase()

  sortABV: ->
    $('li.beer').sortElements((a, b) =>
      @compare(@abv(a), @abv(b)))
