function filtervidup(filename, fs, n0)
% filename='mk10,8000.avi';
% fs=8000;
% n0=0;

%taking in an upsampled video, filtering it so it has the correct values
id=filename(1:end-8);

if fs==4000
    cutoffs=[2000];
    rates=[8000];
elseif fs==2000
    rates=[4000,8000];
    cutoffs=[1000];
elseif fs==8000;
return;
else
    error('Wrong Frame Rate');
end
tvids=cell(2);
for q=1:length(rates)
tvids{q}=sprintf('tvid%s%d%d.avi',id,fs/1000,rates(q)/1000);
end
for i=1:(length(rates))
    
infile=sprintf('%s%d%s%d%s',id,fs/1000,'to',rates(i)/1000,'.avi')
VRO=VideoReader(infile);
    N=rates(i);
    SZ = size(VRO.read([1 inf]));
    M = SZ(1)*SZ(2);
    for c=1:length(cutoffs)
        fil=filterBeforeDecim(rates(i),cutoffs(c));
        filter_length=length(fil.Numerator);
        pad=round((filter_length-1)/2);
        name=sprintf('%s%d%s%d%s%d%s',id,fs/1000,'to',rates(i)/1000,'.avi')
        ratio=rates(i)/fs;
    end
    Nplus=pad+N;
    %reads Nplus frames centered on n0
    if n0==0;
        range=[1 Nplus];
    else
        range=(n0*ratio-Nplus/2)+[1 Nplus];
    end
    nof=VRO.NumberOfFrames;
    if range(end)>nof
        nof
        range
      error('range is greater than video frame count');
    else
        X = VRO.read(range);
    end
    %creates matrix numbers of pixels long by number of frames(Nplus) high
    %[(W*H)xF]
    X = reshape(X(:,:,1,:),[M Nplus]);
    %[Fx(W*H)]
    X=transpose(X);
    %     Y=transpose(Y);
    %     Z=transpose(Z);
    
      %filters along columns (F)
        Y=filter(fil.Numerator,1,double(X));
    % produce output AVI
%     vidObj=VideoWriter(infile,'Uncompressed AVI');
%         vidObj=VideoWriter('tvid.avi','Uncompressed AVI');
vidObj=VideoWriter(char(tvids{i}),'Uncompressed AVI');
    %vidObj = VideoWriter(sprintf('res',fs,'to',fs*P/Q),'Uncompressed AVI');
%     vidObj.FrameRate = VRO.FrameRate*ratio;
    open(vidObj);
    %set points to trim off padding
    start=(pad+1);
    finish=start+N-1;
    size(Y);
    %reshapes output to eliminate the padding
    %z=reshape(Y(:,start:finish),[SZ(1),SZ(2),1,N*r]);
    Y=transpose(Y);
    tz=reshape(Y(:,(start):(finish)),[SZ(1),SZ(2),1,N]);
    % Write each frame to the file.
    z=ratio*tz;
    writeVideo(vidObj,uint8(round(z)));
    
    % Close the file.
    close(vidObj);
    
end
end