% OPTIMIZE_NOGA Provides code to optimize the given system based on the
% provided initial search point rather than through a GA
%   Returns Record matrix and displays plot of flight profile

const=ConstraintFilter; %Load constraints
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point','UseParallel',true)%Optimizer options
xi = const(3,:);%Initial search point
[x,fval] = fmincon(@FlightOps,xi,[],[],[],[],const(1,:),const(2,:),[],options)%Optimizer

TargetAlt=[10000,10000;0,5000]; %Desired plotted altitude profile
Record=LiftSim(x,TargetAlt,500); %Run the simulation with the found gains
plot(Record(:,1),Record(:,4)) %Plot altitude profile
