;+
; NAME:
;  kepler3
; AUTHOR: Jan Marie Andersen
; PURPOSE: 
;    Use Kepler's 3rd law to calculate period from mass and orbital radius
; DESCRIPTION:
;   Calculates orbital period in years and days given a stellar mass
;   and semi-major axis of orbit for a planet
;
; CATEGORY:
;    Celestial Mechanics
; CALLING SEQUENCE:
;    kepler3, mass, a
; INPUTS: 
;   mass - stellar mass in Solar Masses
;   a - Semimajor axis or orbit in Astronomical Units
; REQUIREMENTS: 
;  none
; OPTIONAL INPUT PARAMETERS:
; KEYWORD INPUT PARAMETERS:
; OUTPUTS:
;   Prints planetary period in years and days to screen.  
; KEYWORD OUTPUT PARAMETERS:
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;   Created, Feb 2011, JMA 
;-

PRO kepler3, mass, a

G =  6.67384E-11
M_sun = 1.9891E30 
AU = 149597871.0*1000

P_test = DOUBLE(SQRT(DOUBLE(4*(!Pi)^2*(a*AU)^3.0 / DOUBLE(G*mass*M_sun))))

P = SQRT(DOUBLE((a^3.0)/mass))

print, P_test/(3600.0*24*365.25)
print, 'period in years: ', P
print, 'days: ', P*365.0

END
