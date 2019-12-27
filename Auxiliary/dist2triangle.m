function dist = dist2triangle(point,triangle)

% auxiliary function used in the M_N_fit_rand_tri.m function
%
% Yves Gaudemer - IPGP - 2019/12/27

if point(1) <= triangle(2,1)
    
    line = createLine(triangle(1,:),triangle(2,:)) ;
    [dist,~] = aboveLine(point,line) ;
    
else
    
    line = createLine(triangle(2,:),triangle(3,:)) ;
    [dist,~] = aboveLine(point,line) ;
    
end