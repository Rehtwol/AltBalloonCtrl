
pop = 50;
gen = 100;
const=massConstraintFSM;
GAOptions=gaoptimset('PopulationSize',pop,'Generations',gen,'UseParallel',true);
[bestvar,bestobj,history,eval_count]=ga_DSO(@FlightOps,6,[],[],[],[],const(1,:),const(2,:),[],GAOptions);
xi = const(3,:);
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point','UseParallel',true)
[bestvar2,bestobj2]=fmincon(@FlightOps,xi,[],[],[],[],const(1,:),const(2,:),[],options)


TargetAlt=[10000,8000;0,5000];
Record=LiftSim(bestvar2,TargetAlt,500);
plot(Record(:,1),Record(:,4))

