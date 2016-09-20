% VALVEOPENFILTER Filtered controller's PIDD^2 controller
%   Inputs: P, I, D, D^2 terms, P, I, D, D^2 gains
%   Output: 7x1 matrix, containing Gas release valve state, Ballast valve
%   state, Calculated score, P, I, D, D^2 terms
function valve=valveopenFilter(P,I,D,D2,Kp,Ki,Kd,Kd2)
    %Instantiation for output. For simplicity, Diff term was built in here
    valve=[0,0,0,0,0,0,0];
    lopen=-1000;
    gopen=100;
    
    %Calculate score
    score=Kp*P+Ki*I+Kd*D+D2*Kd2;
    valve(3)=score;
    
    %Depending on sign of score, activate proper valve
    if score<0
        valve(2)=min(1,score/lopen);
    elseif score>0
        valve(1)=min(1,score/gopen);
    end
    
    valve(4)=P;
    valve(5)=I;
    valve(6)=D;
    valve(7)=D2;
