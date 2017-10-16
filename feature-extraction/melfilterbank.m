function filterBank = melfilterbank(lowFreq, highFreq, nFilters, nFFT)
%filterBank = MELFILTERBANK(lowFreq, highFreq, nFilters, nFFT)
%computes the Mel Filter Bank with the specified parameters.
%
%Input:
%	- lowFreq    : lowest endpoint of the filterbank in the frequency axis
%	- highFreq   : higest endpoint of the filterbank in the frequency axis
%	- nFilters   : number of filters
%	- nFFT       : number of Fourier Transform points
%Output:
%	- filterBank : a sparse matrix containing a filter in each row

freq2mel = @(f) 1127*log(1+f/700);     % Convert from frequency to Mel scale
mel2freq = @(m) 700*(exp(m/1127)-1);   % Convert from mel scale to frequency

% Keep only non-negative frequencies
bandwidth = floor(nFFT/2+1);

% Set mel scale endpoints
lowMel = freq2mel(lowFreq);
highMel = freq2mel(highFreq);

% Set frequency axis endpoints for filterbank
mels = linspace(lowMel, highMel, nFilters+2);
freqs = mel2freq(mels);
points = ceil(nFFT/(2*highFreq) * freqs);

% Calculate filerbank
filterBank = zeros(nFilters, bandwidth);

for i = 1:nFilters
    for j = 1:bandwidth
        filterBank(i, j) = melfilter(points, i+1, j);
    end
end

filterBank = sparse(filterBank);

% Plot filterbank
if nargout == 0
    hold on;
    for i = 1:nFilters
        plot(linspace(0, highFreq, bandwidth), filterBank(i, :));
    end
    hold off;
end

end
