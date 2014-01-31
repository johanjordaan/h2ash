define ['jquery','angular'],($,angular) ->
  return ($compile,$http) ->
    restrict    : 'E',
    transclude  : true,
    #scope       : {}
    controller  : ($scope,$http,$compile,$element) ->
      $scope.windows = []

      this.add_window = (window) ->
        $scope.windows.push window
    
      this.add_window_from_url = (url) ->
        $http.get(url).then (result) ->
          angular.element($element).append($compile(result.data)($scope))

      return 

    link : (scope,element,attrs) ->    
      scope.add_window = (url) ->
        $http.get(url).then (result) ->
          element.append($compile(result.data)(scope))
        return
      scope.add_error = (message) ->
        scope.error_message = message


    ,templateUrl: 'partials/workspace.html'