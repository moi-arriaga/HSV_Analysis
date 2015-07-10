function Hd = lowp
%LOWP Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the DSP System Toolbox 8.2.
%
% Generated on: 15-Jun-2012 09:35:40
%

Fpass = 900;   % Passband Frequency
Fstop = 999;   % Stopband Frequency
Apass = 1;     % Passband Ripple (dB)
Astop = 60;    % Stopband Attenuation (dB)
Fs    = 2000;  % Sampling Frequency

h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);

Hd = design(h, 'kaiserwin');



% [EOF]
