%% ==================== Speaker Recognition System ===================== %%

%% ============================= Settings ============================== %%

users = arrayfun(@(x) x.name, dir('UYGHUR\train\'), 'UniformOutput', false);
users = users(3:end);

addpath(genpath('pre-processing\'));
addpath(genpath('feature-extraction\'));
addpath(genpath('feature-matching\'));

alpha        = 0.95;
samplingFreq = 8000;
nMFCC        = 12;
nFFT         = 256;
overlap      = 128;
nFilters     = 20;
minFreq      = 20;
maxFreq      = 4000;
K            = 128;

nUsers = length(users);
for i = 1:nUsers
    users{i} = users{i}(1:4);
end

% Turn off useless warnings
warning('off', 'stats:kmeans:FailedToConverge');
warning('off', 'stats:gmdistribution:IllCondCov');
warning('off', 'stats:gmdistribution:FailedToConverge');
warning('off', 'stats:gmdistribution:FailedToConvergeReps');

%% Feature Extraction
tic
userDistribution = cell(nUsers, 1);
features         = cell(nUsers, 1);
dnorm            = zeros(nUsers, 1);
ubmFeatures      = [];

for i = 1:nUsers
    [audio, fs] = audioread(char(strcat('UYGHUR\train\', users{i}, '_train.wav')));
    audio       = resample(audio, fs, samplingFreq);
    audio       = emphasize(vad(audio, samplingFreq), alpha);
    features{i} = mfcc(audio, samplingFreq, nFFT, overlap, nMFCC, nFilters, minFreq, maxFreq, 'edDn');
    ubmFeatures = [features{i}; ubmFeatures];    
end

%% Universal Background Model
ubmDistribution = gmm(ubmFeatures, K, 'k');

for i = 1:nUsers
    userDistribution{i} = map(features{i}, ubmDistribution);
    dnorm(i) = kldist(userDistribution{i}, ubmDistribution, 40000);
end
toc

%% Testing
tic

threshold = -0.1:0.001:1.6;
FA = zeros(size(threshold));
FR = zeros(size(threshold));

for i = 1:nUsers
    audioNames = arrayfun(@(x) x.name, dir(strcat('UYGHUR\test\', users{i}, '*.wav')), 'UniformOutput', false);
    
    for j = 1:length(audioNames)
        % Feature Extraction
        [audio, fs] = audioread(strcat('UYGHUR\test\', audioNames{j}));
        audio       = resample(audio, fs, samplingFreq);
        audio       = emphasize(vad(audio, samplingFreq), alpha);
        features    = mfcc(audio, samplingFreq, nFFT, overlap, nMFCC, nFilters, minFreq, maxFreq, 'edDn');
        
        distribution = map(features, ubmDistribution);
        [ubmllk, ~]  = llk(features, ubmDistribution);
        
        % Log likelihood of each user
        for k = 1:nUsers
            result = mean(llk(features, distribution) - ubmllk) / dnorm(k);
            
            if k == i
                FR = FR + (result < threshold);
            else
                FA = FA + (result >= threshold);
            end       
        end        
    end
end

% Normalize and Plot
total = length(dir('UYGHUR\test\*.wav'));
FA(FA > total) = total;
FR = FR / total;
FA = FA / total;
plot(threshold, FR, 'b');
hold on;
plot(threshold, FA, 'r')

[~, pos] = min(abs(FA-FR));
EER = (FA(pos) + FR(pos)) / 2;

fprintf('Best performance achieved at threshold = %.3f with an EER of %.2f%%\n', threshold(pos), 100*EER);

% Clear workspace
clear total ubmllk FA FR pos threshold result dnorm i j k K score
clear nUsers userScore audioNames results speaker total audio fs features
clear samplingFreq alpha nFFT overlap nMFCC nFilters minFreq maxFreq

toc