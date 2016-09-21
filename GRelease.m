% GRELEASE Calculates rate of lifting gas mass release
%   Inputs Current altitude, Valve cross-sectional area, pressure
%   differential
%   Returns single value, release rate of gas (kg/s)
%   
%   Written by Anthony Lowther, 2016
function release = GRelease(altitude, area, pd)
    release = sqrt(2*pd*calculateDensity(altitude,'helium'))*area;