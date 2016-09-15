function Suitability=FlightOps(PID)
    TargetAlt=[10000,8000;0,3600];
    Bandwidth=500;
    StartTime=0;
    Record=LiftSimFSM(PID, TargetAlt,Bandwidth);
    error=0;
    try
        for n=2:length(Record)
            if Record(n,1)>StartTime
                for p=2:length(TargetAlt)
                    if Record(n,1)>TargetAlt(2,p-1) && Record(n,1)<TargetAlt(2,p)
                        target=TargetAlt(1,p-1);
                        break;
                    else
                        target=TargetAlt(1,p);
                    end
                end
                error=error+(abs(Record(n,4)-target))^2;
            end
        end
        Suitability=error/length(Record);
    catch ME
        ME
    end