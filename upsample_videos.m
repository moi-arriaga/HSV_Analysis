function upsample_videos(filename, fs)
id=filename(1:end-8);
if fs==2000
    rates=[4000,8000];
elseif fs==4000
    rates=[8000];
elseif fs==8000
    return;
end
            %reads in the video files
            VRO=VideoReader(filename);

%             name=sprintf('%s%d%s',id,fs/1000,'.avi');
%             vidObj = VideoWriter(name,'Uncompressed AVI');
%             open(vidObj);
%             writeVideo(vidObj,VRO.read([1 inf]));
        
    for n=1:length(rates)
            ratio=rates(n)/fs;
            
            name=sprintf('%s%d%s%d%s',id,fs/1000,'to',rates(n)/1000,'.avi')
          
%             SZ = size(VRO.read([1 round(1.15*fs)]));
%            if strcmp(id,'mk6,') && fs==4000
               X = VRO.read([1 inf]);
%            else
%             X = VRO.read([1 round(1.1*fs)]);
%            end
            SZ=size(X);
             M = SZ(1)*SZ(2);
           
            N=size(X,4);
            %creates matrix numbers of pixels long by number of frames high
            %[(W*H)xF]
            X = reshape(X(:,:,1,:),[M N]);
            %FxW*H
            X=transpose(X);
            %needs to be ratio*size of x
            Y=zeros(size(X,1)*ratio,size(X,2));
            %adds the each frame of x into matrix of zeros
            for i=1:(size(X,1))
                Y((i-1)*ratio+1,:)=X(i,:);
            end
            Y=transpose(Y);
           
            % produce output AVI
            vidObj = VideoWriter(name,'Uncompressed AVI');
            %vidObj = VideoWriter(sprintf('res',fs,'to',fs*P/Q),'Uncompressed AVI');
            vidObj.FrameRate = VRO.FrameRate*ratio; 
            open(vidObj);
            z=reshape(Y(:,:),[SZ(1),SZ(2),1,round(N*ratio)]);
            writeVideo(vidObj,uint8(round(z)));
           
% Write each frame to the file.
            
            % Close the file.
            close(vidObj);
            
    end

end