% Based on code from Ben Oxley, 2012
% CALCULATEDENSITY Calculates density of given gas at altitude
%   Possible gasses are 'air', 'helium', and 'hydrogen'
%   Returns single value. 0 if type is not valid
%   
%   Written by Anthony Lowther, 2016
function density = calculateDensity(altitude, type)
    if strcmp('air', type)
        rspecific = 287.1;
    elseif strcmp('helium', type)
        rspecific = 2077;
    elseif strcmp('hydrogen', type)
        rspecific = 4124;
    else
        density = 0;
        return
    end
    pressure = lookup_pressure(altitude);
    %makes the assumption that pressure inside the balloon is equal to exterior
    %pressure.
    %makes the assumption that temperature inside the balloon is equal to
    %exterior temperature .
    density = pressure(1)/(rspecific*pressure(2));