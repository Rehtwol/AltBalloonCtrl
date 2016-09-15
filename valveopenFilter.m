function valve=valveopenFilter(P,I,D,D2,Kp,Ki,Kd,Kd2)
    valve=[0,0,0,0,0,0,0];
    lopen=1000;
    gopen=100;

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
