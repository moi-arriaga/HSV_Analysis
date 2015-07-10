function parout=Analyze_Videos
%infiles can either be a whitespace separated list of .avi files or
%reference to a text file with whitespace separated .avi files

% rates=[2,4,5,8];
% source=[2,8];
% C=textscan(name,'%s%s');

for i=0:35
    str(1+i*2:2+i*2)='%s';
end

% if nargin>0
%     C=textscan(infiles,str,'MultipleDelimsAsOne',1);
% else
    infiles='videos.txt';
    fid=fopen(infiles);
    C=textscan(fid,str,'MultipleDelimsAsOne',1);
% end
fs=[2,4,8];
cutoffs=[1,2];
upcuts=[1,2];
uprates=[4,8];
rates=[2,4];
q=1;
ind=1;
parout(length(C)).freqN(length(fs)).rateN((length(fs))).cutN((length(fs))).out=ModelEstimationVideo('mk9_8');
parout(length(C)).freqN((length(fs))).rateN((length(fs))).cutN((length(fs))).par=Parameters(parout(length(C)).freqN(length(fs)).rateN((length(fs))).cutN((length(fs))).out);
while (size(C{1},1)-size(C{q},1))==0
    if ~isempty(C{q})
        fullid=char(C{q}(1));
        id=fullid(1:end-8);
        foriginal=str2double(fullid(end-7:end-4));
        fsh=foriginal/1000;
        f=log2((fsh));
        %uncut or sampled version
        name=sprintf('%s%d',id,(fsh))
        if ind==10
            ind=1;
        end
        parout(ind).freqN(f).rateN(f).cutN(f).out=ModelEstimationVideo(name);
        parout(ind).freqN(f).rateN(f).cutN(f).par=Parameters(parout(ind).freqN(f).rateN(f).cutN(f).out);
        
        %cut but unsampled
        for c=1:length(cutoffs)
            if cutoffs(c)*2 < fsh
                name=sprintf('%s%d%s%d%s%d',id,fsh,'cut',cutoffs(c))
                parout(ind).freqN(f).rateN(f).cutN(c).out=ModelEstimationVideo(name);
                parout(ind).freqN(f).rateN(f).cutN(c).par=Parameters(parout(ind).freqN(f).rateN(f).cutN(c).out);
                
            end
        end
        %cut and downsampled
        for c=1:length(cutoffs)
            for n=1:length(rates)
                if cutoffs(c)*2 <= rates(n) && rates(n) < fsh
                    name=sprintf('%s%d%s%d%s%d',id,fs(f),'to',rates(n),'cut',cutoffs(c))
                    parout(ind).freqN(f).rateN(n).cutN(c).out=ModelEstimationVideo(name);
                    parout(ind).freqN(f).rateN(n).cutN(c).par=Parameters(parout(ind).freqN(f).rateN(n).cutN(c).out);
                end
            end
        end
        %upsampled
        
        for r=1:length(uprates)
            for c=1:length(upcuts)
                if (upcuts(c)*2)<=fs(f) && fs(f)<uprates(r) && uprates(r)>upcuts(c)
                    name=sprintf('%s%d%s%d%s%d',id,fs(f),'to',uprates(r))
                    parout(ind).freqN(f).rateN(r+1).cutN(c).out=ModelEstimationVideo(name);
                    parout(ind).freqN(f).rateN(r+1).cutN(c).par=Parameters(parout(ind).freqN(f).rateN(r+1).cutN(c).out);
                    
                end
            end
        end
    end
	%another random change, still testing git
	abcdefg=0;
    fprintid=fopen('VideoNumbers.txt');
    fprintf(fprintid,'%s%d\n',id,q);
    %     Plot_Video_Parameters(q,id,foriginal);
    fclose(fprintid);
    q=q+1;
    ind=ind+1;
end

end

