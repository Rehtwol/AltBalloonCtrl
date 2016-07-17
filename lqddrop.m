function drop = lqddrop(mass,area1,area2,density,surface)
    drop = area2*sqrt(2*((9.8*mass*surface)/density)/(1-(area2/area1)^2))*density;
    