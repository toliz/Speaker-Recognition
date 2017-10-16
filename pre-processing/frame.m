function blocks = frame(signal, window, overlap)
%blocks = FRAME(signal, window, overlap) divides the original singal into 
%smaller overlapping ones
%
%Input:
%	- signal  : signal to be segmented
%	- window  : length of blocks
%	- overlap : distance between blocks
%Output:
%	- blocks  : a matrix whose rows contain the signal blocks

% Set default values for windows and overlap
if nargin == 1
    window  = 256;
    overlap = 128;
end

N       = length(signal);                   % Total number of samples
nBlocks = floor((N-window)/overlap) + 1;	% Number of blocks used
blocks  = zeros(nBlocks, window);           % Initialization of the blocks

for idx = 1:nBlocks
    start = overlap*(idx-1) + 1;            % start sample for each block
    blocks(idx, :) = signal(start:start+window-1);
end

end
