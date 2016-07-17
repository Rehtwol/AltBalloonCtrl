function airtime=LiftSimOpt(PID)
    %Initial setup details
    p0 = 101300;
    GasMass = 0.300;
    BallastMass = 0.800;
    SysMass = 0.200;

    BalloonValve = 7.07e-6;
    BalloonPD = 250;

    BallastA1 = 12.57e-6;
    BallastA2 = 7.07e-6;
    BallastDensity = 800;
    BallastSurface = 10;

    TargetAlt = 10000;

    Record=zeros(721,9);
    Record(:,1)=0:10:7200;
    Record(1,6)=GasMass;
    Record(1,8)=BallastMass;
    Record(1,5)=SysMass+GasMass+BallastMass;
    Record(1,2)=liftAccel(Record(1,4),Record(1,5),Record(1,6));

    for round=2:720
        prevTime=Record(round-1,1);
        currTime=Record(round,1);
        deltaTime=currTime-prevTime;

        %Velocity and Altitude
        Record(round,3)=min(Record(round-1,3)+Record(round-1,2)*deltaTime,5);
        Record(round,4)=Record(round-1,4)+(Record(round-1,3)+Record(round,3))*deltaTime/2;
        %Mass changes
        GasLoss=vrelease((Record(round,4)+Record(round-1,4))/2,BalloonValve,BalloonPD);
        Record(round,6)=Record(round-1,6)-GasLoss*deltaTime;
        BallastLoss=lqddrop(Record(round-1,8),BallastA1,Record(round-1,7),BallastDensity,BallastSurface);
        Record(round,8)=Record(round-1,8)-BallastLoss*deltaTime;
        Record(round,5)=Record(round,6)+Record(round,8)+SysMass;
        %Valve Open
        valve=valveopenOpt(Record(max(1,round-10):round,4),Record(max(1,round-10):round,1),TargetAlt,PID(1),PID(2),PID(3));
        Record(round,7)=valve(1);
        Record(round,9)=valve(2);
        %Acceleration for next step
        Record(round,2)=max(liftAccel(Record(round,4),Record(round,5),Record(round,6)),-9.8);

        if Record(round,4)<0
            break;
        end
    end
    airtime=Record;