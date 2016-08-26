function airtime=LiftSimFSM(PID,TargetAlt,bandwidth)
    %Initial setup details
    p0 = 101300;
    GasMass = 0.09;
    BallastMass = 0.050;
    SysMass = 0.250;

    BalloonValve = 32.17e-6;
    BalloonPD = 250;

    BallastA1 = 52.57e-5;
    BallastA2 = 32.17e-6;
    BallastDensity = 800;
    BallastSurface = 10;

    Record=zeros(25001,18);
    Record(:,1)=0:0.4:10000;
    Record(1,6)=GasMass;
    Record(1,7)=BallastMass;
    Record(1,5)=SysMass+GasMass+BallastMass;
    accel=liftAccel(Record(1,4),Record(1,5),Record(1,6),Record(1,3));
    Record(1,2)=accel(1);

    for cycle=2:length(Record)
        prevTime=Record(cycle-1,1);
        currTime=Record(cycle,1);
        deltaTime=currTime-prevTime;
        
        for n=2:length(TargetAlt)
            if currTime>TargetAlt(2,n-1) && currTime<TargetAlt(2,n)
                target=TargetAlt(1,n-1);
                break;
            else
                target=TargetAlt(1,n);
            end
        end

        %Velocity and Altitude
        Record(cycle,3)=Record(cycle-1,3)+Record(cycle-1,2)*deltaTime;
        Record(cycle,4)=Record(cycle-1,4)+(Record(cycle-1,3)+Record(cycle,3))*deltaTime/2;
        %Valve Conditions
        status=valveLogicFSM(target,bandwidth,Record(max(1,cycle-10):cycle,4),Record(max(1,cycle-10):cycle,1),PID);
        Record(cycle,8:10)=status(1:3);
        %Mass changes
        GasLoss=vrelease((Record(cycle,4)+Record(cycle-1,4))/2,Record(cycle-1,9)*BalloonValve,BalloonPD);
        Record(cycle,6)=max(Record(cycle-1,6)-GasLoss*deltaTime,0);
        BallastLoss=lqddrop(Record(cycle-1,7),BallastA1,Record(cycle-1,10)*BallastA2,BallastDensity,BallastSurface);
        Record(cycle,7)=max(Record(cycle-1,7)-BallastLoss*deltaTime,0);
        Record(cycle,5)=Record(cycle,6)+Record(cycle,7)+SysMass;

        %Acceleration for next step
        accel=liftAccel(Record(cycle,4),Record(cycle,5),Record(cycle,6),Record(cycle,3));
        Record(cycle,2)=max(accel(1),-9.8);
        Record(cycle,16:18)=accel(2:4);
        
        %Note the PID values
        Record(cycle,11:14)=status(4:7);
        Record(cycle,15)=target;

        if Record(cycle,4)<0
            break;
        end
    end
    airtime=Record;