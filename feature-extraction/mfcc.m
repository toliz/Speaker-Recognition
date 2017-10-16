function features = mfcc(signal, fs, nFFT, overlap, nMFCC, nFilters, minFreq, maxFreq, options)
%features = MFCC (signal, fs, NFFT, overlap, nMFCC, nFilters, minFreq, ...
%                 maxFreq, options)
%returns the Mel Frequency Cepstral Coefficients and the energy of a signal
%as well as their derivatives
%
%Input:
%	- singal   : the speech signal
%	- fs       : sampling frequency
%	- alpha    : emphasization coefficient
%	- nFFT     : number of FFT points (length of framming window)
%	- overlap  : number of overlapping points (in the window)
%	- nMFCC    : number of Mel Frequency Cepstral Coefficients
%	- nFilters : number of filters
%	- minFreq  : minimum frequency for the filter bank
%	- maxFreq  : maximum frequency for the filter bank
% 	- options  : any substring of 'edDnp' (energy, deltas, deltasdeltas, ...
%               normalization, plot)
%Output:
%	- features : a matrix containing the features
%
%For fs = 8 KHz and 30 ms windows, nFFT should be around 256 and for 10
%ms overlaps, overlap should be around 128 (those should better be powers
%of 2)
%
%If there are no output arguments it visualizes the MFCC

addpath('.\pre-processing\');

%% Mel Frequency Cepstral Coefficients
block      = frame(signal, nFFT, overlap);                      % framming
block      = bsxfun(@times, block', hamming(nFFT));             % windowing
spectrum   = abs(rfft(block));                                  % DFT
filterBank = melfilterbank(minFreq, maxFreq, nFilters, nFFT);
cepstrum = dct(log(max(filterBank*spectrum, eps)))';            % cepstrum

MFCC = cepstrum(:, 2:nMFCC+1); % exclude 0th MFCC coefficient


%% Energy
if any(options == 'e') || any(options == 'E')
    energy = log(sum(block .^ 2, 1))';
    MFCC = [MFCC energy];
    nMFCC = nMFCC + 1;
end

%% Cepstral Mean and Variance Normalization
if any(options == 'n') || any(options == 'N')
    mu = mean(MFCC, 1);
    stdev = std(MFCC, [], 1);

    MFCC = bsxfun(@minus, MFCC, mu);
    MFCC = bsxfun(@rdivide, MFCC, stdev);
end

%% Deltas
nBlocks = size(block, 2);
dfilter = (4:-1:-4) / 60;
ddfilter = (1:-1:-1) / 2;
ww = ones(5, 1);
cx = [MFCC(ww, :); MFCC; MFCC(nBlocks*ww, :)];
delta = reshape(filter(dfilter, 1, cx(:)), nBlocks+10, nMFCC);
delta(1:8, :) = [];
deltadelta = reshape(filter(ddfilter, 1, delta(:)), nBlocks+2, nMFCC);
deltadelta(1:2, :) = [];
delta([1 nBlocks+2], :) = [];

features = MFCC;
if any(options == 'd')
    features = [features delta];
end
if any(options == 'D')
    features = [features deltadelta];
end

%% Plotting
if nargout == 0 || any(options == 'p') || any(options == 'P')
    t = (0:overlap:length(signal) + nFFT/2)/fs;
    c = 1:3*nMFCC+3;
    imagesc(t, c, features');
    
    axis('xy');
    xlabel('Time (s)');
    ylabel('Mel-cepstrum coefficient');
    
    colormap('default');
    colorbar;
end

end
