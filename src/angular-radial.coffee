angular.module('gunslinger.radial', [])

angular.module('gunslinger.radial').directive 'radial', ($timeout) ->
  # private vars
  bgColor = 'c9e0f4'
  color = '4c98dc'
  canvas = undefined
  context = undefined
  radius = 100
  lineWidth = 55
  lineCap = 'butt' # butt, round, square
  xCoord = undefined
  yCoord = undefined
  fontFamily = 'Monaco, Consolas, "Lucida Console", monospace'

  restrict: 'E'
  replace: true
  template: '<canvas class="radial"></canvas>'
  scope:
    radius: '='
    lineWidth: '='
    lineCap: '@'
    percentComplete: '='
    bgColor: '@'
    color: '@'
    fontFamily: '@'

  link: (scope, element) ->
    canvas = angular.element(element).get(0)
    context = canvas.getContext '2d'
    radius = scope.radius if scope.radius
    lineWidth = scope.lineWidth if scope.lineWidth
    lineCap = scope.lineCap if scope.lineCap
    fontFamily = scope.fontFamily if scope.fontFamily
    bgColor = scope.bgColor if scope.bgColor
    color = scope.color if scope.color
    edgeLength = (radius + lineWidth) * 2
    canvas.width = edgeLength
    canvas.height = edgeLength
    # x/y coordinates are for the center of the circle
    xCoord = radius + lineWidth
    yCoord = radius + lineWidth

  controller: ($scope) ->
    getDegrees = (percent = $scope.percentComplete) ->
      return unless _.isNumber percent
      # 90º is actually straight down, so our starting point is 90
      return (percent * 360)/100

    getRadians = (degrees) -> degrees * Math.PI/180

    relativeFontSize = 35 # 35px is 100% for this
    getFontSize = -> (radius + (lineWidth * 2)) * relativeFontSize/100

    # this is the easiest way to clear a canvas
    clearCanvas = -> canvas.width = canvas.width

    # to understand what degrees represent what quadrant of the arc,
    # check out this handy image: http://cl.ly/Ugsu
    drawArc = (startingAngleInDegrees, endingAngleInDegrees, arcColor) ->
      context.beginPath()
      context.strokeStyle = "#" + arcColor
      context.lineWidth = lineWidth/2
      context.lineCap = lineCap
      startAngle = getRadians(startingAngleInDegrees)
      endAngle = getRadians(endingAngleInDegrees)
      context.arc xCoord, yCoord, radius, startAngle, endAngle
      context.stroke()

    drawBackground = -> drawArc -270, 90, bgColor #draws background well

    drawMeter = ->
      clearCanvas()
      drawBackground()
      endDegrees = 90 + getDegrees($scope.percentComplete)
      drawArc 90, endDegrees, color # draws "filled" arc on top
      return unless $scope.percentComplete > 0
      addText $scope.percentComplete # adds text in the middle

    addText = ->
      # Lets add the text
      context.fillStyle = color
      fontSize = getFontSize()
      context.font = "#{fontSize}px #{fontFamily}"
      context.textAlign = 'center'
      context.textBaseline = 'middle'
      percent = Math.round($scope.percentComplete)
      context.fillText "#{percent}%", xCoord, yCoord

    # if we resize after we've drawn the arc
    # (that's how the Canvas API is designed)
    $timeout -> drawMeter()

    $scope.drawMeter = drawMeter
    $scope.$watch 'percentComplete', -> drawMeter()