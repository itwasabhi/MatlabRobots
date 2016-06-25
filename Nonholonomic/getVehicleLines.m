function allLines = getVehicleLines(vehic, simple)
% INPUTS
%   vehic
%   simple = if true, return only vehicle frames without wheels & trailer
%               hitches


%Unpack data and make assertions
q = vehic.state;
numTrailers = length(q)-3;
if (numTrailers>0)
    assert(numTrailers == length(vehic.config(3:end)), 'VehicleConfig does not match VehicleState');
end

%Get the lines for the leading car
carLines = SingleCar(vehic.config(1));
carLines = getLinesInGlobal(carLines, q(1:3));

%Get the lines for all trailers
allTrailerLines = [];
if numTrailers > 0
    trailerAngles = q(4:end);
    trailerDistances = vehic.config(3:end);
    trailerLength = vehic.config(2);
    
    prevOrigin = q(1:2);
    
    currTrailer = GetTrailerLines(prevOrigin, trailerAngles, trailerDistances, trailerLength);
    allTrailerLines = [allTrailerLines; currTrailer];
end

allLines = [carLines;allTrailerLines];

end


function chain=GetTrailerLines(prevOrigin, trailerAngles, trailerDistances, trailerLength)
chain = [];
for t=1:length(trailerAngles)
    newTrailerOrigin = [prevOrigin(1)-trailerDistances(t)*cos(trailerAngles(t)), ...
        prevOrigin(2)-trailerDistances(t)*sin(trailerAngles(t)), ...
        trailerAngles(t)];
    
    currTrailer = SingleCar(trailerLength);
    trailerHitch = [0,0,trailerDistances(t),0];
    currTrailer = [currTrailer; trailerHitch];
    
    currTrailer = getLinesInGlobal(currTrailer, newTrailerOrigin);
    chain = [chain; currTrailer];
    
    prevOrigin = newTrailerOrigin;
end

end


function lines=SingleCar(carLength,frontWheelAngle)

%Car Frame
carWidth = carLength*0.5;
carBumper = 1;
p1 = [-carBumper, -carWidth/2-carBumper]; %bottom left
p2 = [-carBumper, carWidth/2+carBumper]; %bottom right
p3 = [carLength+carBumper, carWidth/2+carBumper];
p4 = [carLength+carBumper, -carWidth/2-carBumper];
lines = [p1 p2;
    p2 p3;
    p3 p4;
    p4 p1];


%Rear Wheels
wheelRad = 0.5;
wheelLine = [-wheelRad, 0, wheelRad, 0];

lines = [lines;
    getLinesInGlobal(wheelLine, [0, -carWidth/2,0]);
    getLinesInGlobal(wheelLine, [0,carWidth/2, 0])
    ];

%Front Wheels
if nargin>1
    leftWheelPos = [carLength, -carWidth/2, frontWheelAngle];
    rightWheelPos = [carLength, carWidth/2, frontWheelAngle];
    lines = [lines;
        getLinesInGlobal(wheelLine, leftWheelPos);
        getLinesInGlobal(wheelLine, rightWheelPos)
        ];
end


end