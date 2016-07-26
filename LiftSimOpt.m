function airtime=LiftSimOpt(PID,TargetAlt)
    %Initial setup details
    p0 = 101300;
    GasMass = 0.300;
    BallastMass = 0.800;
    SysMass = 0.200;

    BalloonValve = 64.6e-6;
    BalloonPD = 250;

    BallastA1 = 12.57e-6;
    BallastA2 = 9.62e-6;
    BallastDensity = 800;
    BallastSurface = 10;

    Record=zeros(3601,14);
    Record(:,1)=0:2:7200;
    Record(1,6)=GasMass;
    Record(1,7)=BallastMass;
    Record(1,5)=SysMass+GasMass+BallastMass;
    Record(1,2)=liftAccel(Record(1,4),Record(1,5),Record(1,6));

    for round=2:length(Record)
        prevTime=Record(round-1,1);
        currTime=Record(round,1);
        deltaTime=currTime-prevTime;

        %Velocity and Altitude
        Record(round,3)=min(Record(round-1,3)+Record(round-1,2)*deltaTime,5);
        Record(round,4)=Record(round-1,4)+(Record(round-1,3)+Record(round,3))*deltaTime/2;
        %Valve Conditions
        valve=ctrlScore(Record(max(1,round-10):round,4),Record(max(1,round-10):round,1),TargetAlt,PID(3),PID(4),PID(5),PID(6));
        Record(round,8)=valve(1);
        valveStat=valveLogic(valve(1),valve(4),PID(1),PID(2),BalloonValve,BallastA2);
        Record(round,9)=valveStat(2);
        Record(round,10)=valveStat(1);
        %Mass changes
        GasLoss=vrelease((Record(round,4)+Record(round-1,4))/2,Record(round,9),BalloonPD);
        Record(round,6)=Record(round-1,6)-GasLoss*deltaTime;
        BallastLoss=lqddrop(Record(round-1,7),BallastA1,Record(round-1,10),BallastDensity,BallastSurface);
        Record(round,7)=max(Record(round-1,7)-BallastLoss*deltaTime,0);
        Record(round,5)=Record(round,6)+Record(round,7)+SysMass;

        %Acceleration for next step
        Record(round,2)=max(liftAccel(Record(round,4),Record(round,5),Record(round,6)),-9.8);
        
        %Note PID values at each step
        Record(round,11)=valve(2);
        Record(round,12)=valve(3);
        Record(round,13)=valve(4);
        Record(round,14)=valve(5);

        if Record(round,4)<0
            break;
        end
    end
    airtime=Record;