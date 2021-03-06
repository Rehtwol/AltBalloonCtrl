% Initially based on code from Ben Oxley, 2012
% LOOKUP_PRESSURE Calculates pressure and temperature in ISA at given
%   geometric altitude
%   Returns 2x1 matrix, Pressure (Pa) and Temperature (K)
%   
%   Written by Anthony Lowther, 2016
function press = lookup_pressure(altitude)
    R = 287.1; %Specific gas constant for dry air (J/(mol*K))
    gravity = 9.8; %Gravity
    re = 6371e3; %Mean radius of Earth
    press = [0,0]; %Instantiate output matrix
     
    H = (re*altitude)/(re+altitude); %Calculate geopotential height based on geometric altitude
    
    %Determine the applicable layer of the atmosphere
    if H<11000
        c=0;
    elseif H<20000
        c=1;
    elseif H<32000
        c=2;
    elseif H<47000
        c=3;
    elseif H<50000
        c=4;
    else
        press=[0,0];
        return;
    end
    
    %Based on applicable layer, set the layer's base conditions
    switch c
        case 0
            h0=0;
            L=-6.5e-3;
            T0=288.15;
            P0=101325;
        case 1
            h0=11000;
            L=0;
            T0=216.65;
            P0=2.2632e+04;
        case 2
            h0=20000;
            L=1.0e-3;
            T0=216.65;
            P0=5.47487e+03;
        case 3
            h0=32000;
            L=2.8e-3;
            T0=228.65;
            P0=868.014;
        case 4
            h0=47000;
            L=0.0;
            T0=270.65;
            P0=110.906;
        otherwise
            press=[0,0];
            return;
    end
    
    Temperature = T0+L*(H-h0); %Calculate temperature at given height
    
    %Based on whether the lapse rate is non-zero, calcuate pressure at
    %height
    if L~=0
        Pressure = P0*(Temperature/T0)^(-gravity/(R*L));
    else
        Pressure = P0*exp(-gravity*(H-h0)/(R*T0));
    end
    
    %Values to return
    press=[Pressure,Temperature];
end