function const=massConstraintFSM()
    tmp=zeros(2,4);%Minimums liquid then air
    tmp(1,:)=[0,0,100,100];
    %tmp(2,:)=[0,-10000,-500,0,0];
    
    tmp2=zeros(2,4);%Maximums liquid then air
    tmp2(1,:)=[50,50,1000,1500];
    %tmp2(2,:)=[0,0,500,10000,10000];
    
    tmp3=zeros(2,4);%Initial search point
    tmp3(1,:)=[2,0.1,200,800];
    %tmp3(2,:)=[0,-20,0,50,100];
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];