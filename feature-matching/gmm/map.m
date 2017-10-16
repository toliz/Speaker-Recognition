function gmm = map(features, ubm, tau)
%gmm = MAP(features, ubm, tau) - maximum a posteriori probabilities. Adapts
%a speaker specific GMM from UBM using speaker's MFCC
%
%Input:
%   - features : a matrix containing Mel Frequency Cepstral Coefficients.
%                Each row contains a MFCC vector for a particular frame
%   - ubm      : a struct with fields 'mu', 'sigma', 'w' representing the
%                universal background model
%   - tau      : the MAP adaptation relevance factor (default: 16.0)
%Output:
%   - gmm      : a struct containing speaker specific GMM hyperparameters

if nargin < 3
    tau = 16.0;
end

data = features';

%% Compute the posterior probability of mixtures for each frame
[loglikelihood, wlogprob] = llk(features, ubm);
postprob = exp(bsxfun(@minus, wlogprob, loglikelihood));  % Pr(i|x_t)

%% Sufficient Statistics
N = sum(postprob, 2)';
E = data * postprob';
E2 = (data .* data) * postprob';

%% Adaptation
alpha = N ./ (N + tau); % MAP adaptation coefficient

mu_ML = bsxfun(@rdivide, E, N);
m = bsxfun(@times, ubm.mu, (1 - alpha)) + bsxfun(@times, mu_ML, alpha);

sigma_ML = bsxfun(@rdivide, E2, N);
s = bsxfun(@times, (ubm.sigma+ubm.mu.^2), (1 - alpha)) + bsxfun(@times, sigma_ML, alpha) - (m .* m);

w_ML = N / sum(N);
w = bsxfun(@times, ubm.w', (1 - alpha)) + bsxfun(@times, w_ML, alpha);
w = w' / sum(w);

gmm = struct('mu', m, 'sigma', s, 'w', w);  % GMM

end
