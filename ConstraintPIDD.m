% CONSTRAINTPIDD Provides constraints for PIDD^2 controller
%   Returns 8x3 matrix, rows are Minimums, Maximums, Initial search point
%   (if needed for non-general search). Columns are P, I, D, D^2 gains for
%   ballast then gas release
function const=massConstraintPIDD()
    tmp=zeros(2,4);%Minimums for PID search. Liquid then gas
    tmp(1,:)=[-1000,-1000,-1000,-1000];
    tmp(2,:)=[-1,-1,-1,-1];
    
    tmp2=zeros(2,4);%Maximums for PID search. Liquid then gas
    tmp2(1,:)=[1,1,1,1];
    tmp2(2,:)=[1000,1000,1000,1000];
    
    tmp3=zeros(2,4);%Initial search point
    %With logic to prevent premature dumping
    tmp3(1,:)=[-0.851746687195210,-10.2381393543321,-362.153626089222,-931.280883067346];
    tmp3(2,:)=[1.95974189875841,10.0720001660157,39.4314668079863,999.133390732526];
    
    const=[tmp(1,:),tmp(2,:);tmp2(1,:),tmp2(2,:);tmp3(1,:),tmp3(2,:)];