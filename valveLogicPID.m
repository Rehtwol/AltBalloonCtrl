% VALVELOGICPID PID controller
%   Inputs: Target Altitude, Bandwidth (not used, maintained for consistency),
%   Altitude measurements, Times of altitude measurements, PID matrix of gains
%   Output: 7x1 matrix, containing 0, Gas valve state, Ballast valve state,
%   P, I, D terms (without gains applied), 0 (the 0s are place holders to
%   maintain consistency)
function valve=valveLogicPID(targetAlt,~,alt,time,PID)
    %Retrieve gains for controller
    Kp=PID(1);
    Ki=PID(2);
    Kd=PID(3);
    Kp2=PID(4);
    Ki2=PID(5);
    Kd2=PID(6);
    
    %Determine length of data passed
    n = length(alt);
    %Instantiate output matrix and matricies used in calculations
    valve=[0,0,0,0,0,0,0];
    alterr = zeros(n,1);
    timerr = zeros(n,1);

    %Calculate error value at each altitude and time-step for integration
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        timerr(r)=time(r)-time(max(1,r-1));
    end
    lopen=1000;
    gopen=1000;
    
    %Find P, I, and D terms
    P=(alterr(n));
    I=trapz(timerr,alterr);
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1));

    %Calculate scores for each valve
    scorea=min(Kp*P+Ki*I+Kd*D,gopen);
    scoreb=min(Kp2*P+Ki2*I+Kd2*D,lopen);
    
    valve(1)=0;
    %Valve States
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
    valve(7)=0;

