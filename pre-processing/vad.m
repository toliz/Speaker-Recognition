function [speech, V] = vad(signal, fs, threshold)
%[speech, V] = VAD(signal, fs, threshold) performes a Voice Activation
%Detection algorithm based on short term energy that cuts off non-speech
%portions of the signal.
% 
%Input:
%	- signal    : the original signal
%	- fs        : sampling rate of the signal
%	- threshold : cut off threshold, default value 1e-5 (for completely 
%                noiseless enviroments)
%Output:
%   - speech    : the original signal with less noise no pause between words
%   - V         : boolean vector (true for speech part/ false for silent part)
%
%If there are no output arguments it plots V alongside with signal

%% Short-Term Energy Estimation
N        = length(signal);
window   = floor(0.01*fs);
power    = signal .* signal;
energy   = sum(power);                  % total energy
stEnergy = zeros(floor(N/window), 1);	% short-term energy
V        = zeros(N, 1);

if exist('threshold', 'var')
    minEnergy = threshold * energy;
else
    minEnergy = 1e-5 * energy;
end

for i = 1:window:N-window
    stEnergy(ceil(i/window)) = sum(power(i:i+window));
end

%% ========================= Non-speech Removal ======================== %% 
for i = 1:window:N-window
    if stEnergy(ceil(i/window)) > minEnergy
        V(i:i+window-1) = 1;
    end
end
    
if nargout == 0
    plot(signal);
    hold on;
    plot(V*10*sqrt(energy/N), 'r');
    hold off;
end;

speech = signal(V == 1);    % keep only the speech portion of the signal

end
