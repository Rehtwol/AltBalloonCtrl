function valve=ctrlScore(alt,time,target,Kp,Ki,Kd,Kd2)
    
    n = length(alt);
    alterr = zeros(n,1);
    alterr2 = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0];
    for r = 1:n
        alterr(r)=target-alt(r);
        if abs(alterr(r))<500
            alterr2(r)=0;
        else
            alterr2(r)=alterr(r);
        end
        timerr(r)=time(r)-time(1);
    end
    P=(alterr2(n));
    I=trapz(alterr2,timerr);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
    D2=0;
    if n>2
        Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    

    score=Kp*P+Ki*I+Kd*D+D2*Kd2;
    valve(1)=score;
    valve(2)=P;
    valve(3)=I;
    valve(4)=D;
    valve(5)=D2;

