clear; close all;

infile = 'test2_2000fps_src.avi';

P = 4; % upsampling rate

VRO = VideoReader(infile);
fs = VRO.FrameRate;
X = VRO.read();
SZ = size(X);
N = SZ(4);
M = SZ(1)*SZ(2);
X = reshape(X(:,:,1,:),[M N]);

% interpolate by P
Y = zeros([M P*N],'uint8');
for m = 1:M
   Y(m,:) = resample(double(X(m,:)),P,1);
end

% produce output AVI
% vidObj = VideoWriter(sprintf('test2_%dfps',P*2000),'Archival');
% vidObj.MJ2BitDepth = 8;
vidObj = VideoWriter(sprintf('test2_%dfps',P*2000),'Uncompressed AVI');
vidObj.FrameRate = fs;
open(vidObj);

for n = 1:N
   % Write each frame to the file.
   writeVideo(vidObj,repmat(reshape(Y(:,n),[SZ(1) SZ(2)]),[1 1 3]));
end

% Close the file.
close(vidObj);
