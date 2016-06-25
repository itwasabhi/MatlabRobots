function vo = calcVO(robotMain, robotObs)
	vo(1,:) = robotMain.currPos + robotObs.currV;

    obsCenter   = robotObs.currPos - robotMain.currPos; %Pmoving-Pstil
	r_comb = (robotMain.rad + robotObs.rad);
    
    alpha = asin((r_comb)/mag(obsCenter));
    beta = atan2(obsCenter(2),obsCenter(1));

    d_tan = sqrt(mag(obsCenter)^2 - (r_comb)^2);
    
    obs_right = d_tan*[cos(beta+alpha); sin(beta+alpha)];
	obs_left  = d_tan*[cos(beta-alpha); sin(beta-alpha)];

    obsCenter = vo(1,:)+obsCenter;
    vo(2,:)   = vo(1,:)+obs_right';
    vo(3,:)   = vo(1,:)+obs_left';
    
    %Extend endpoints of obstacles
    aVec = vo(2,:)-vo(1,:); aVec = aVec./mag(aVec);
    bVec = vo(3,:)-vo(1,:); bVec = bVec./mag(bVec);
    
    extHorizon = 4;
    aVec = aVec.*extHorizon;
    bVec = bVec.*extHorizon;
    
    vo(2,:) = vo(1,:)+aVec;
    vo(3,:) = vo(1,:)+bVec;
end

function res=  mag(vector)
res =  sqrt(vector(1)^2 + vector(2)^2);
end
