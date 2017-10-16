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
end

toc

%% Testing
tic
score = 0;
total = 0;
for i = 1:nUsers
    userScore = 0;
    audioNames = arrayfun(@(x) x.name, dir(strcat('UYGHUR\test\', users{i}, '*.wav')), 'UniformOutput', false);
    
    for j = 1:length(audioNames)
        % Feature Extraction
        [audio, fs] = audioread(strcat('UYGHUR\test\', audioNames{j}));
        audio       = resample(audio, fs, samplingFreq);
        audio       = emphasize(vad(audio, samplingFreq), alpha);
        features    = mfcc(audio, samplingFreq, nFFT, overlap, nMFCC, nFilters, minFreq, maxFreq, 'edDn');
        
        % Log likelihood of each user
        results = zeros(nUsers, 1);
        for k = 1:nUsers
            results(k) = mean( llk(features, userDistribution{k}));
        end
        
        % Checking for the right user
        [~, speaker] = max(results);
        if speaker == i
            userScore = userScore + 1;
        end
    end
    score = score + userScore;
    total = total + length(audioNames);
    
    fprintf('User %s had %.2f success rate\n', char(users{i}), 100*userScore/length(audioNames));
end

fprintf('\nTotal Score is %.2f\n', 100*score/total);

clear nUsers userScore audioNames results speaker total audio fs i j k K score
clear samplingFreq alpha nFFT overlap nMFCC nFilters minFreq maxFreq features

toc