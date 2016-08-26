function status=valveLogic(score,D,lopen,gopen,gvalve,lvalve)
    status=zeros(1,2);
    if score>0 && D>0
        status(1)=min(lvalve,lvalve*score/lopen);
    elseif score<0 && D<0
        status(2)=min(gvalve,gvalve*-score/gopen);
    end