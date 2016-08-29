function const=massConstraintPID()
    tmp=zeros(2,3);%Minimums for PID search. Liquid then gas
    tmp(1,:)=[-100,-100,-500];
    tmp(2,:)=[-1,-1,-1];
    
    tmp2=zeros(2,3);%Maximums for PID search. Liquid then gas
    tmp2(1,:)=[1,1,1];
    tmp2(2,:)=[100,100,500];
    
    tmp3=zeros(2,3);%Initial search point
    %Generic
    tmp3(1,:)=[-1,-10,-100];
    tmp3(2,:)=[1,10,100];
    %With logic to prevent premature dumping
%     tmp3(1,:)=[-1.57958495430910,0.986268513637363,-56.2527381876913];
%     tmp3(2,:)=[5.56414623331827,-0.499597219795481,86.9600031429341];
    
    const=[tmp(1,:),tmp(2,:);tmp2(1,:),tmp2(2,:);tmp3(1,:),tmp3(2,:)];