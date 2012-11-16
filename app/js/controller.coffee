window.Beers = ($scope) ->
  $scope.beers = App.beers

  $scope.orderKey = ->
    key = $scope.ordering.key
    if angular.isArray(key) then key[0] else key

  $scope.selectedCls = (key) ->
    if key == $scope.orderKey() then 'selected' else ''

  $scope.sort = (key, reverse=false) ->
    name = if typeof(key) == 'function' then key.name else key
    if key != 'name'
      key = [key, if reverse then '-name' else 'name']
    $scope.ordering = (key: key, reverse: reverse)

  sorter = (key, fn) -> fn.key = key; $scope.sort[key] = fn

  sorter('abv', (beer) -> beer.abv || 100)
  sorter('rating', (beer) -> beer.rating_score || 0)

  $scope.sorters = [
    { title: 'Name', key: 'name' },
    { title: 'Rating', key: $scope.sort.rating, reverse: true },
    { title: 'ABV', key: $scope.sort.abv }
  ]

  $scope.sort('name')
