% clear; close all;
function extract_videos(infiles)
% infiles = ['aacropped2000.avi'];

% infiles = ['mk8000t2'];

rates=[2,4,8];
% idlen=9;
% titlelen=idlen+8;
T = 1;
pad=256;
n02=42501;
n08;
 for i=1:size(infiles,2)/titlelen
    title=infiles((i-1)*titlelen+(1:titlelen));
    VRO = VideoReader(title);
    fs = str2num(title(idlen+1:titlelen-4));
    id=title(1:idlen);
    N = fs*T;
    for n=1:size(rates,2)
        [p,q]=numden(sym(rates(n)/(fs/1000)));
        if i==1
            changeFrames(p,q,N,pad,VRO,sprintf('%s%d%s%d',id,fs/1000,'to',rates(n)),n02);
%             changeFramesExtraPadding(p,q,N,pad,VRO,sprintf('%s%s%d%s%d',id,'e',fs/1000,'to',rates(n)),n02);
        elseif i==2
            changeFrames(p,q,N,pad,VRO,sprintf('%s%d%s%d',id,fs/1000,'to',rates(n)),n08);
%             changeFramesExtraPadding(p,q,N,pad,VRO,sprintf('%s%s%d%s%d',id,'e',fs/1000,'to',rates(n)),n08);
        end
    end
 end
