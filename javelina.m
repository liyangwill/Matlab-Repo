function t=javelina(m,n,repeat)

clc; close all;
% m-foot wall, n javelina case, function javelina returns time t
t=zeros(repeat,1);
if m<n
    disp('Wall length should be bigger than javelina number.');
    return
end
% m>n, PositionDis is the position distribution of n javelina alont m
% foot-wall
for j=1:repeat
    PositionDis=randperm(m);
    PositionDis=PositionDis(1:n);
    PositionDis=sort(PositionDis);
    % LeftOut and RightOut record the javeline going off the wall from each
    % side
    LeftOut=0;
    RightOut=0;
    % Direction has the direction of each javeline, +1 heading right, -1 heading
    % left, 0 when they go off the wall, initial values are +1 or -1 randomly.
    Direction=2*randi(2,1,n)-3;
    % num is the number of javeline that stay to the wall
    num=n; 
    while num>=1
        PositionDis=PositionDis+0.5*Direction;
        for i=(1+LeftOut):(n-RightOut-1)
            if PositionDis(i)==PositionDis(i+1)
                Direction(i)=-Direction(i);
                Direction(i+1)=-Direction(i+1);
            end
         end
        PositionDis=PositionDis+0.5*Direction;
        for i=(1+LeftOut):(n-RightOut-1)
            if PositionDis(i)==PositionDis(i+1)
                Direction(i)=-Direction(i);
                Direction(i+1)=-Direction(i+1);
            end
        end
         
        if PositionDis(1+LeftOut)==0
            Direction(1+LeftOut)=0;
            LeftOut=LeftOut+1;
        end
        
        if PositionDis(n-RightOut)==m+1
            Direction(n-RightOut)=0;
            RightOut=RightOut+1;            
        end
        
        num=n-RightOut-LeftOut;
        t(j)=t(j)+1;
    end
end
hist(t);


