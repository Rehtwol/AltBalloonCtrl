% VALVEOPENFILTER Filtered controller's PIDD^2 controller
%   Inputs: P, I, D, D^2 terms, P, I, D, D^2 gains
%   Output: 7x1 matrix, containing Gas release valve state, Ballast valve
%   state, Calculated score, P, I, D, D^2 terms
function valve=valveopenFSM(targetAlt,bandwidth,alt,time,D,D2,Kp,Ki,Kd,Kd2)
    %Determine length of data passed
    n = length(alt);
    %Instantiate output matrix and matricies used in calculations
    alterr = zeros(n,1);
    timerr = zeros(n,1);
    valve=[0,0,0,0,0,0,0];

    % Calculate error values. Ignore errors from values outside of
    % controlled zone
    for r = 1:n
        alterr(r)=alt(r)-targetAlt;
        if abs(alterr(r)) > bandwidth/2
            alterr(r)=0;
        end
        timerr(r)=time(r)-time(1);
    end
    
    lopen=1000;
    gopen=-100;
    %Calculate P and I values
    P=(alterr(n));
    I=trapz(timerr,alterr);
    %Calculate score
    score=Kp*P+Ki*I+Kd*D+D2*Kd2;
    valve(3)=score;
    
    %Based on sign, operate appropriate valve
    if score<0
        valve(2)=min(1,score/lopen);
    elseif score>0
        valve(1)=min(1,score/gopen);
    end
    
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=D2;
