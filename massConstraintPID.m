function const=massConstraintPID()
    tmp=zeros(2,3);%Minimums for PID search. Liquid then gas
    tmp(1,:)=[-1000,-1000,-1000];
    tmp(2,:)=[-1,-1,-1];
    
    tmp2=zeros(2,3);%Maximums for PID search. Liquid then gas
    tmp2(1,:)=[1,1,1];
    tmp2(2,:)=[1000,1000,1000];
    
    tmp3=zeros(2,3);%Initial search point
    tmp3(1,:)=[-1,-10,-100];
    tmp3(2,:)=[1,10,100];
    
    const=[tmp(1,:),tmp(2,:);tmp2(1,:),tmp2(2,:);tmp3(1,:),tmp3(2,:)];