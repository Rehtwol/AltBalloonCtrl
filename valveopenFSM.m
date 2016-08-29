function valve=valveopenFSM(targetAlt,bandwidth,alt,time,D,D2,Kp,Ki,Kd,Kd2)
    n = length(alt);
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0,0,0,0,0,0];
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        if abs(alterr(r)) > bandwidth/2
            alterr(r)=0;
        end
        timerr(r)=time(r)-time(max(1,r-1));
    end
    lopen=1000;
    gopen=100;
    P=(alterr(n));
    I=trapz(timerr,alterr);
%     D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
%     D2=0;
%     if n>2
%         Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
%         D2=(D-Dneg)/(time(n)-time(n-1));
%     end
    score=Kp*P+Ki*I+Kd*D+D2*Kd2;
    valve(3)=score;
    if score<0
        valve(2)=min(1,abs(score/lopen));
    elseif score>0
        valve(1)=min(1,abs(score/gopen));
    end
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=D2;
