function Hd = lowpass(varargin)
%LOWP Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the DSP System Toolbox 8.2.
%
% Generated on: 15-Jun-2012 09:35:40
%
Fpass = 900;   % Passband Frequency
Fstop = 1000;   % Stopband Frequency
Fs    = 4000;  % Sampling Frequency
if nargin>0
    Fs=varargin{1};
end
if nargin>1
    Fstop=varargin{2};
    Fpass=.9*varargin{2};
end

Apass = 1;     % Passband Ripple (dB)
Astop = 60;    % Stopband Attenuation (dB)

h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);

Hd = design(h, 'kaiserwin');



% [EOF]