% CONSTRAINTFSM Provides constraints for FSM controller
%   Returns 4x3 matrix, rows are Minimums, Maximums, Initial search point
%   (if needed for non-general search). Columns are P, I, D, D^2 gains
function const=ConstraintFSM()
    tmp=zeros(1,4);%Minimums
    tmp(1,:)=[0,0,100,100];
    
    tmp2=zeros(1,4);%Maximums
    tmp2(1,:)=[50,50,1000,1500];
    
    tmp3=zeros(1,4);%Initial search point
    tmp3(1,:)=[2,0.1,200,800];
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];