function temperature = lookup_exttemp (altitude)
L = 0.0065; %Temperature Lapse Rate (K/m)
T0 = 288.15; %Sea level standard temperature
temperature = T0 - (L*altitude);