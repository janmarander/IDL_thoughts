;+
; NAME:
;  pical
; PURPOSE: 
;  Approximate Pi using the Buffon's needle method
;
; DESCRIPTION:
;  Simulates the drop of a number of needles randomly on a surface of
;  parallel lines spaced a needle's length apart. Calculates an
;  approximate value for Pi using pi_approx = 2 *
;  total_drops/total_crosses where total_crosses is equal to the
;  number of needles that cross a line. Creates a plot showing the
;  needles land and their orientation. (see
;  http://en.wikipedia.org/wiki/Buffon's_needle) 
;  
; CATEGORY:
;  Recreational Math
; CALLING SEQUENCE:
;  pical, num
; INPUTS:
;  num - number of needles to drop
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;
; KEYWORD OUTPUT PARAMETERS:
; 
; OUTPUTS:
;  Return value of approximation for Pi
; COMMON BLOCKS:
;  None.
; SIDE EFFECTS:
; RESTRICTIONS:
;  Input must be a decimal number
; PROCEDURE:
; MODIFICATION HISTORY:
;  Written 2015 March, by Jan Marie Andersen
;-

pro pical, num

; lay out parallel lines spaced pin_length apart
pin_length = 1

;ps, /ON

linethick = 3
PLOT, [0,10],[1,1], XRANGE = [0,10], YRANGE = [0,10], XMINOR=1, YMINOR=1, XTICKS=1, YTICKS=1, THICK = linethick
OPLOT, [0,10],[2,2], THICK = linethick
OPLOT, [0,10],[3,3], THICK = linethick
OPLOT, [0,10],[4,4], THICK = linethick
OPLOT, [0,10],[5,5], THICK = linethick
OPLOT, [0,10],[6,6], THICK = linethick
OPLOT, [0,10],[7,7], THICK = linethick
OPLOT, [0,10],[8,8], THICK = linethick
OPLOT, [0,10],[9,9], THICK = linethick

; loop N times
total_drops = num ;28000
total_crosses = 0.0D

Seed = Systime(1)

FOR i=1.0D,total_drops DO BEGIN
; generate random x,y point for center of pin
   center = (RANDOMN(Seed, 2)+5.2) ;*10.0D ;Normal distribution of pin centers
   center = (RANDOMU(Seed, 2))*10.0D ;Uniform distribution
;   print, center
 
; generate second random x,y point for pin orientation
   secondpin = RANDOMU(Seed, 2)*10.0D

; find equation for line connecting the 2 points
   m = (center(1) - secondpin(1))/(center(0) - secondpin(0))
   b = center(1) - m*(center(0))

; find gridlines above and below point
   lowerline = FLOOR(center(1))
   upperline = lowerline + 1.0D

; find point that intersects with gridline and line equation
   upperx = (upperline - b)/m
   lowerx = (lowerline - b)/m

   
; use distance formula to find out if said point is more than length/2
; from pin center
   d = pin_length/2.0D
   linecolor = 'green'
   dupper = SQRT((center(1) - upperline)^2 + (center(0) - upperx)^2)
   
; check if pin overlaps line
   IF dupper LE d THEN BEGIN
; increment counter  
      total_crosses++
      linecolor = 'red'
   ENDIF

   dlower = SQRT((center(1) - lowerline)^2 + (center(0) - lowerx)^2)
   IF dlower LE d THEN BEGIN
; increment counter  
      total_crosses++
      linecolor = 'red'
   ENDIF

 
;PLOT LINES
; Can use SIN to find exact length of lines since this is just for visualization
; (plot in red if crosses and white if not)

   Theta = ASIN((center(1) - upperline)/dupper)
   ydist = SIN(Theta)*d
   endy_up = center(1) + ydist 
   endy_down = center(1) - ydist 
   endx_up = (endy_up - b)/m
   endx_down = (endy_down - b)/m

   OPLOT, [endx_up, endx_down],[endy_up, endy_down], COLOR = CGCOLOR(linecolor), THICK = 4

ENDFOR

; calculate pi
piapprox = (2.0D * total_drops)/total_crosses

XYOUTS, 0.5,0.5, 'Number of pins: ' + STRTRIM(STRING(total_drops),1)
XYOUTS, 7.0,0.5, 'Value: ' + STRTRIM(STRING(piapprox),1)

; display pi 
print, total_crosses
print, piapprox

;ps, /off

end
