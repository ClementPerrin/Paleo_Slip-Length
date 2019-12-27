function [Lnew,Dnew,Wnew] = merge_dataset(L1,D1,W1,L2,D2,W2)

% [Lnew,Dnew,Wnew] = merge_dataset(L1,D1,W1,L2,D2,W2)
% merges two data set of the type (L,D,W).
% It can be used before M_N_fit_rand_tri.m
%
% Yves Gaudemer - IPGP - 2019/12/27

L = [L1 ; L2] ;
D = [D1 ; D2] ;
W = [W1 ; W2] ;

[Lnew, indices] = sort(L) ;
Dnew = D(indices) ;
Wnew = W(indices) ;