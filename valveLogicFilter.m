% VALVELOGICFILTER Filtered controller
%   Inputs: Target Altitude, Bandwidth, Altitude measurements, Times of
%   altitude measurements, PID matrix of gains
%   Output: 7x1 matrix, containing Controller mode (from FSM), Gas valve
%   state, Ballast valve state, P, I, D, D^2 terms (without gains applied)
%   
%   Written by Anthony Lowther, 2016
function status=valveLogicFilter(targetAlt,bandwidth,alt,time,PID)
    %Retrieve gains for controller
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kd2=PID(4);
    %Determine length of data passed
    n = length(alt);
    %Instantiate output matrix and matricies used in filtering
    status=[0,0,0,0,0,0,0];
    Parr=zeros(n,1);
    Darr=zeros(n-1,1);
    D2arr=zeros(n-2,1);
    %Determine filter window length (must be an integer)
    W=round(PID(5));
    
    %Instantiate more matricies used for calculations
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    
    %Weighting matrix, first line is a linear scale, second is an even
    %scale
    weights=(1:W)';
    %weights=ones(5,1);

    %Calculate error value at each altitude and time-step for integration
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        timerr(r)=time(r)-time(1);
    end
    %Moving window filter
    for r = 1:n
        arr=alterr(max(r-(W-1),1):r); %Subset of errors to create window
        wei=weights(1:min(W,r)); %Weighting matrix
        weighted=arr.*wei; %Weighted matrix
        Parr(r)= sum(weighted)/sum(wei); %Averaged
    end
    %Create P, I, D, D^2 terms
    P=Parr(n);
    I=0;
    D=0;
    D2=0;
    %Calculate I using trapezoidal method
    I=trapz(timerr,alterr);
    
    %Calculate D and D^2 terms for each step
    for l=1:n-1
        Darr(l)=(Parr(l+1)-Parr(l))/(time(l+1)-time(l));
    end
    for l=1:n-2
        D2arr(l)=(Darr(l+1)-Darr(l))/(time(l+1)-time(l));
    end
    
    %Even weighting average of recent D and D^2 terms
    D=sum(Darr)/length(Darr);
    D2=sum(D2arr)/length(D2arr);
    
    %Determine zone barriers
    barrier=[targetAlt-1.5*bandwidth,targetAlt-0.5*bandwidth,targetAlt+0.5*bandwidth,targetAlt+1.5*bandwidth];
    
    %Based on zone, set the mode of operation and apply appropriate logic
    if alt(n) < barrier(1)
        status(1)=1;
        if D<=1 && D2<=0.5
            status(3)=1;
        end
        status(4:7)=[P,I,D,D2];
    elseif alt(n) < barrier(2)
        status(1)=2;
        if D<=0 && D2<=0.5
            status(3)=1;
        elseif D>=2 && D2>=-0.05
            status(2)=1;
        end
        status(4:7)=[P,I,D,D2];
    elseif alt(n) < barrier(3)
        deadzone = abs(D)<1 && abs(D2)<0.1 && P<bandwidth/5; %Calculate whether operation is within deadzone criteria
        if deadzone %Within deadzone, lock everything
            status(1)=3.1;
            status(2:3)=zeros(2,1);
            status(4:7)=[P,I,D,D2];
        else %Otherwise pass on to PIDD^2 controller in the background
            status(1)=3;
            valve=valveOpenFilter(P,I,D,D2,Kp,Ki,Kd,Kd2);
            status(2:3)=valve(1:2);
            status(4:7)=valve(4:7);
        end
    elseif alt(n) < barrier(4)
        status(1)=4;
        if D<=-1 && D2<=0
            status(3)=1;
        elseif D>=-1 && D2>=0
            status(2)=1;
        end
        status(4:7)=[P,I,D,D2];
    else
        status(1)=5;
        if D>=-1 && D2>=-0.5
            status(2)=1;
        end
        status(4:7)=[P,I,D,D2];
    end