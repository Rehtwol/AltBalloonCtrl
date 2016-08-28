function valve=valveLogicPIDDsingle(targetAlt,bandwidth,alt,time,PID)
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kd2=PID(4);
    Diff=PID(5);
    n = length(alt);
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0,0,0,0,0,0];
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        timerr(r)=time(r)-time(max(1,r-1));
    end
    gopen=1000;
    lopen=1000;
    P=(alterr(n));
    I=trapz(timerr,alterr);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
    D2=0;
    if n>2
        Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    score=min(Kp*P+Ki*I+Kd*D+Kd2*D2,gopen);
    score2=score*Diff;
    valve(1)=0;
%     Valve States
    valve(2)=max(score/gopen,0);
    valve(3)=max(score2/lopen,0);
    
    %Logic to avoid premature dumping
    if D>0
        valve(3)=0;
    elseif D<0
        valve(2)=0;
    end
    
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=D2;
