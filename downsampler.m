downsample2=ones(1,3500);
shift=128/2;
temp=data2.GlottalArea(8,shift+0:7063);

for n=1:3500
   downsample2(n)=temp(2*n);
end