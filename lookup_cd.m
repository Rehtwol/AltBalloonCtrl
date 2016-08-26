function Cd=lookup_cd(Re)
    Cdl = 0.225;
    Recl = 3.296e5;
    delRe = 0.363e5;
    Cdt = 0.425;
    
    if Re < Recl
        Cd = Cdl;
    elseif Re <= (Recl+delRe)
        Cd = Cdl-(Cdl-Cdt)*(Re-Recl)/delRe;
    else
        Cd = Cdt;
    end