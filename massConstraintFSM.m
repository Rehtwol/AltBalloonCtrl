function const=massConstraintFSM()
    tmp=zeros(2,4);%Minimums liquid then air
    tmp(1,:)=[0,0,0,0];
    %tmp(2,:)=[0,-10000,-500,0,0];
    
    tmp2=zeros(2,4);%Maximums liquid then air
    tmp2(1,:)=[50,100,2000,2000];
    %tmp2(2,:)=[0,0,500,10000,10000];
    
    tmp3=zeros(2,4);%Initial search point
    tmp3(1,:)=[1,1,120,870];
    %tmp3(2,:)=[0,-20,0,50,100];
    
    const=[tmp(1,:);tmp2(1,:);tmp3(1,:)];