function [outcome]=ModelEstimationVideo(file,Lmax)


%file='2000ex.had';

S = hadload(file);
f=S.GlottalArea;
Fs=S.FrameRate;
Tana=80/2000;
Toffset=10/2000;
Nana=round(Tana*Fs);
Noffset=round(Toffset*Fs);
if nargin<2
F0 = analyze_nominalf1fft(f,Fs);
Lmax = floor(Fs*3/4/F0);
end

%returns fundamental frequency, amplitudes, phases, and signal and
%noise values
outcome = analyze_psmodel(f,Fs,F0,Lmax,Nana,Noffset);
end