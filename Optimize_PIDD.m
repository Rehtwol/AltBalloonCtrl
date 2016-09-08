
const=massConstraintFSM;
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point')
xi = const(3,:);
[x,fval] = fmincon(@FlightOps,xi,[],[],[],[],const(1,:),const(2,:),[],options)

TargetAlt=[10000,8000;0,5000];
Record=LiftSim(x,TargetAlt,500);
plot(Record(:,1),Record(:,4))
