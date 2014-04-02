angular.module 'fullscreen.radial', []

angular.module('fullscreen.radial').directive 'radial', ($timeout) ->
  restrict: 'E'
  replace: true
  template: '<canvas class="fullscreen-radial radial"></canvas>'
  scope:
    radius: '='
    lineWidth: '='
    lineCap: '@'
    percentComplete: '='
    bgColor: '@'
    color: '@'
    fontFamily: '@'

  link: (scope, element) ->
    bgColor = 'c9e0f4'
    color = '4c98dc'
    radius = 100
    lineWidth = 55
    lineCap = 'butt' # butt, round, square
    xCoord = undefined
    yCoord = undefined
    fontFamily = 'Monaco, Consolas, "Lucida Console", monospace'
    canvas = angular.element(element)[0]
    context = canvas.getContext '2d'

    radius = scope.radius if scope.radius
    lineWidth = scope.lineWidth if scope.lineWidth
    lineCap = scope.lineCap if scope.lineCap
    fontFamily = scope.fontFamily if scope.fontFamily
    bgColor = scope.bgColor if scope.bgColor
    color = scope.color if scope.color
    edgeLength = (radius + lineWidth) * 2

    # x/y coordinates are for the center of the circle
    xCoord = radius + lineWidth
    yCoord = radius + lineWidth

    # set width/height
    canvas.width = edgeLength
    canvas.height = edgeLength

    getDegrees = ->
      return unless angular.isNumber(scope.percentComplete)
      return (scope.percentComplete* 360)/100

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

    drawBackground = -> drawArc -270, 90, bgColor # draws background arc

    drawMeter = (percent) ->
      clearCanvas()
      drawBackground()
      endDegrees = 90 + getDegrees(percent)
      drawArc 90, endDegrees, color # draws "filled" arc on top
      addText percent # adds text in the middle

    addText = (percent) ->
      # Lets add the text
      context.fillStyle = color
      fontSize = getFontSize()
      context.font = "#{fontSize}px #{fontFamily}"
      context.textAlign = 'center'
      context.textBaseline = 'middle'
      percent = Math.round percent
      context.fillText "#{percent}%", xCoord, yCoord

    # if we resize after we've drawn the arc
    # (that's how the Canvas API is designed)
    $timeout -> drawMeter(scope.percentComplete)
    scope.render = drawMeter
    scope.clear = clearCanvas
    scope.$watch 'percentComplete', (percent) -> drawMeter percent
