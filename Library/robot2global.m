function[xyG] = robot2global(pose,xyR)
% ROBOT2GLOBAL: transform a 2D point in robot coordinates into global
% coordinates (assumes planar world).
% 
%   XYG = ROBOT2GLOBAL(POSE,XYR) returns the 2D point in global coordinates
%   corresponding to a 2D point in robot coordinates.
% 
%   INPUTS
%       pose    robot's current pose [x y theta]  (1-by-3)
%       xyR     2D point in robot coordinates (1-by-2)
% 
%   OUTPUTS
%       xyG     2D point in global coordinates (1-by-2)



%Transformation Matrix to convert from B to I
transIB = [
    cos(pose(3)), -sin(pose(3)), pose(1);
    sin(pose(3)), cos(pose(3)), pose(2);
    0,0,1];

wb_mat = [xyR';1];
wi_mat = transIB*wb_mat;

%Return xyG as 1-by-2 vector
xyG = wi_mat(1:2, :)';


