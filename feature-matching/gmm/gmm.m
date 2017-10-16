function gmm = gmm(data, nClusters, options)
%gmm = GMM(data, nClusters, options) produces a Gaussian Mixture Model 
%using the built-in gmdistribution class
%
%Input:
%   - data      : A NxD matrix (N data points in the D space)
%   - nClusters : number of Gaussian Distributions
%   - options   : any substring of 'km' (k-means initialization, minimum
%                 covariance)
%Output:
%   - gmm       : a struct containing the means, covariances and weigths of
%                 the distributions (gmm.mu, gmm.sigma, gmm.w)

ndims = size(data, 2);

if any(options == 'k')
    % K-means inialization
    [idx, c] = kmeans(data', nClusters);
    w = zeros(1, nClusters);
    sigma = zeros(1, ndims, nClusters);
    for j = 1:nClusters
        w(j) = length(idx==j) / size(data, 1);
        sigma(:, :, j) = diag(cov(data(idx==j, :)));
    end
    S = struct('mu', c', 'Sigma', sigma, 'PComponents', w);
    
    model = gmdistribution.fit(data, nClusters, 'Start', S, 'CovType', 'Diagonal');
else
    model = gmdistribution.fit(data, 'Replicates', 3, 'CovType', 'Diagonal');
end

gmm = struct('mu', model.mu', 'sigma', ...
    reshape(model.Sigma, size(model.mu')), 'w', model.PComponents');

if any(options == 'm')
    gmm.sigma = max(gmm.sigma, 0.03);
end

end