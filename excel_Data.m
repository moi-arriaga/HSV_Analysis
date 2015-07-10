% function excel_Data(parout)
parout=vidpar;
num_rates=9;%[10,10,10];
id=ones(1,27);
cutoffs=[1,2,4];
rates=[2,4,8];
fs_pow=1;
count=1;
out=cell(101,15);
depth=1;
out{depth,1}='Measurement ID';
out{depth,2}='Original Frame Rate';
out{depth,3}='LPF Cutoff';
out{depth,4}='Decim Factor';
out{depth,5}='Effective Rate';
out{depth,6}='F0 Mean';
out{depth,7}='F0 SD';
out{depth,8}='OQ Mean';
out{depth,9}='OQ SD';
out{depth,10}='SI Mean';
out{depth,11}='SI SD';
out{depth,12}='RGG Mean';
out{depth,13}='RGG SD';
out{depth,14}='HNR Mean';
out{depth,15}='HNR SD';
depth=depth+1;

 q=1;
for i=1:length(id)
    id(i)=i;
end
for n=1:length(id)
   
    if count>num_rates
        count=1;
        fs_pow=fs_pow+1;
    end
    if fs_pow<4
        fs=power(2,fs_pow);
        %uncut or sampled version
        name=sprintf('%s%d',id,fs);
        if q==10
            q=1;
        end
        out{depth,1}=q;
        out{depth,2}=fs*1000;
        out{depth,3}=fs*1000/2;
        out{depth,4}=1;
        out{depth,5}=fs*1000;
        out{depth,6}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.Fo);
        out{depth,7}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.Fo);
        out{depth,8}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.OQ);
        out{depth,9}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.OQ);
        out{depth,10}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.SI);
        out{depth,11}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.SI);
        out{depth,12}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.RGG);
        out{depth,13}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.RGG);
        out{depth,14}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.HNR);
        out{depth,15}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(fs_pow).par.HNR);
        depth=depth+1;
        %figure('name',sprintf('%s%s',name,' GAW')
        %cut but unsampled
        for c=1:length(cutoffs)
            if c < fs_pow
                name=sprintf('%s%d%s%d%s%d',id,fs,'cut',cutoffs(c));
                out{depth,1}=q;
                out{depth,2}=fs*1000;
                out{depth,3}=cutoffs(c)*1000;
                out{depth,4}=1;
                out{depth,5}=fs*1000;
                out{depth,6}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.Fo);
                out{depth,7}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.Fo);
                out{depth,8}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.OQ);
                out{depth,9}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.OQ);
                out{depth,10}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.SI);
                out{depth,11}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.SI);
                out{depth,12}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.RGG);
                out{depth,13}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.RGG);
                out{depth,14}=mean(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.HNR);
                out{depth,15}=std(parout(q).freqN(fs_pow).rateN(fs_pow).cutN(c).par.HNR);
                depth=depth+1;
                
            end
        end
        %cut and downsampled
        for c=1:length(cutoffs)
            for n=1:length(rates)
                if c <= n && n < fs_pow
                    name=sprintf('%s%d%s%d%s%d',id,fs,'to',rates(n),'cut',cutoffs(c));
                    out{depth,1}=q;
                    out{depth,2}=fs*1000;
                    out{depth,3}=cutoffs(c)*1000;
                    out{depth,4}=fs/rates(n);
                    out{depth,5}=rates(n)*1000;
                    out{depth,6}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.Fo);
                    out{depth,7}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.Fo);
                    out{depth,8}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.OQ);
                    out{depth,9}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.OQ);
                    out{depth,10}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.SI);
                    out{depth,11}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.SI);
                    out{depth,12}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.RGG);
                    out{depth,13}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.RGG);
                    out{depth,14}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.HNR);
                    out{depth,15}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.HNR);
                    depth=depth+1;
                end
            end
        end
        % upsampled
         for c=1:length(cutoffs)
            for n=1:length(rates)
                if n > fs_pow && c <= fs_pow
                    name=sprintf('%s%d%s%d%s%d',id,fs,'to',rates(n),'cut',cutoffs(c));
                    out{depth,1}=q;
                    out{depth,2}=fs*1000;
                    out{depth,3}=cutoffs(c)*1000;
                    out{depth,4}=fs/rates(n);
                    out{depth,5}=rates(n)*1000;
                    out{depth,6}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.Fo);
                    out{depth,7}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.Fo);
                    out{depth,8}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.OQ);
                    out{depth,9}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.OQ);
                    out{depth,10}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.SI);
                    out{depth,11}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.SI);
                    out{depth,12}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.RGG);
                    out{depth,13}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.RGG);
                    out{depth,14}=mean(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.HNR);
                    out{depth,15}=std(parout(q).freqN(fs_pow).rateN(n).cutN(c).par.HNR);
                    depth=depth+1;

                end
            end
         end
        count=count+1;
        
    end
    q=q+1;
end
xlswrite('VideoMeasurements.xlsx',out);

% end