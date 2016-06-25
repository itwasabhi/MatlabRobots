function VOPatrols()
clc; close all;
%Parameters
nRobots = 3;
runtime = 500;

figure; hold on;
axis([-10,10,-10,10]);

%temp -- load patrolPts
tempPat{1} = [-4.5392   -4.0058; 2.9724    6.8129];
tempPat{2} = [ 0.2995    7.2807; -2.2811   -5.6433];
tempPat{3} = [ 2.8341   -2.0175; 2.0046    4.1228];

%Initialize robot positions and patrol paths
allRobots = cell(nRobots,1);
for j=1:nRobots
    rad = rand(1)*0.3+0.3;%random rad  from 0.1 to 0.2
    maxV = rand(1)*0.5+0.3;%random maxV from 0.1 to 0.6
    ptID = 2;
    patrolPts = tempPat{j};%ginput(2); % 
    currPos = [patrolPts(1,:)];
    currV = [0,0];
    
    allRobots{j} = struct('rad', rad, 'maxV', maxV,'ptID', ptID, 'patrolPts', patrolPts, 'currPos', currPos, 'currV', currV);
    
    plot(patrolPts(:,1), patrolPts(:,2), 'r--');
end
h_all = plotRobots(allRobots);
hvo = cell(nRobots,1);
hdes = [];

%Calculate velocities and move robot at each timestep
for j=1:runtime
    delete(h_all);
    if ~isempty(hdes)
        delete(hdes);
    end
    
    h_all = plotRobots(allRobots);
    
	colFree=checkRobotAssertion(allRobots);
    if ~colFree
        save('crashData.mat');
        assert(colFree, 'Robots are not collision free');
    end

    ptComp = zeros(nRobots,1);
    
    %Calculate desired velocities for each robot (disregard VO)
    for r=1:nRobots
        cRob = allRobots{r};
        deltaGoal = cRob.patrolPts(cRob.ptID,:) - cRob.currPos(1:2);
        
        desV = deltaGoal; ptComp(r) = true;
        if mag(desV) > cRob.maxV
            desV = capV(desV, cRob.maxV);
            ptComp(r) = false;
        end
        allRobots{r}.currV = desV;
        hdes(r) = plot([cRob.currPos(1), cRob.currPos(1)+desV(1)],[cRob.currPos(2),cRob.currPos(2)+desV(2) ], 'm', 'linewidth', 2);
    end
    
    for r=1:nRobots
        if r<10
            %Calculate all velocity obstacles for robot 'r'
            allObst = cell(nRobots,1);
            for o=1:nRobots
                if o~=r %Calculate VO for robot 'r' with robot 'o' as the obstacle
                    currVO = calcVO(allRobots{r}, allRobots{o});
                    allObst{o} = currVO;
                end
            end
%             if ~isempty(hvo{r})
%                 delete(hvo{r});
%             end
%             hvo{r}=plotVO(allObst);
%             
            
            %Check if desV is within obstacle. If it is, find safe v closest to
            %desired
            velEndPt = allRobots{r}.currPos + allRobots{r}.currV;
            [res, errVO] = checkVO(velEndPt, allObst);
            
            if res==false %Point is inside an obstacle
                cRob = allRobots{r};                
                edgePt = findVOEdge(allObst{errVO}, velEndPt);
                %edgeV = capV(edgeV, allRobots{r}.maxV);
                allRobots{r}.currV = edgePt -cRob.currPos;
                delete(hdes(r));
                hdes(r) = plot([cRob.currPos(1), cRob.currPos(1)+allRobots{r}.currV(1)],[cRob.currPos(2),cRob.currPos(2)+allRobots{r}.currV(2) ], 'r', 'linewidth', 3);
            end
        end
        
        allRobots{r}.currPos = allRobots{r}.currPos + allRobots{r}.currV;
        if ptComp(r)
            newID = allRobots{r}.ptID+1;
            if newID>size(allRobots{r}.patrolPts,1)
                newID = 1;
            end
            allRobots{r}.ptID = newID;
        end
    end

    pause(0.1);
end


end

function colFree=checkRobotAssertion(robots)
colFree = true;
for j=1:length(robots)
    for k=j+1:length(robots)
        r_comb = robots{j}.rad + robots{k}.rad;
        if dist(robots{j}.currPos, robots{k}.currPos) < r_comb
            colFree = false;
        end
    end
end
end



function res=  mag(vector)
res =  sqrt(vector(1)^2 + vector(2)^2);
end



function edgept = findVOEdge(vo, pt)
opt1 = project_point_to_line_segment(vo(1,:), vo(2,:), pt);
opt2 = project_point_to_line_segment(vo(1,:), vo(3,:), pt);

if dist(opt1, pt) > dist(opt2, pt)
    edgept = opt2;
else
    edgept = opt1;
end
end

function desV = capV(desV, maxV)
if mag(desV) > maxV
    desV = desV./mag(desV) * maxV;
end
end

function hall = plotVO(allVO)
hall = [];
for i=1:length(allVO)
    if ~isempty(allVO{i})
        hc = plotSingVO(allVO{i});
        hall = [hall, hc];
    end
end
end

