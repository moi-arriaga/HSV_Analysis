n=20;
base_cutoff=1000;
step=(wave.FrameRate/2-base_cutoff)/n;

changingfilteraaef(n).out=mpar(1).rateN(1).out;
changingfilteraaef(n).par=Parameters(changingfilteraaef(n).out);

changingfilteraaef(n).par=Parameters(changingfilteraaef(n).out);
for i=1:n
    changingfilteraaef(i).out=ModelEstimation('filter8000aa',i);
    changingfilteraaef(i).par=Parameters(changingfilteraaef(i).out);
end
