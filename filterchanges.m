rates=[2,4,5,8];
source=[2,8];
name='mkt2e';
C=textscan(name,'%s%s');

for n=1:size(source,2)
        namen=char(C{n});
    for r=1:size(rates,2)
        fname=sprintf('%s%d%s%d',namen,source(n),'to',rates(r));
        t=hadload(fname);
        if rates(r)==2
            lp=makeFilter(2000,999.9);
        else
            lp=makeFilter(rates(r)*1000,1000);
        end
        filter_length=size(lp.Numerator,2);
        temp=lp.filter(t.GlottalArea);
        glot=temp((round((filter_length-1)/2)+rates(r)*64)+(0:(rates(r)*1000-1)));
        newname=sprintf('%s%s%d%s%d',namen,'f',source(n),'to',rates(r));
        newMat=matfile(sprintf('%s%s',newname,'.mat'),'Writable',true);
        newMat.GlottalArea=glot;
        hadsave(newname,hadload(sprintf('%s%d%s%d',namen,source(n),'to',rates(r))));
    end
end