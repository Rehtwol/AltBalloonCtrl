function pressure = lookup_pressure(altitude)
    M = 0.0289644; %Molar mass of dry air (kg/mol)
    R = 8.31447; %Universal gas constant (J/(mol*K))
    gravity = 9.80665; %Gravity
    pressure = [0,0];
    if altitude<11000
        c=0;
    elseif altitude<20000
        c=1;
    elseif altitude<32000
        c=2;
    elseif altitude<47000
        c=3;
    elseif altitude<51000
        c=4;
    elseif altitude<71000
        c=5;
    elseif altitude<86000
        c=6;
    else
        pressure=[0,0];
        return;
    end
    switch c
        case 0
            h=-600;
            L=-6.5e-3;
            T=292;
            P0=108.9e+03;
        case 1
            h=11000;
            L=0;
            T=216.5;
            P0=2.2662e+04;
        case 2
            h=20000;
            L=1.0e-3;
            T=216.5;
            P0=5.4777e+03;
        case 3
            h=32000;
            L=2.8e-3;
            T=228.5;
            P0=867.5448;
        case 4
            h=47000;
            L=0.0;
            T=270.5;
            P0=110.7262;
        case 5
            h=51000;
            L=-2.8e-3;
            T=270.5;
            P0=66.8205;
        case 6
            h=71000;
            L=-2.0e-3;
            T=214.5;
            P0=66.8205;
        otherwise
            pressure=[0,0];
            return;
    end
    if L~=0
        pressure(1)=P0*(T/(T+L*(altitude-h)))^(gravity*M/(R*L));
        pressure(2)=T+L*(altitude-h);
    else
        pressure(1)=P0*exp(-gravity*M*(altitude-h)/(R*T));
        pressure(2)=T;
    end