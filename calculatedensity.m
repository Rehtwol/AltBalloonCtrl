function density = calculatedensity(altitude, type)
    if strcmp('air', type)
        rspecific=287.05; %(kgm^3)
    elseif strcmp('helium', type)
        rspecific = 2077; %(kgm^3)
    end
    pressure = lookup_pressure(altitude);
    %makes the assumption that pressure inside the balloon is equal to exterior
    %pressure.
    %makes the assumption that temperature inside the balloon is equal to
    %exterior temperature .
    density = pressure(1)/(rspecific*pressure(2));