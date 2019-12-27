function wrms = weight_rms(observed,predicted,weights)

% wrms = weight_rms(observed,predicted,weights)
% computes weighted rms for a set of observed/predicted values
% used by fit_rand_tri.m function.
%
% Yves Gaudemer - IPGP - 2019/12/27

if nargin == 2
    weights = ones(size(predicted)) ;
end

wrms = (predicted(:) - observed(:)).^2 ;
wrms = weights(:).*wrms ;
wrms = sum(wrms)/sum(weights(:)) ;
wrms = sqrt(wrms) ;