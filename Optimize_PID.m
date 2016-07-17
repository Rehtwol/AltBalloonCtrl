
pop = 10;
gen = 300;
GAOptions=gaoptimset('PopulationSize',pop,'Generations',gen);
[bestvar,bestobj,history,eval_count]=ga_DSO(@LiftSimOpt,3,[],[],[],[],[0,0,0],[200,200,200],[],GAOptions);
max_evals = 200;
options = optimset('MaxFunEvals',max_evals);
[bestvar2,bestobj2]=fminsearchcon(@LiftSimOpt,bestvar,[0,0,0],[100,100,100],[],[],[],options);
bestvar
bestvar2
bestobj2
[eval_count, pop, gen]
