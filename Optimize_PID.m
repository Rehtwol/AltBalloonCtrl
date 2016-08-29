
pop = 20;
gen = 40;
const=massConstraintPID;
GAOptions=gaoptimset('PopulationSize',pop,'Generations',gen);
[bestvar,bestobj,history,eval_count]=ga_DSO(@FlightOps,6,[],[],[],[],const(1,:),const(2,:),[],GAOptions);
max_evals = 100;
options = optimset('MaxFunEvals',max_evals);
[bestvar2,bestobj2]=fminsearchcon(@FlightOps,bestvar,const(1,:),const(2,:),[],[],[],options);


TargetAlt=[10000,10000;0,5000];
Record=LiftSimFSM(bestvar2,TargetAlt,500);
plot(Record(:,1),Record(:,4))

