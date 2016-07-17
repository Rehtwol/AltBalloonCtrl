function valve=valveopen(alt,time,target)
    area = 7.07e-6;
    
    Kp = 98.5172;
    Ki = 0.0127;
    Kd = 49.0198;
    n = length(alt);
    alterr = zeros(n,1);
    valve=[0,0];
    for r = 1:n
        alterr(r)=target-alt(r);
    end
    
    P=(alterr(n))
    I=trapz(alterr,time)
    D=(alterr(n)-alterr(n-1))/(time(n)-time(n-1))
    
    
    if D>0

        score=Kp*P+Ki*I+Kd*D;
        valve(2)=score;
        
        if score<=0
            valve(1)=0;
        elseif score>=1000
            valve(1)=area;
        else
            valve(1)=area*score/1000;
        end
    else
        valve(1)=0;
    end