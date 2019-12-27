function [Ll_best,Lr_best,Ls_best,Ds_best,aicc_best,wrms_best] = N_fit_rand_tri(Nr,L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)

% [Ll_N,Lr_N,Ls_N,Ds_N,rms_N,aicc_N,wrms_N] = N_fit_rand_tri(Nr,L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx)
% generates Nr random sets of Nt triangular slip distributions across a population of (L,D) values
% and finds the set that achieves the best weighted rms.
%
% Inputs
%
% Nr          : nb of runs with random choices of triangles
% L           : horizontal distances along fault
% D           : Offset values
% W           : weights of D values
% Nt          : nb of triangles
% Lln         : minimum abscissa of triangle left end
% Llx         : maximum abscissa of triangle left end
% Lsn         : minimum abscissa of triangle summit
% Lsx         : maximum abscissa of triangle summit
% Dsn         : minimum incremental offset at triangle summit
% Dsx         : maximum incremental offset at triangle summit
% Lrn         : minimum abscissa of triangle right end
% Lrx         : maximum abscissa of triangle right end
%
% Outputs
%
% wrms_best      : minimum weighted rms value among the N_runs
% aicc_best      : AICC for the triangle set achieving the best wrms (see above)
% Ll_best        : Nt x 1 vector of left abscissae for the best set of triangles
% Lr_best        : Nt x 1 vector of right abscissae for the best set of triangles
% Ls_best        : Nt x 1 vector of summit abscissae for the best set of triangles
% Ds_best        : Nt x 1 vector of offset values for the best set of triangles
%
% Yves Gaudemer - IPGP - 2019/12/27


% Initialisation of various arrays

Np = numel(L) ;

Ll_N = zeros(Nt,Nr) ;
Lr_N = zeros(Nt,Nr) ;
Ls_N = zeros(Nt,Nr) ;
Ds_N = zeros(Nt,Nr) ;
T_N = zeros(Nr,Np) ;
N_N = zeros(Nr,Np) ;
rms_N = zeros(1,Nr) ;
aicc_N = zeros(1,Nr) ;
wrms_N = zeros(1,Nr) ;

% Runs

for k = 1:Nr
    
    [triangles,T,N,rms,aicc,wrms] = fit_rand_tri(L,D,W,Nt,Lln,Llx,Lsn,Lsx,Dsn,Dsx,Lrn,Lrx) ;
    
    for i = 1:Nt
        triangle = triangles{i} ;
        Ll_N(i,k) = triangle(1,1) ;
        Lr_N(i,k) = triangle(3,1) ;
        Ls_N(i,k) = triangle(2,1) ;
        Ds_N(i,k) = triangle(2,2) ;
    end
    
    T_N(k,:) = T ;
    N_N(k,:) = N ;
    rms_N(k) = rms ;
    aicc_N(k) = aicc ;
    wrms_N(k) = wrms ;
    
end

% Finding best wrms and corresponding parameters

wrms_best = min(wrms_N) ;
aicc_best = aicc_N(wrms_N == wrms_best) ;
Ll_best = Ll_N(:,wrms_N == wrms_best) ;
Lr_best = Lr_N(:,wrms_N == wrms_best) ;
Ls_best = Ls_N(:,wrms_N == wrms_best) ;
Ds_best = Ds_N(:,wrms_N == wrms_best) ;