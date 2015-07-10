function Hd = samplfilter(P,Q,N)
%SAMPLFILTER Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the DSP System Toolbox 8.2.
%
% Generated on: 14-Jun-2012 16:45:05
%

Fpass = 900;   % Passband Frequency
Fstop = 999;  % Stopband Frequency
Apass = 1;          % Passband Ripple (dB)
Astop = 60;          % Stopband Attenuation (dB)
Fs    = N;  % Sampling Frequency

h = fdesign.rsrc(P, Q, 'Lowpass', 'fp,fst,ap,ast', Fpass, Fstop, Apass, ...
    Astop, Fs);

Hd = design(h, 'kaiserwin');



% [EOF]
