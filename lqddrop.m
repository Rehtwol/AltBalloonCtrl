% LQDDROP Calculates rate of ballast mass release
%   Inputs Mass of ballast, Cross-sectional area of valve, Density of
%   ballast, Surface area of base of reservoir
%   Returns single value, release rate of ballast (kg/s)
function drop = lqddrop(mass,area2,density,surface)
    drop = area2*sqrt(2*((9.8*mass/surface)/density)/(1-(area2/surface)^2))*density;
    