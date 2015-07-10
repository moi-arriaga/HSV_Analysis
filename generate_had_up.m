function generate_had_up(infiles)
for i=0:35
    str(1+i*2:2+i*2)='%s';
end

if nargin>0
    C=textscan(infiles,str,'MultipleDelimsAsOne',1);
else
    fid=fopen('videos.txt');
    C=textscan(fid,str,'MultipleDelimsAsOne',1);
    fclose(fid);
end

n=1;
while (size(C{1},1)-size(C{n},1))==0
    filename=char(C{n}(1));
    fs=str2double(filename((end-7):(end-4)));
    id=filename(1:end-8);
    if fs==2000
        rates=[4000,8000];
    elseif fs==4000
        rates=8000;
    end
    
    %         cutoffs=[1000,2000];
    %             cutoffs=[1000];
    %         name=sprintf('%s%d%s',id,fs/1000,'.avi')
    %         S=hadinitialization(name,fs);
    %         t=S.SegmCfg.KeyFrames.Thresholds;
    %         %     for c=1:length(cutoffs)
    %         if cutoffs(c)*2<fs
    %             name=sprintf('%s%d%s%d%s',id,fs/1000,'cut',cutoffs(c)/1000,'.avi')
    %             hadinitialization(name,fs,t);
    %         end
    %     end
    length(rates)
    for r=1:length(rates)
        if fs<rates(r)
            %             for c=1:length(cutoffs)
            name=sprintf('%s%d%s%d%s%d%s',id,fs/1000,'to',rates(r)/1000,'.avi')
            hadinitialization(name,rates(r));
        end
    end
    
    n=n+1;
end
end