function weights = create_weights(D,values)

% weights = create_weights(D,values) generates weights for data contained in vector D
% 
% Inputs
%
% D      : dataset
% values : if values is a single scalar (between 0 and 1), it is interpreted as a quality factor
%          if it is a vector, it is yaken as uncertainties of values contained in D
%
% Yves Gaudemer - IPGP - 2019/12/27

if isscalar(values)         % values = single quality factor
    
    weights = values*ones(size(D)) ;
    
elseif isvector(values)     % values = vector of uncertainties 
    
    if not(all(size(values) == size(D)))
        
        error('Both inputs should have the same size')
        
    end
    
    weights = 1./(values.^2) ;
    
end