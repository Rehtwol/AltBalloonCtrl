function valve=valveLogicPIDD(targetAlt,bandwidth,alt,time,PID)
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    K2d=PID(4);
    Kp2=PID(5);
    Ki2=PID(6);
    Kd2=PID(7);
    K2d2=PID(8);
    n = length(alt);
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0,0,0,0,0,0];
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        timerr(r)=time(r)-time(max(1,r-1));
    end
    lopen=1000;
    gopen=1000;
    P=(alterr(n));
    I=trapz(timerr,alterr);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
    D2=0;
    if n>2
        Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    scorea=min(Kp*P+Ki*I+Kd*D+K2d*D2,gopen);
    scoreb=min(Kp2*P+Ki2*I+Kd2*D+K2d2*D2,lopen);
    
    valve(1)=0;
%     Valve States
    valve(2)=max(scoreb/gopen,0);
    valve(3)=max(scorea/lopen,0);
    
    %Logic to avoid premature dumping
    if D>1
        valve(3)=0;
    elseif D<-1
        valve(2)=0;
    end
    
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=D2;
