;+
; NAME:
;   RVgen
; AUTHOR: Jan Marie Andersen
; PURPOSE: 
;    Generate stellar radial velocity curves from system parameters 
; DESCRIPTION:
;   Specify system parameters such as planet mass, stellar mass,
;   period, eccentricity, inclination, and longitude, and the
;   resulting radial velocity curve is generated.
;
; CATEGORY:
;    Celestial Mechanics
; CALLING SEQUENCE:
;    RVgen
; INPUTS: 
;    M_p_E - Mass of planet in Earth masses
;    M_star_SO - Mass of star in Solar masses
;    P_pl_day - Period of planet in days
;    e - eccentricity
;    num_p - number of orbital periods of planet
;    no_phase - number of observational "phase"
;    phase_pl - phases of planet
;    inc - stellar inclination
; REQUIREMENTS: 
;   Procedure calls the function KEPLEREQN.PRO to solve the Kepler
;   Equation
; OPTIONAL INPUT PARAMETERS:
; KEYWORD INPUT PARAMETERS:
; OUTPUTS:
; KEYWORD OUTPUT PARAMETERS:
; COMMON BLOCKS: 
;   planet, RVall, RVph, tall, tph
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;   Created, Oct 2012, JMA 
;   Modified, Jan 2012, HK (added some common blocks to use with other code)
;-

PRO RVplanet, M_p_E, M_star_SOL, P_pl_day, e, num_p, no_p, phase_pl, inc

; define variables:

;COMMON planet, RVall, RVph, tall, tph

no_phase = no_p
print, no_p, 'no,phase'

;### INPUT VARIABLES
i_deg = inc ;degrees, orbital inclination (viewing angle), now set to stellar 
;inclination 
omega_star_d = 180.  ;degrees, argument of periastron "longitude" 
a_AU = -1   ;AU, semimajor axis of planet (specify this OR period--if period is
                                ;set to -1, code will calculate the
                                ;period from this value using
                                ;Kepler's 3rd law

;### END INPUT VARIABLES

  T_p = 0        ;s, time of periastron (arbitrary in this case--not necessary)

  G = 6.67400D-11               ;m^3/(kg s^2), Gravitational constant
  M_Earth = 5.97219D24          ;kg, Earth mass
  M_Sun = 1.989D30              ;kg, Solar mass


  a = a_AU * (149597871000d)    ;m, semimajor axis in m (converted from AU) 
  P = P_pl_day * 24.0 * 3600.0     ;s, period of system in seconds 
  i = i_deg * !Pi / 180.0       ;rad, inclination in radians
  M_star = M_star_SOL * M_Sun   ;kg, mass of star
  M_p = M_p_E * M_Earth         ;kg, mass of planet
  omega_star = omega_star_d*(!Pi/180.0) ;rad, argument of periastron in radians 

; create a time array
;  num_p = 2                     ;number of periods 
  nt = 100.                     ;number of time steps ("phases"?)
  tminm = 0.                    ;min time, s
  tmaxm = num_p * P             ;max time, s
  tsec = dindgen(nt)/(nt-1.) * (tmaxm - tminm) + tminm

  thr = tsec / 3600.            ;time, hr (?d, min, year?)
  dthr = thr(1)-thr(0)          ;time spacing, hr

  tph_sec = phase_pl*P_pl_day*24.*3600.
  tph = phase_pl*P_pl_day

  PRINT, 'RV Planet phase'
  PRINT, phase_pl

; Period from semi-major axis using Kepler's 3rd: (check if
; period is specified, if not calculate period from semimajor axis) 
  IF P LT 0 THEN P = DOUBLE(sqrt( (4*!Pi^2 / ( G * (DOUBLE(M_p) + DOUBLE(M_star)) )) * DOUBLE(a)^3))

; Find RV semi-amplitude:
  K = DOUBLE( ( (2.0*!Pi*G) / (P*(DOUBLE(M_star) + DOUBLE(M_p))^2.0) )^(1.0/3.0) * ( M_p*SIN(i)/SQRT(1 - e^2)) )

 nt = MAX([nt, no_phase])

  M_anom = DBLARR(nt)
  E_anom = DBLARR(nt)
  theta = DBLARR(nt)
  RV = DBLARR(nt)
  RVph = DBLARR(nt)

; t-loop for time
  FOR t=0, nt-1 DO BEGIN
     time = tsec(t)
     Mo = (2*!Pi/P)*(time - T_p)
     M_anom(t) = Mo

; SOLVE NUMERICALLY TO GET E(t)...  (this sucks)
; M(t) = E(t) - e*sin(E(t)) 
     E_anom(t) = keplereqn(M_anom(t), e)

     theta(t) = 2 * ATAN( SQRT( (1+e)/(1-e) ) * TAN( E_anom(t)/2.0 ) ) 

;RV(t) = K*COS(theta(t) + omega_star) + gamma + gamma_dot(t - t_0)
     RV(t) = K*COS(theta(t) + omega_star) + e*COS(omega_star) ;got rid of gammas

  ENDFOR

; t-loop for time
  t=0 & FOR t=0, no_phase-1 DO BEGIN
     time = tph_sec(t)
     Mo = (2*!Pi/P)*(time - T_p)
     M_anom(t) = Mo

; SOLVE NUMERICALLY TO GET E(t)...  (this sucks)
; M(t) = E(t) - e*sin(E(t)) 
     E_anom(t) = keplereqn(M_anom(t), e)

     theta(t) = 2 * ATAN( SQRT( (1+e)/(1-e) ) * TAN( E_anom(t)/2.0 ) ) 

;RV(t) = K*COS(theta(t) + omega_star) + gamma + gamma_dot(t - t_0)
     RVph(t) = K*COS(theta(t) + omega_star) + e*COS(omega_star) ;got rid of gammas

  ENDFOR

END
