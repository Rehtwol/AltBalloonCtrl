%Scoring function to test controller
%FLIGHTOPS input is controller parameters in a 1-dimensional matrix
%   Output is summation of error^2 at each step
function Suitability=FlightOps(PID)
    %Defining target flight altitudes
    TargetAlt=[10000,10000;0,5000];
    %Bandwidth for controllers that use it, 500 for ISA, 1000 w/ noise
    Bandwidth=500;
    %To ignore initial part of simulation (the ascent) for scoring
    %StartTime>0
    StartTime=2000;
    %Record stores simulation results
    Record=LiftSim(PID, TargetAlt,Bandwidth);
    error=0;
    try
        for n=2:length(Record)
            if Record(n,1)>StartTime
                for p=2:length(TargetAlt)
                    %Determining the correct target altitude at any given
                    %timestep
                    if Record(n,1)>TargetAlt(2,p-1) && Record(n,1)<TargetAlt(2,p)
                        target=TargetAlt(1,p-1);
                        break;
                    else
                        target=TargetAlt(1,p);
                    end
                end

                steperr=(Record(n,4)-target)^2; %Calculate error scoring
                error=error+steperr; %Accumulate into "error"
                Suitability=error; %Update Suitability.
            end
        end

    catch ME
        print('Error in FlightOps:')
        ME
    end