
pop = 20;
gen = 200;
const=massConstraint;
GAOptions=gaoptimset('PopulationSize',pop,'Generations',gen);
[bestvar,bestobj,history,eval_count]=ga_DSO(@FlightOps,6,[],[],[],[],const(1,:),const(2,:),[],GAOptions);
max_evals = 300;
options = optimset('MaxFunEvals',max_evals);
[bestvar2,bestobj2]=fminsearchcon(@FlightOps,bestvar,const(1,:),const(2,:),[],[],[],options);
bestvar
bestvar2
bestobj2
Record=LiftSimOpt(bestvar2,10000);
plot(Record(:,1),Record(:,4))
