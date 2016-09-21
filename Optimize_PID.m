% OPTIMIZE_PID Provides code to optimize the given system based on the
% Genetic algorithm followed by a more localized search
%   Returns Record matrix and displays plot of flight profile

%Population and generation sizes for genetic algorithm
pop = 50;
gen = 50;

const=ConstraintFilter;%Load constraints
GAOptions=gaoptimset('PopulationSize',pop,'Generations',gen,'UseParallel',true);%GA options
[bestvar,bestobj,history,eval_count]=ga(@FlightOps,6,[],[],[],[],const(1,:),const(2,:),[],GAOptions);%GA optimizer
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point','UseParallel',true)%Local search options
[bestvar2,bestobj2]=fmincon(@FlightOps,bestvar,[],[],[],[],const(1,:),const(2,:),[],options)%Local optimizer


TargetAlt=[10000,10000;0,5000]; %Desired plotted altitude profile
Record=LiftSim(bestvar2,TargetAlt,500); %Run the simulation with the found gains
plot(Record(:,1),Record(:,4)) %Plot altitude profile
