% CONSTRAINTPIDDSINGLE Provides constraints for single-loop PIDD^2 controller
%   Returns 8x3 matrix, rows are Minimums, Maximums, Initial search point
%   (if needed for non-general search). Columns are P, I, D, D^2 gains and
%   Diff term
%   
%   Written by Anthony Lowther, 2016
function const=ConstraintPIDDsingle()
    tmp=zeros(1,5);%Minimums for PIDD search.
    tmp(1,:)=[-1,-1,-1,-1,-100];
    
    tmp2=zeros(1,5);%Maximums for PIDD search.
    tmp2(1,:)=[1000,1000,1000,1000,0];
    
    tmp3=zeros(1,5);%Initial search point
    tmp3(1,:)=[1.88668068806287,9.79944753914917,120.388020698102,799.996322143585,-9.98210581347037];
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];