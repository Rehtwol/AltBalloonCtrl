function const=massConstraint()
    tmp=zeros(2,5);%Minimums liquid then air
    tmp(1,:)=[0,0,-100,-10000,-10000];
    tmp(2,:)=[0,-10000,-500,0,0];
    
    tmp2=zeros(2,5);%Maximums liquid then air
    tmp2(1,:)=[0,10000,100,0,0];
    tmp2(2,:)=[0,0,500,10000,10000];
    
    tmp3=zeros(2,5);%Initial search point
    tmp3(1,:)=[0,20,0,-50,-100];
    tmp3(2,:)=[0,-20,0,50,100];
    
    const=[tmp(1,:),tmp(2,:);tmp2(1,:),tmp2(2,:);tmp3(1,:),tmp3(2,:)];