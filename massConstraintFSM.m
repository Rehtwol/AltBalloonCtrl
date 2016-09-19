function const=massConstraintFSM()
    tmp=zeros(1,4);%Minimums
    tmp(1,:)=[0,0,100,100];
    
    tmp2=zeros(1,4);%Maximums
    tmp2(1,:)=[50,50,1000,1500];
    
    tmp3=zeros(1,4);%Initial search point
    %tmp3(1,:)=[2,0.1,200,800];
    tmp3(1,:)=[0.191784087928856,0.377369286889350,1.251226664759316e+02,1.131057864244332e+02]; %Filter gains
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];