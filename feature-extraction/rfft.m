function y = rfft(x)
%y = RFFT(x) calculates the DFT only for non-negative frequencies, using
%the built-in FFT function
%
%Input:
%   - x : the time domain vector. (If x is a matrix it treats each column
%         as a vector)
%Output:
%   - y : the frequency domain vector (has half plus one the elements of x)

nFFT = size(x, 1);
y = fft(x);
y = y(1:nFFT/2+1, :);

end