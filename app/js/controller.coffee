window.Beers = ($scope) ->
  $scope.beers = App.beers

  $scope.abv = (beer) -> beer.abv || 100
  $scope.abv.key = 'abv'

  $scope.rating = (beer) -> beer.rating_score || 0
  $scope.rating.key = 'rating'

  $scope.orderKey = ->
    key = $scope.ordering.key
    if angular.isArray(key) then key[0] else key

  $scope.selectedCls = (key) ->
    if key == $scope.ordering.key then 'selected' else ''

  $scope.sort = (key, reverse=false) ->
    name = if typeof(key) == 'function' then key.name else key
    $('.controls a').removeClass('selected')
    $("#sort_#{name}").addClass('selected')

    if key != 'name'
      key = [key, if reverse then '-name' else 'name']
    $scope.ordering = (key: key, reverse: reverse)

  $scope.sort($scope.rating, true)
