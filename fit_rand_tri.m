function [triangles,T,N,rms,aicc,wrms] = fit_rand_tri(L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)

% [triangles,T,N,rms,aicc,wrms] = fit_rand_tri(L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)
% generates a single random set of Nt slip distributions across a population of (L,D) values.
%
% Inputs
%
% L           : horizontal distances along fault
% D           : offset values
% W           : weights on offset measurements
% Nt          : nb of triangles
% Lln         : minimum abscissa of triangle left apex
% Llx         : maximum abscissa of triangle left apex
% Lsn         : minimum abscissa of triangle summit
% Lsx         : maximum abscissa of triangle summit
% Dsn         : lower value of maximal offset
% Dsx         : upper value of maximal offset
% Lrn         : minimum abscissa of triangle right apex
% Lrx         : maximum abscissa of triangle right apex
%
% Outputs
%
% triangles : Nt x 1 cell array to store triangles vertices (geom2d syntax)
% T         : 1 x N_points array to store theoretical offsets at each data point
% N         : 1 x N_points array to store indexes of triangle closest to each data point
% rms       : plain rms
% aicc      : AICC value
% wrms      : weighted rms
%
% Yves Gaudemer - IPGP - 2019/12/27

Np = numel(L) ;
box = [Lsn Lsx Dsn Dsx] ; % Range of possible locations in (L,D) space of triangle summit

% Initialisation of arrays

Ll = zeros(Nt,1) ;
rise = zeros(Nt,4) ;
Lr = zeros(Nt,1) ;
fall = zeros(Nt,4) ;

Ls = zeros(Nt,1) ;
Ds = zeros(Nt,1) ;

Dist = zeros(Nt,Np) ;
T = zeros(1,Np) ;
N = zeros(1,Np) ;
triangles = cell(Nt,1) ;

% First triangle

Ll(1) = Lln + (Llx - Lln)*rand(1) ;
Lr(1) = Lrn + (Lrx - Lrn)*rand(1) ;
summit = randomPointInBox(box) ;
Ls(1) = summit(1) ;
Ds(1) = summit(2) ;

rise(1,:) = createLine([Ll(1) 0],[Ls(1) Ds(1)]) ;
fall(1,:) = createLine([Ls(1) Ds(1)],[Lr(1) 0]) ;
triangles{1} = [Ll(1) 0 ; Ls(1) Ds(1) ; Lr(1) 0] ;

% Next triangles

for i = 2:Nt
    
    boxi = box + [0 0 Ds(i-1) Ds(i-1)] ;
    
    while 1
        
        summit = randomPointInBox(boxi) ;
        % Triangle summit has to be also above rise and fall lines
        [~,valr] = aboveLine(summit,rise(i-1,:)) ;
        [~,valf] = aboveLine(summit,fall(i-1,:)) ;
        if (valr == 1 && valf == 1), break, end
        
    end
    
    Ll(i) = Ll(1) ;
    Lr(i) = Lr(1) ;
    Ls(i) = summit(1) ; Ds(i) = summit(2) ;
    rise(i,:) = createLine([Ll(i) 0],[Ls(i) Ds(i)]) ;
    fall(i,:) = createLine([Ls(i) Ds(i)],[Lr(i) 0]) ;
    triangles{i} = [Ll(i) 0 ; Ls(i) Ds(i) ; Lr(i) 0] ;

end

% Computes distances between points and triangles

for i = 1:Nt
  
   for j = 1:Np
       if L(j) < Ls(i)
           [dist,~] = aboveLine([L(j) D(j)],rise(i,:)) ;
       else
           [dist,~] = aboveLine([L(j) D(j)],fall(i,:)) ;
       end
      Dist(i,j) = abs(dist) ;
   end
   
end

% Computes theoretical offsets

for j = 1:Np
    
    dj = Dist(:,j) ;            % column vector of distances from point j to all triangles
    ij = find(dj == min(dj)) ;  % find closest triangle

    if dj <= Dsx
        N(j) = ij ;
    else
        N(j) = 0 ;
    end
    
    
    if L(j) < Ls(ij)
        trij = rise(ij,:) ;
    else
        trij = fall(ij,:) ;
    end
    
    T(j) = trij(2) + (L(j) - trij(1))*trij(4)/trij(3) ;    % Theoretical offset

end

% Computes RMS and WRMS

wrms = weight_rms(D,T,W) ;
rms = weight_rms(D,T,ones(size(D))) ;  % Equal weights

% Computes Akaike information criterion

K = 1 + 4*Nt ; % Three L values and 1 D value per each triangle
aicc = sum((T(:) - D(:)).^2) ;
if Np > 40
    aicc = Np*log(aicc/Np) + 2*K ;
else
    aicc = Np*log(aicc/Np) + 2*Np*K/(Np - K - 1) ;
end