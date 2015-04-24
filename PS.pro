;+
; NAME:
;  ps
; AUTHOR: Mark Zastrow, Jan Marie Andersen
; PURPOSE: 
;    Sets device for generating postscript output
;
; DESCRIPTION:
;   Sets plotting device to 'ps' and sets up all parameters so
;   you don't have to do it manually every time you want to
;   create a .ps or .eps file. Accepts various keywords for
;   customizing output. 
;
; CATEGORY: Data visualization
;
; CALLING SEQUENCE:
;    ps, /ON
;    <plot things>
;    ps, /OFF
;
; INPUTS:
;  keyword /ON or /OFF
;
; OPTIONAL INPUT PARAMETERS:
;  NAME: filepath and name to save output file (default = '~/Desktop/plot.eps')
;  XSIZE: set the width of the image (default = 10.5) 
;  YSIZE: set height of image (default = xsize/aspect_ratio)
;  CT: colortable to use (default = 39)
;  ASPECT: set aspect ratio (default = 1.4)
;
; KEYWORD INPUT PARAMETERS:
;   /ON 
;   /OFF
;   /eps: make eps file instead of ps file.
;    
; OUTPUTS:
;    generates a .ps or .eps image of whatever is plotted between
;    calls with /ON and /OFF keywords
;
; KEYWORD OUTPUT PARAMETERS:
; COMMON BLOCKS:
; SIDE EFFECTS:
;
; RESTRICTIONS:
;   must call using /OFF keyword to finish output
;
; PROCEDURE:
;
; MODIFICATION HISTORY: created 2011, Mark Zastrow
;   modified 15 Jan 2014 to add NAME input keyword, Jan Marie Andersen
;   modified 25 Feb 2014 to add XSIZE, YSIZE, CT, and ASPECT input
;   keywords, Jan Marie Andersen 
;   edited 05 March 2014 to clean up a few bugs and change default
;   parameters, Jan Marie Andersen
;
;-

pro ps, ON = on, OFF = off, EPS = eps, NAME = name, XSIZE = xsize, YSIZE = ysize, CT = ct, ASPECT = aspect

if keyword_set(on) then begin
   aspect_ratio=1.4
   if keyword_set(aspect) then aspect_ratio=aspect
   print, aspect_ratio
   ;sizex = 10.5
   sizex = 18
   if keyword_set(xsize) then sizex = xsize
   color = 39
   if keyword_set(ct) then color = ct
   
   if keyword_set(name) then begin
      psname = name
   endif else begin
      psname = '~/Desktop/plot.ps'
       if keyword_set(eps) then psname = '~/Desktop/plot.eps'
   endelse
   
   if keyword_set(ysize) then begin
      sizey = ysize
      offset = (27.94-sizey)/2
   endif else begin
      sizey=sizex/aspect_ratio
   endelse

   set_plot, 'ps'
   mydevice=!d.name
   !p.font=0
   device, filename=psname, /color, bits=24
   if keyword_set(eps) then device, /encapsul
   if keyword_set(ysize) then device, ysize=sizey, YOFFSET = offset
   if keyword_set(xsize) then device, xsize=sizex
   device, xsize=sizex
   device, ysize=sizey
   if keyword_set(ysize) then device, YOFFSET = offset

;   device, XOFFSET = -50

   loadct, color, /silent
     
endif

if keyword_set(off) then begin
   device, /close
   set_plot, 'x'
   !p.font=-1
endif

end
