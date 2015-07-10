newname='filter8000aa';
matf=matfile(sprintf('%s%s',newname,'.mat'),'Writable',true);
wavename='aa8to8';
wave=hadload(wavename);
matf.GlottalArea=ones(20,8000);
fs=8;
n=20;
base_cutoff=1000;
step=(wave.FrameRate/2-base_cutoff)/n;

for r=0:(n-1)
    cutoff=base_cutoff+r*step;
   lp=makeFilter(fs*1000,cutoff);
   filter_length=length(lp.Numerator);
   temp=lp.filter(wave.GlottalArea);
   glot=temp((round((filter_length-1)/2)+fs*64)+(0:(fs*1000-1)));
   matf.GlottalArea((r+1),:)=glot;
   hadsave(newname,wave);
end
matf.GlottalArea(n+1,:)=wave.GlottalArea((fs*64)+(0:(fs*1000-1)));