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
    event = 'mousedown'
    $('#sort-top-rated').on(event, @sorter('rating', true))
    $('#sort-abv').on(event, @sorter('abv'))
    $('#sort-name').on(event, @sorter('name'))
    $('#sort-top-rated').trigger(event)

  chainedSorts: (extractors...) ->
    seen_extractors = { }
    filtered_extractors =
      for extractor in extractors when !seen_extractors[extractor[0]]
        seen_extractors[extractor] = true
        extractor
    sorters = (@sortComparator(ex[0], ex[1]) for ex in filtered_extractors)
    (a, b) ->
      for s in sorters
        result = s(a, b)
        return result if result
      0

  sortComparator: (extractorName, descending=false) ->
    extractorFn = @[extractorName]
    cachedExtractor = (e) ->
      value = $(e).data(extractorName)
      if !value
        value = (value: extractorFn(e))
        $(e).data(extractorName, value)
      value.value

    comparator = (a, b) => @compare(cachedExtractor(a), cachedExtractor(b))
    if descending
      comparator = (a, b) => @compare(cachedExtractor(b), cachedExtractor(a))
    comparator

  sorter: (extractorName, descending=false) ->
    comparator = @chainedSorts([extractorName, descending], ['name'])
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
