
const=massConstraint;
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point')
xi = const(3,:);
[x,fval] = fmincon(@FlightOps,xi,[],[],[],[],const(1,:),const(2,:),[],options)

