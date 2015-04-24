FUNCTION keplereqn, m, e
;+
; NAME:
;    keplereqn
; AUTHOR: Jan Marie Andersen
; PURPOSE: 
;    Solve Kepler's Equation in order to calculate RV curves
; DESCRIPTION:
;    Solve Kepler's Equation using the method by S. Mikkola (1987) Celestial
;       Mechanics, 40 , 329-334. 
;
; CATEGORY:
;    Celestial Mechanics
; CALLING SEQUENCE:
;    E=keplereqn(m,e)
; INPUTS:
;    m    - Mean anomaly (radians; can be an array)
;    e    - Eccentricity
; OPTIONAL INPUT PARAMETERS:
; KEYWORD INPUT PARAMETERS:
; OUTPUTS:
;    Function returns the eccentric anomaly
; KEYWORD OUTPUT PARAMETERS:
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;   Created, Oct 2012, JMA
;-

Mpi = M
; change range of M to -Pi < m <= Pi
mloc = WHERE(Mpi GT !dPi)
IF mloc(0) NE -1 THEN BEGIN
   Mpi(mloc) = Mpi(mloc) MOD (2*!dPi)
   mloc = WHERE(Mpi GT !dPi)
   IF mloc(0) NE -1 THEN Mpi(mloc) = Mpi(mloc) - 2.d0*!dPi
ENDIF

mloc = WHERE(Mpi LE -!dPi)
IF mloc(0) NE -1 THEN BEGIN
   Mpi(mloc) = Mpi(mloc) MOD (2*!dPi)
   mloc = WHERE(Mpi LE -!dPi)
   IF mloc(0) NE -1 THEN Mpi(mloc) = Mpi(mloc) + 2.d0*!dPi
ENDIF


; eccanom = M if no eccentricity
IF e EQ 0.0 THEN RETURN, Mpi


; define alpha and beta variables from Mikkola

alpha = (1.d0-e) / (4.d0*e + 0.5d0)
beta = (0.5d0*Mpi) / (4.d0*e + 0.5d0)

; find z from alpha and beta
z = (beta + SQRT( beta^2.d0 + alpha^3.d0) )^(1/3.d0)

nloc=where(z LE 0.0)
  IF nloc[0] NE -1 THEN z[nloc] = (beta[nloc] - SQRT( beta[nloc]^2.d0 + alpha[nloc]^3.d0) )^(1/3.d0)
;IF beta LT 0 then z = (beta - SQRT( beta^2.d0 + alpha^3.d0) )^(1/3.d0)

; find s
s = z - alpha/z

; add ds 
ds = -0.078d0*s^5.d0 / (1.d0 + e)
s = s + ds

; find E
E_anom = Mpi + e*(3.d0*s - 4.d0*s^3.d0)

  gloc = where(E_anom GE 2.0d0*!dPi)
  IF gloc[0] NE -1 THEN E_anom[gloc] = E_anom[gloc] - 2.0d0*!dPi
  lloc = where(E_anom LT 0.0)
  IF lloc[0] NE -1 THEN E_anom[lloc] = E_anom[lloc] + 2.0d0*!dPi

RETURN,E_anom
END
