function filtervid(filename, fs, n0)
% filename='mk10,8000.avi';
% fs=8000;
% n0=0;


id=filename(1:end-8);

if fs==8000
    rates=[2000,1000];
elseif fs==4000
    rates=[1000];
elseif fs==2000;
    rates=[];
else
    error('Only set up to filter 8000 and 4000fps , and to trim 2000 fps videos.');
end
VRO=VideoReader(filename);

for i=1:(length(rates)+1)
    N=fs;
    SZ = size(VRO.read([1 inf]));
    M = SZ(1)*SZ(2);
    
    if i<=length(rates)
        fil=filterBeforeDecim(fs,rates(i));
        filter_length=length(fil.Numerator);
        pad=round((filter_length-1)/2);
        name=sprintf('%s%d%s%d%s',id,fs/1000,'cut',rates(i)/1000,'.avi')
        ratio=rates(i)/fs;
    else
        pad=0;
        name=sprintf('%s%d%s%d%s',id,fs/1000,'.avi');
        ratio=1;
    end
    Nplus=pad+N;
    %reads Nplus frames centered on n0
    if n0==0;
        range=[1 Nplus];
    else
        range=(n0-N/2)+[1 Nplus];
    end
    nof=VRO.NumberOfFrames;
    if range(end)>nof
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
    
    if i<= length(rates)
        %filters along columns (F)
        Y=filter(fil.Numerator,1,double(X));
    else
        Y=X;
    end
    % produce output AVI
    vidObj = VideoWriter(name,'Uncompressed AVI');
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
    z=reshape(Y(:,start:finish),[SZ(1),SZ(2),1,N]);
    % Write each frame to the file.
    
    writeVideo(vidObj,uint8(round(z)));
    
    % Close the file.
    close(vidObj);
    
end
end