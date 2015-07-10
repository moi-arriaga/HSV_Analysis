function [outcome]=ModelEstimation(file,varargin)


%file='2000ex.had';

S = hadload(file);
if nargin>1
    if varargin{1}=='f'
        matf=matfile(sprintf('%s%s',file,'.mat'),'Writable',true);
        f=matf.GlottalArea;
    else
        matf=matfile(sprintf('%s%s',file,'.mat'),'Writable',true);
        f=matf.GlottalArea(varargin{1},:);
    end
else
    f=S.GlottalArea;
end

Fs=S.FrameRate;
Tana=80/2000;
Toffset=10/2000;
Nana=round(Tana*Fs);
Noffset=round(Toffset*Fs);

F0 = analyze_nominalf1fft(f,Fs);
Lmax = floor(Fs*3/4/F0);


%returns fundamental frequency, amplitudes, phases, and signal and
%noise values
outcome = analyze_psmodel(f,Fs,F0,Lmax,Nana,Noffset);
end