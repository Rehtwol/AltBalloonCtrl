function const=massConstraintPIDDsingle()
    tmp=zeros(1,5);%Minimums for PID search.
    tmp(1,:)=[-1,-1,-1,-1,-100];
    
    tmp2=zeros(1,5);%Maximums for PID search.
    tmp2(1,:)=[1000,1000,1000,1000,0];
    
    tmp3=zeros(1,5);%Initial search point
    %Generic
    tmp3(1,:)=[1,10,120,800,-10];
    %With logic to prevent premature dumping
%     tmp3(1,:)=[1.88668068806287,9.79944753914917,120.388020698102,799.996322143585,-9.98210581347037];
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];