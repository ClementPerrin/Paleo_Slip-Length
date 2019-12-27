function [dist,value] = aboveLine(point,line)

% [dist,value] = aboveLine(point,line)
% computes the vertical distance between a point and a line.
% used by fit_rand_tri.m funtion
%
% Inputs
%
% point is a [x y] vector (as in matGeom toolbox)
% line is a [x0 y0 dx dy] vector (as in matGeom toolbox)
%
% Outputs
%
% dist is the vertical distance
% value is 1/-1 when the point is above/below the line
% if the line is vertical, dist = Inf and value = NaN are returned.
%
% Yves Gaudemer - IPGP - 2019/12/27

if line(3) == 0                     % line is vertical
    dist = Inf ;
    value = NaN ;
else
    y2 = line(2) + (point(1) - line(1))*line(4)/line(3) ;
    dist = point(2) - y2 ;
    value = sign(dist) ;
end