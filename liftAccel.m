% LIFTACCEL calculates acceleration of given system
%   Inputs: current altitude (m), all-up mass (kg), mass of lifting gas (kg),
% vertical velocity of system (m/s)
%   Output: one-dimensional array containing: acceleration in m/s^2,
%   buoyancy, gravitational, and drag forces (N)
function accel=liftAccel(altitude,mass,gmass,vel)
    %Determine densities of air and lifting gas (here helium)
    denair = calculatedensity(altitude,'air');
    dengas = calculatedensity(altitude,'helium');
    dden = denair-dengas;
    
    g=9.81;
    
    %Calculate volume of balloon and diameter of projected area
    volume=gmass/dengas;
    radius = nthroot(0.75*volume/pi,3);
    diameter=2*radius;
    
    %Calculate buoyancy and gravitational forces
    Fbuoy=dden*g*volume;
    Fgrav=mass*g;
    
    %Determine drag force
    pressure=lookup_pressure(altitude);
    visc=1.458e-6*sqrt(pressure(2))/(1+110.4/pressure(2));
    Re=denair*vel*diameter/visc;
    Cd = lookup_cd(abs(Re));
    A = pi*(diameter/2)^2;
    Fdrag = 0.5*denair*vel^2*Cd*A*sign(vel);
    
    %Define returned values
    accel(1)=(Fbuoy-Fgrav-Fdrag)/mass;
    accel(2:4)=[Fbuoy,Fgrav,Fdrag];