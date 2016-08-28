
const=massConstraintFSM;
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point')
xi = const(3,:);
[x,fval] = fmincon(@FlightOps,xi,[],[],[],[],const(1,:),const(2,:),[],options)

TargetAlt=[10000,10000;0,500];
Record=LiftSimFSM(x,TargetAlt,500);
plot(Record(:,1),Record(:,4))
