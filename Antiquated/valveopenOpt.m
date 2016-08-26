function valve=valveopenOpt(alt,time,target,sopen,Kp,Ki,Kd,Kd2)
    area = 9.62e-6;
    n = length(alt);
    alterr = zeros(n,1);
    valve=[0,0];
    for r = 1:n
        alterr(r)=target-alt(r);
    end
    sopen=1000;
    P=(alterr(n));
    I=trapz(alterr,time);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
    D2=0;
    if n>2
        Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    
    if D>0

        score=Kp*P+Ki*I+Kd*D+D2*Kd2;
        valve(2)=score;
        
        if score<=0
            valve(1)=0;
        elseif score>=sopen
            valve(1)=area;
        else
            valve(1)=area*score/sopen;
        end
    else
        valve(1)=0;
    end