function t=check_threshholds(infiles)
for i=0:35
    str(1+i*2:2+i*2)='%s';
end

if nargin>0
    C=textscan(infiles,str,'MultipleDelimsAsOne',1);
else
    fid=fopen('videos.txt');
    C=textscan(fid,str);
    fclose(fid);
end
q=1;
while (size(C{1},1)-size(C{q},1))==0
    q=1+q;
end
n=1;
index=1;
thresh=ones(1,q);
while (size(C{1},1)-size(C{n},1))==0
    filename=char(C{n}(1));
    fs=str2double(filename((end-7):(end-4)));
    id=filename(1:end-8);
    rates=[2000,4000];
    cutoffs=[1000,2000];
    name=sprintf('%s%d',id,fs/1000);
    S=hadload(name);
    thresh(index)=S.SegmCfg.KeyFrames.Thresholds;
    index=index+1;
    for c=1:length(cutoffs)
        if cutoffs(c)*2<fs
            name=sprintf('%s%d%s%d',id,fs/1000,'cut',cutoffs(c)/1000);
            S=hadload(name);
            thresh(index)=S.SegmCfg.KeyFrames.Thresholds;
            index=index+1;
        end
    end
    for r=1:length(rates)
        for c=1:length(cutoffs)
            if (cutoffs(c)*2)<fs && fs>rates(r) && rates(r)>cutoffs(c)
                name=sprintf('%s%d%s%d%s%d',id,fs/1000,'to',rates(r)/1000,'cut',cutoffs(c)/1000);
                S=hadload(name);
                thresh(index)=S.SegmCfg.KeyFrames.Thresholds;
                index=index+1;
            end
        end
    end
    n=n+1;
end
t=thresh;
end