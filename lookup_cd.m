% LOOKUP_CD Calculates Coefficient of drag at given Reynolds number
%   Returns single value. Curve based on work by Sobester (2014)
%   
%   Written by Anthony Lowther, 2016
function Cd=lookup_cd(Re)
    %Curve-defining characteristics
    Cdl = 0.225;
    Recl = 3.296e5;
    delRe = 0.363e5;
    Cdt = 0.425;
    
    %Calculate Cd based on which region the system is in
    if Re < Recl
        Cd = Cdl;
    elseif Re <= (Recl+delRe)
        Cd = Cdl-(Cdl-Cdt)*(Re-Recl)/delRe;
    else
        Cd = Cdt;
    end