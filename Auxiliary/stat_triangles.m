function [ml,sl,mr,sr,mls,sls,mds,sds] = stat_triangles(Ll_M,Lr_M,Ls_M,Ds_M)

% [ml,sl,mr,sr,mls,sls,mds,sds] = stat_triangles(Ll_M,Lr_M,Ls_M,Ds_M)
% computes mean and std of values output by the M_N_fit_rand_tri.m program
%
% Yves Gaudemer - IPGP - 2019/12/27

[nt,~] = size(Ll_M) ;
ml = zeros(nt,1) ;
sl = zeros(nt,1) ;
mr = zeros(nt,1) ;
sr = zeros(nt,1) ;
mls = zeros(nt,1) ;
sls = zeros(nt,1) ;
mds = zeros(nt,1) ;
sds = zeros(nt,1) ;

for i =1:nt
    
    disp(['triangle ',int2str(i)])
    disp('left L')
    Ll = Ll_M(i,:) ;
    ml(i) = mean(Ll);
    sl(i) = std(Ll);
    disp(['Ll = ',sprintf('%0.1f',ml(i)),' ± ',sprintf('%0.1f',sl(i)),' m'])
    disp('right L')
    Lr = Lr_M(i,:);
    mr(i) = mean(Lr);
    sr(i) = std(Lr);
    disp(['Lr = ',sprintf('%0.1f',mr(i)),' ± ',sprintf('%0.1f',sr(i)),' m'])
    disp('top L')
    Ls = Ls_M(i,:);
    mls(i) = mean(Ls);
    sls(i) = std(Ls);
    disp(['Ls = ',sprintf('%0.1f',mls(i)),' ± ',sprintf('%0.1f',sls(i)),' m'])
    disp('top D')
    Ds = Ds_M(i,:);
    mds(i) = mean(Ds);
    sds(i) = std(Ds);
    disp(['Ds = ',sprintf('%0.1f',mds(i)),' ± ',sprintf('%0.1f',sds(i)),' m'])
    
end