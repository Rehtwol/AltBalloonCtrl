function release = vrelease(altitude, area, pd)

    release = sqrt(2*pd*calculatedensity(altitude,'helium'))*area;