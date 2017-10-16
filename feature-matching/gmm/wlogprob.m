function wlogprob = wlogprob(data, mu, sigma, w)
%wlogprob = WLOGPROB(data, mu, sigma, w) computes the weighted log 
%probabilities of a GMM
%
%Input:
%   - data     : a NxD array containg the feature vectors
%   - mu       : mean of the gmm
%   - sigma    : covariance of the gmm
%   - w        : weights of the gmm
%Output:
%   - wlogprob : the posterior probabilities of each mixture for each frame
%            (those should add up to 1 for each frame)

logden = sum(log(sigma), 1) + size(data, 1) * 1.83787706640935; % ndims * log(2*pi)
logexp = bsxfun(@plus, (1./sigma)' * (data .* data) - 2 * (mu./sigma)' * data, sum(mu.*mu./sigma)');
logprob = -0.5 * (bsxfun(@plus, logden',  logexp)); % log(p_i(data))
wlogprob = bsxfun(@plus, logprob, log(w));

end
