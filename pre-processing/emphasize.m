function y = emphasize(x, alpha)
%y = EMPHASIZE(x, alpha) enhances the higher frequencies of the spectrum,
%which are generally reduced by the speech production process
% 
%Input: 
%	- x     : original signal
%	- alpha : pre-emphasis factor
%Output:
%	- y     : the emphasized signal

% Default value for aplha is 0.95

if nargin == 1
    alpha = 0.95;
end

if ~isvector(x)
    x = mean(x, 2); % convert to 1-channel signal
end

% y[n] = x[n] - alpha * x[n-1]
y = filter([1 -alpha], 1, x);

scale = sqrt((x'*x)/(y'*y));
y = y * scale;      % scale y to have the same energy as x

end
