% LQDDROP Calculates rate of lifting gas mass release
%   Inputs Current altitude, Valve cross-sectional area, pressure
%   differential
%   Returns single value, release rate of gas (kg/s)
function release = vrelease(altitude, area, pd)
    release = sqrt(2*pd*calculatedensity(altitude,'helium'))*area;