function Suitability=FlightOps(PID)
    TargetAlt=10000;
    StartTime=1900;
    Record=LiftSimOpt(PID, TargetAlt);
    error=0;
    for n=1:length(Record)
        if Record(n,1)>StartTime
            error=error+(abs(Record(n,4)-TargetAlt))^2;
            Suitability=error/1000;
        end
    end
