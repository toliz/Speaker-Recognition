function H = melfilter(f, m, k)
% H = MELFILTER(f, m, k) returns the k-th point of the m-th Mel Filter Bank
% 
%Input:
%	- f : is the sequence of filter bank endpoints
%	- m : is the mid-point of the filterbank to be used
%	- k : is a point in the frequency axis
% Output:
%	- H : the value of the k-th point of the m-th filterbank

if k < f(m-1)
    H = 0;
elseif k < f(m)
    H = (k - f(m-1))/(f(m)-f(m-1));
elseif k < f(m+1)
    H = (f(m+1)-k)/(f(m+1)-f(m));
else
    H = 0;
end

end
