function new = resample(signal, oldRate, newRate)
%new = RESAMPLE(signal, oldRate, newRate) resamples the original signal 
%with a new sample rate
%
%Input:
%	- signal  : the signal to be resampled
%	- oldRate : the sampling rate of the signal
%	- newRate : the desired sampling rate of the signal
%Output:
%	- new     : the resampled signal

if ~ismatrix(signal)
    error('signal should be a vector')
elseif size(signal, 2) ~= 1
    signal = mean(signal, 2);
end

% Suppress warning due to non-integer rate
warning('off', 'MATLAB:colon:nonIntegerIndex');

rate = oldRate/newRate;
new = signal(1:rate:end);

end
