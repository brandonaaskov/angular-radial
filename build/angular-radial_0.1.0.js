angular.module('fullscreen.radial', []);
angular.module('fullscreen.radial').directive('radial', function($timeout) {
  return {
    restrict: 'E',
    replace: true,
    template: '<canvas class="fullscreen-radial radial"></canvas>',
    scope: {
      radius: '=',
      lineWidth: '@',
      lineCap: '@',
      percentComplete: '=',
      bgColor: '@',
      color: '@',
      fontFamily: '@'
    },
    link: function(scope, element) {
      var addText, bgColor, canvas, clearCanvas, color, context, drawArc, drawBackground, drawMeter, edgeLength, fontFamily, getDegrees, getFontSize, getRadians, lineCap, lineWidth, radius, relativeFontSize, xCoord, yCoord;
      bgColor = 'c9e0f4';
      color = '4c98dc';
      radius = 100;
      lineWidth = 55;
      lineCap = 'butt';
      xCoord = void 0;
      yCoord = void 0;
      fontFamily = 'Monaco, Consolas, "Lucida Console", monospace';
      canvas = angular.element(element)[0];
      context = canvas.getContext('2d');
      if (scope.radius) {
        radius = scope.radius;
      }
      if (scope.lineWidth) {
        lineWidth = scope.lineWidth;
      }
      if (scope.lineCap) {
        lineCap = scope.lineCap;
      }
      if (scope.fontFamily) {
        fontFamily = scope.fontFamily;
      }
      if (scope.bgColor) {
        bgColor = scope.bgColor;
      }
      if (scope.color) {
        color = scope.color;
      }
      edgeLength = (radius + lineWidth) * 2;
      xCoord = radius + lineWidth;
      yCoord = radius + lineWidth;
      canvas.width = edgeLength;
      canvas.height = edgeLength;
      getDegrees = function() {
        if (!scope.percentComplete) {
          return;
        }
        return (scope.percentComplete * 360) / 100;
      };
      getRadians = function(degrees) {
        return degrees * Math.PI / 180;
      };
      relativeFontSize = 35;
      getFontSize = function() {
        return (radius + (lineWidth * 2)) * relativeFontSize / 100;
      };
      clearCanvas = function() {
        return canvas.width = canvas.width;
      };
      drawArc = function(startingAngleInDegrees, endingAngleInDegrees, arcColor) {
        var endAngle, startAngle;
        context.beginPath();
        context.strokeStyle = "#" + arcColor;
        context.lineWidth = lineWidth / 2;
        context.lineCap = lineCap;
        startAngle = getRadians(startingAngleInDegrees);
        endAngle = getRadians(endingAngleInDegrees);
        context.arc(xCoord, yCoord, radius, startAngle, endAngle);
        return context.stroke();
      };
      drawBackground = function() {
        return drawArc(-270, 90, bgColor);
      };
      drawMeter = function() {
        var endDegrees;
        clearCanvas();
        drawBackground();
        endDegrees = 90 + getDegrees(scope.percentComplete);
        drawArc(90, endDegrees, color);
        if (!(scope.percentComplete > 0)) {
          return;
        }
        addText(scope.percentComplete);
        return console.log('color', color);
      };
      addText = function() {
        var fontSize, percent;
        context.fillStyle = color;
        fontSize = getFontSize();
        context.font = "" + fontSize + "px " + fontFamily;
        context.textAlign = 'center';
        context.textBaseline = 'middle';
        percent = Math.round(scope.percentComplete);
        return context.fillText("" + percent + "%", xCoord, yCoord);
      };
      $timeout(function() {
        return drawMeter();
      });
      scope.$watch('percentComplete', function() {
        return drawMeter();
      });
      scope.render = drawMeter;
      return scope.clear = clearCanvas;
    }
  };
});
