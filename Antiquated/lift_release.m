function release = lift_release(altitude, area, pd)
    release = vrelease(altitude, area, pd)*(calculatedensity(altitude,'air')-calculatedensity(altitude,'helium'));