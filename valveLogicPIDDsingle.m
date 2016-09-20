% VALVELOGICPIDDSINGLE Single-loop PIDD^2 controller
%   Inputs: Target Altitude, Bandwidth (not used, maintained for consistency),
%   Altitude measurements, Times of altitude measurements, PID matrix of gains
%   Output: 7x1 matrix, containing Generic score, Gas valve state, Ballast 
%   valve state, P, I, D, D^2 terms (without gains applied)
function valve=valveLogicPIDDsingle(targetAlt,~,alt,time,PID)
    %Retrieve gains for controller
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kd2=PID(4);
    Diff=PID(5);
    
    %Determine length of data passed
    n = length(alt);
    %Instantiate output matrix and matricies used in calculations
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0,0,0,0,0,0];
    
    %Calculate error value at each altitude and time-step for integration
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        timerr(r)=time(r)-time(max(1,r-1));
    end
    gopen=1000;
    lopen=1000;
    
    %Find P, I, and D terms
    P=(alterr(n));
    I=trapz(timerr,alterr);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));
    %Calculate D^2 term when possible
    D2=0;
    if n>2
        Dneg=(alterr(n-1)-alterr(n-2))/(time(n-1)-time(n-2));
        D2=(D-Dneg)/(time(n)-time(n-1));
    end
    
    %Calculating the scores as appropriate
    score=min(Kp*P+Ki*I+Kd*D+Kd2*D2,gopen);
    score2=min(score*Diff,lopen);
    valve(1)=score; %Pass score
    %Valve States
    valve(2)=max(score/gopen,0);
    valve(3)=max(score2/lopen,0);
    
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
