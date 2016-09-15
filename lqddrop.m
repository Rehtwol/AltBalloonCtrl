function drop = lqddrop(mass,area2,density,surface)
    drop = area2*sqrt(2*((9.8*mass/surface)/density)/(1-(area2/surface)^2))*density;
    