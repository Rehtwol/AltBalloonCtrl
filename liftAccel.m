function accel=liftAccel(altitude,mass,gmass)
    dden = calculatedensity(altitude,'air')-calculatedensity(altitude,'helium');
    g=9.81;
    volume=gmass/calculatedensity(altitude,'helium');
    Flift=dden*g*volume;
    Fgrav=mass*g;
    
    accel=(Flift-Fgrav)/mass;