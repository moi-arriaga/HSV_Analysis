 function write_Data(parout)
num_rates=[9,9,9];
idN=ones(1,30);
cutoffs=[1,2];
rates=[2,4,8];
upcutoffs=[1,2];
uprates=[4,8];
% DOC=docopen('HundredVideos.doc');
% app=DOC.Parent;
fs_pow=1;
count=1;
for i=1:length(idN)
    idN(i)=i;
end
for q=1:length(idN)
    if count>num_rates(fs_pow)
        count=1;
        fs_pow=fs_pow+1;
    end
    if fs_pow<4
        fs=power(2,fs_pow);
        front=sprintf('mk%d_',count);
        %uncut or sampled version
        name=sprintf('%s%d',front,fs);
        rec_num=count;
        
        %figure('name',sprintf('%s%s',name,' GAW')
        
        % add a heading
        %         docusestyle(DOC,'Heading 1');
        %         docprintf(DOC,'%d fps Recording %d\n', fs,rec_num);
        %         %         docusestyle(DOC,'Heading 3');
        %         docprintf(DOC,'%s GAW\n', name);
        %
        % add a figure
        S=hadload(name);
        wave=S.GlottalArea;
        tdom=fs;
        x=(1:length(wave))/tdom;
        plot(x,wave);
        epswrite('temp');
        eps2raster('temp',sprintf('%s%s_gaw.png','intermediate\',name));
        close all;
        %         docaddfigure(DOC,gcf);
        %         docprintf(DOC,'%s Spectrogram\n', name);
        spectrogram(wave,hanning(128*fs),100*fs,128*fs,1000*fs,'yaxis');
        epswrite('temp');
        eps2raster('temp',sprintf('%s%s_gawsg.png','intermediate\',name));
        close all;
        %         docaddfigure(DOC,gcf);
        %cut but unsampled
        for c=1:length(cutoffs)
            if c < fs_pow
                name=sprintf('%s%d%s%d%s%d',front,fs,'cut',cutoffs(c));
                %docusestyle(DOC,'Heading 3');
                %                 docprintf(DOC,'%s GAW\n', name);
                % add a figure
                S=hadload(name);
                wave=S.GlottalArea;
                tdom=fs;
                x=(1:length(wave))/tdom;
                plot(x,wave);
                epswrite('temp');
                eps2raster('temp',sprintf('%s%s_gaw.png','intermediate\',name));
                close all;
                %                 docaddfigure(DOC,gcf);
                %                 docprintf(DOC,'%s Spectrogram\n', name);
                spectrogram(wave,hanning(128*fs),100*fs,128*fs,1000*fs,'yaxis');
                epswrite('temp');
                eps2raster('temp',sprintf('%s%s_gawsp.png','intermediate\',name));
                close all;
                %                 docaddfigure(DOC,gcf);
            end
        end
        %cut and downsampled
        for c=1:length(cutoffs)
            for n=1:length(rates)
                if c <= n && n < fs_pow
                    name=sprintf('%s%d%s%d%s%d',front,fs,'to',rates(n),'cut',cutoffs(c));
                    %docusestyle(DOC,'Heading 3');
                    %                     docprintf(DOC,'%s GAW\n', name);
                    % add a figure
                    S=hadload(name);
                    wave=S.GlottalArea;
                    tdom=power(2,n)*1000;
                    x=(1:length(wave))/tdom;
                    plot(x,wave);
                    epswrite('temp');
                    eps2raster('temp',sprintf('%s%s_gaw.png','intermediate\',name));
                    close all;
                    %                     docaddfigure(DOC,gcf);
                    %                     docprintf(DOC,'%s Spectrogram\n', name);
                    spectrogram(wave,hanning(128*power(2,n)),100*power(2,n),128*power(2,n),1000*power(2,n),'yaxis');
                    epswrite('temp');
                    eps2raster('temp',sprintf('%s%s_gawsg.png','intermediate\',name));
                    close all;
                    %                     docaddfigure(DOC,gcf);
                end
            end
        end
        if fs_pow<3
        %upsampled
            for n=1:length(rates)
                if n > fs_pow
                    name=sprintf('%s%d%s%d%s%d',front,fs,'to',rates(n))
                    %docusestyle(DOC,'Heading 3');
                    %                     docprintf(DOC,'%s GAW\n', name);
                    % add a figure
                    S=hadload(name);
                    wave=S.GlottalArea;
                    tdom=power(2,n)*1000;
                    x=(1:length(wave))/tdom;
                    plot(x,wave);
                    epswrite('temp');
                    eps2raster('temp',sprintf('%s%s_gaw.png','intermediate\',name));
                    close all;
                    %                     docaddfigure(DOC,gcf);
                    %                     docprintf(DOC,'%s Spectrogram\n', name);
                    spectrogram(wave,hanning(128*power(2,n)),100*power(2,n),128*power(2,n),1000*power(2,n),'yaxis');
                    epswrite('temp');
                    eps2raster('temp',sprintf('%s%s_gawsg.png','intermediate\',name));
                    close all;
                    %                     docaddfigure(DOC,gcf);
                end
            end
       
        end
        %docusestyle(DOC,'Heading 3');
        %         docprintf(DOC,'Parameters\n');
        name=sprintf('%s%d',front,fs);
        Plot_Video_Parameters(parout,q,fs);
        epswrite('temp');
        eps2raster('temp',sprintf('%s%s_params.png','intermediate\',name));
        close all;
        %         docaddfigure(DOC,gcf);
         count=count+1;

    end
end

% close the word
% docclose(DOC)
end
