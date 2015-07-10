function downsample_videos(filename, fs)
id=filename(1:end-8);
if fs==8000
    cutoffs=[1000,2000];
    rates=[2000,4000];
elseif fs==4000
    cutoffs=[1000];
    rates=[2000];
elseif fs==2000
    return;
end
for c=1:length(cutoffs)
    for n=1:length(rates)
        if cutoffs(c)*2 <= rates(n)
            ratio=fs/rates(n);
            infile=sprintf('%s%d%s%d%s',id,fs/1000,'cut',cutoffs(c)/1000,'.avi')
            
            VRO=VideoReader(infile);
            
            SZ = size(VRO.read([1 inf]));
            M = SZ(1)*SZ(2);
            X = VRO.read([1 inf]);
            N=VRO.NumberOfFrames;
            %creates matrix numbers of pixels long by number of frames high
            %[(W*H)xF]
            X = reshape(X(:,:,1,:),[M N]);
            %FxW*H
            X=transpose(X);
            Y=zeros(size(X,1)/ratio,size(X,2));
            for i=0:(size(X,1)/ratio-1)
                Y(i+1,:)=X(1+i*ratio,:);
            end
            Y=transpose(Y);
            
            name=sprintf('%s%d%s%d%s%d%s',id,fs/1000,'to',rates(n)/1000,'cut',cutoffs(c)/1000,'.avi')
            % produce output AVI
            vidObj = VideoWriter(name,'Uncompressed AVI');
            %vidObj = VideoWriter(sprintf('res',fs,'to',fs*P/Q),'Uncompressed AVI');
            vidObj.FrameRate = VRO.FrameRate/ratio;
            open(vidObj);
            z=reshape(Y(:,:),[SZ(1),SZ(2),1,round(N/ratio)]);
            % Write each frame to the file.
            
            writeVideo(vidObj,uint8(round(z)));
            
            % Close the file.
            close(vidObj);
            
        end
    end
end

end