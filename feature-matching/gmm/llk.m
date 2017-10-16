function [llk, prob] = llk(data, gmm, idx)
%[llk, prob] = LLK(data, gmm, idx) computes the log-likelihood probability
%and posterior probability of each frame
%
%Input:
%   - data : a NxD matrix containing all the features
%   - gmm  : a struct with fields 'mu', 'sigma', 'w'
%   - idx  : a Dx1 boolean vector indicating which mixtures will be used
%            (optional)
%Output:
%   - llk  : the log-likelihood of all data points
%   - prob : the posterior probabilities of each mixture for each frame
%            (those should add up to 1 for each frame)

if ~exist('idx', 'var')
    prob = wlogprob(data', gmm.mu, gmm.sigma, gmm.w);
else
    prob = wlogprob(data', gmm.mu(:, idx), gmm.sigma(:, idx), gmm.w(idx));
end
    
llk = log(sum(exp(prob), 1));
end