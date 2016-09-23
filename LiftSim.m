% LIFTSIM Overall simulation code, calculating state at each timestep
%   Inputs: 1D array of controller variables, 2D arracy of target altitudes
% and timing, bandwidth for controllers that use it
%   Output: Large table with system state at each timestep. Data as follows
% Time, Acceleration, Velocity, Altitude, All-up Mass, Gas Mass, Ballast
% Mass, Flight Mode (FSM controller), Gas Valve State (0-1), Ballast Valve
% State (0-1), P, I, D, D^2 (for controllers that use it), Target Altitude,
% Buoyancy Force, Gravitational Force, Drag Force
%   
%   Written by Anthony Lowther, 2016
function airtime=LiftSim(PID,TargetAlt,bandwidth)
    %Initial setup details
    GasMass = 0.096;
    BallastMass = 0.050;
    SysMass = 0.250;

    BalloonValve = 32.17e-6;
    BalloonPD = 250;

    BallastA2 = 32.17e-6;
    BallastDensity = 800;
    BallastSurface = 10;
    
    target=0;
    
    gravity = -9.8;
    Window=10; %Length of measurement widow passed to controller

    % Create the empty matrix to contain the flight Record and fill in
    % initial conditions
    Record=zeros(25001,18);
    Record(:,1)=0:0.4:10000;
    Record(1,6)=GasMass;
    Record(1,7)=BallastMass;
    Record(1,5)=SysMass+GasMass+BallastMass;
    accel=liftAccel(Record(1,4),Record(1,5),Record(1,6),Record(1,3));
    Record(1,2)=accel(1);
    
    % Adding normally distributed random variations to the altitude
    % measurement
    mu=0;
    sigma=0.5;
    altnoise=0;
    
    % Cycle through the time-steps
    for cycle=2:length(Record)
        %Calculate the length of the time-step that was just stepped over
        prevTime=Record(cycle-1,1);
        currTime=Record(cycle,1);
        deltaTime=currTime-prevTime;
        
        % Determine the target altitude for the current time, if there is
        % an error the target altitude is set to 0, bringing the craft to
        % the ground
        for n=1:length(TargetAlt)
            if currTime<TargetAlt(2,n)
                target=TargetAlt(1,max(n-1,1));
                break;
            elseif currTime>=TargetAlt(2,n)
                target=TargetAlt(1,n);
            else
                target=0;
            end
        end

        %Velocity and Altitude
        Record(cycle,3)=Record(cycle-1,3)+Record(cycle-1,2)*deltaTime; %Velocity calculation
        Record(cycle,4)=Record(cycle-1,4)+(Record(cycle-1,3)+Record(cycle,3))*deltaTime/2; %Altitude change
        altnoise=normrnd(mu,sigma)*(Record(cycle,1)-Record(cycle-1,1)); %Random value to add to the altitude measurement, scaled to the timestep
        Record(cycle,4)=Record(cycle,4)+altnoise;
        %Valve Conditions
        status=valveLogicFilter(target,bandwidth,Record(max(1,cycle-Window):cycle,4),Record(max(1,cycle-Window):cycle,1),PID); %Call the controller. Ensure that this is the correct controller
        Record(cycle,8:10)=status(1:3); % Record the flight mode (from FSM controller) as well as valve states on a scale from 0-1
        %Mass changes
        GasLoss=GRelease((Record(cycle,4)+Record(cycle-1,4))/2,Record(cycle-1,9)*BalloonValve,BalloonPD); % Calculate and record lifting gas released
        Record(cycle,6)=max(Record(cycle-1,6)-GasLoss*deltaTime,0);
        BallastLoss=lqdDrop(Record(cycle-1,7),Record(cycle-1,10)*BallastA2,BallastDensity,BallastSurface); % Calcilate and record the ballast released
        Record(cycle,7)=max(Record(cycle-1,7)-BallastLoss*deltaTime,0);
        Record(cycle,5)=Record(cycle,6)+Record(cycle,7)+SysMass; % Calculate the new system all-up mass

        %Acceleration for next step
        accel=liftAccel(Record(cycle,4),Record(cycle,5),Record(cycle,6),Record(cycle,3)); % Find the acceleration of the craft
        Record(cycle,2)=max(accel(1),gravity); % Record the acceleration for the next time step, cannot fall faster than gravity
        Record(cycle,16:18)=accel(2:4); % Record the forces acting on the balloon
        
        %Note the PID values
        Record(cycle,11:14)=status(4:7); % Record the P, I, D, D^2 values as passed from the controller (if passed)
        Record(cycle,15)=target; % Note the target altitude
        
        
        if Record(cycle,4)<0
            break; %Should the system hit the ground, break out of the loop (it crashed, nothing else will happen)
        end
    end
    airtime=Record; %Pass the Record out as output.