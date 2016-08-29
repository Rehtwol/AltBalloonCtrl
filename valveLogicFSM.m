function status=valveLogicFSM(targetAlt,bandwidth,alt,time,PID)
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kd2=PID(4);
    n = length(alt);
    status=[0,0,0,0,0,0,0];
    D=(alt(n)-alt(n-1))/(time(n)-time(n-1));
    D2=0;
    if n>2
        Dneg=(alt(n-1)-alt(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    
    barrier=[targetAlt-1.5*bandwidth,targetAlt-0.5*bandwidth,targetAlt+0.5*bandwidth,targetAlt+1.5*bandwidth];
    
    if alt(n) < barrier(1)
        status(1)=1;
        if D<=1 && D2<=0.5
            status(3)=1;
        end
        status(6:7)=[D,D2];
    elseif alt(n) < barrier(2)
        status(1)=2;
        if D<=0 && D2<=0.5
            status(3)=1;
        elseif D>=2 && D2>=-0.05
            status(2)=1;
        end
    elseif alt(n) < barrier(3)
        status(1)=3;
        valve=valveopenFSM(targetAlt,bandwidth,alt,time,D,D2,Kp,Ki,Kd,Kd2);
        status(2:3)=valve(1:2);
        status(4:7)=valve(4:7);
    elseif alt(n) < barrier(4)
        status(1)=4;
        if D<=-1 && D2<=0
            status(3)=1;
        elseif D>=-1 && D2>=0
            status(2)=1;
        end
    else
        status(1)=5;
        if D>=-1 && D2>=-0.5
            status(2)=1;
        end
        status(6:7)=[D,D2];
    end
    status(2)=round(status(2),3);
    status(3)=round(status(3),3);