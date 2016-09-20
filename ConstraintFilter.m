% CONSTRAINTFILTER Provides constraints for filtered controller
%   Returns 5x3 matrix, rows are Minimums, Maximums, Initial search point
%   (if needed for non-general search). Columns are P, I, D, D^2 gains and
%   window length
function const=ConstraintFilter()
    tmp=zeros(1,5);%Minimums
    tmp(1,:)=[0,0,100,100,1];
    
    tmp2=zeros(1,5);%Maximums
    tmp2(1,:)=[50,50,1000,1500,10];
    
    tmp3=zeros(1,5);%Initial search point
    tmp3(1,:)=[0.191784087928856,0.377369286889350,1.251226664759316e+02,1.131057864244332e+02,4]; %Filter gains
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];