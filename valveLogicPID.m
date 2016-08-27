function valve=valveLogicPID(targetAlt,bandwidth,alt,time,PID)
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kp2=PID(4);
    Ki2=PID(5);
    Kd2=PID(6);
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

    scorea=min(Kp*P+Ki*I+Kd*D,gopen);
    scoreb=min(Kp2*P+Ki2*I+Kd2*D,lopen);
    
    valve(1)=0;
%     Valve States
    valve(2)=max(scoreb/gopen,0);
    valve(3)=max(scorea/lopen,0);
    
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=P;
