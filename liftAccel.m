function accel=liftAccel(altitude,mass,gmass,vel)
    denair = calculatedensity(altitude,'air');
    dengas = calculatedensity(altitude,'helium');
    dden = denair-dengas;
    g=9.81;
    volume=gmass/dengas;
    radius = nthroot(0.75*volume/pi,3);
    diameter=2*radius;
    Flift=dden*g*volume;
    Fgrav=mass*g;
    
    pressure=lookup_pressure(altitude);
    visc=1.458e-6*sqrt(pressure(2))/(1+110.4/pressure(2));
    Re=denair*vel*diameter/visc;
    Cd = lookup_cd(abs(Re));
    A = pi*(diameter/2)^2;
    Fdrag = 0.5*denair*vel^2*Cd*A*sign(vel);
    
    accel(1)=(Flift-Fgrav-Fdrag)/mass;
    accel(2:4)=[Flift,Fgrav,Fdrag];