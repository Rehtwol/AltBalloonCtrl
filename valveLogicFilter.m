function status=valveLogicFilter(targetAlt,bandwidth,alt,time,PID)
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kd2=PID(4);
    n = length(alt);
    status=[0,0,0,0,0,0,0];
    Parr=zeros(n,1);
    Darr=zeros(n-1,1);
    D2arr=zeros(n-2,1);
    W=5;
    
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    weights=(1:W)';

    for r = 1:n
        alterr(r)=alt(r)-targetAlt;

        timerr(r)=time(r)-time(1);
    end
    for r = 1:n
        arr=alterr(max(r-W-1,1):r);
        wei=weights(1:min(W,n));
        weighted=arr.*wei;
        Parr(r)= sum(weighted)/sum(wei);
    end
    P=Parr(n);
    I=0;
    D=0;
    D2=0;

    I=trapz(timerr,alterr);
    
    for l=1:n-1
        Darr(l)=(Parr(l+1)-Parr(l))/(time(l+1)-time(l));
    end
    for l=1:n-2
        D2arr(l)=(Darr(l+1)-Darr(l))/(time(l+1)-time(l));
    end
    D=sum(Darr)/length(Darr);
    D2=sum(D2arr)/length(D2arr);
    
    
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
        valve=valveopenFilter(P,I,D,D2,Kp,Ki,Kd,Kd2);
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