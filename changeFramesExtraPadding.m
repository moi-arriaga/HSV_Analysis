function changeFramesExtraPadding(p,q,N,pad,VRO,name,varargin)
%  VRO=VideoReader('mk20000bwcropped.avi');
%  p = 1;
%  q = 1;
%  N = 2000;
%  pad=256;
% name='new2to2f.avi';
%  n0 = 4000;
%  Nplus=N+pad;
% % 
%  n0 = round((VRO.NumberOfFrames-Nplus)/2);
pad2=N/1000*128;
Nplus=N+pad+pad2;

switch nargin
    case 6
        n0 = round((VRO.NumberOfFrames)/2);
    case 7
        n0=varargin{1};
    otherwise
        s='try again'
end
%pad=128;
SZ = size(VRO.read());
M = SZ(1)*SZ(2);

% reads Nplus frames centered on n0
X = VRO.read((n0-(Nplus/2))+[1 Nplus]);
% creates matrix numbers of pixels long by number of frames(Nplus) high
X = reshape(X(:,:,1,:),[M Nplus]);


% interpolate by P and decimate by Q
P=double(p);
Q=double(q);
r=P/Q;
Y = zeros([M round(Nplus*r)],'uint8');
Z = zeros([M round(Nplus*r)],'uint8');
X=transpose(X);
Y=transpose(Y);
Z=transpose(Z);

% if(r<1)
%     for m = 1:M
%         Y(m,:) = resample(double(X(m,:)),P,Q);
%     end
% else
%     for m = 1:M
% %         dum = resample(double(X(m,:)),2,1);
% %         Y(m,:) = resample(dum,P/2,Q);
%           Y(m,:) = interp(double(X(m,:)),P);
% 
%     end

if P~=1 && Q ~=1 || (N~=2000 && Q==1 && P==1)
    fil=samplfilter(P,Q,N*P);
    Y=fil.filter(double(X));
else
    if P~=1
        upfilter=interfilter(P,N*P);
        Z = upfilter.filter(double(X));
    else Z=X;
    end
    if Q~=1
        downfilter=decimfilter(Q,N*P);
        Y = downfilter.filter(double(Z));
    else
        Y=Z;
    end
end
if P==1 && Q==1 && N==2000
    fil=samplfilterclose(P,Q,N*P);
    Y=fil.filter(double(X));
end

% produce output AVI
vidObj = VideoWriter(name,'Uncompressed AVI');
% vidObj = VideoWriter(sprintf('res',fs,'to',fs*P/Q),'Uncompressed AVI');
vidObj.FrameRate = VRO.FrameRate*r;
open(vidObj);
% set points to trim off padding
start=round(pad*r/2);
finish=start+r*(N+pad2)-1;
% reshapes output to eliminate the padding
%z=reshape(Y(:,start:finish),[SZ(1),SZ(2),1,(N+pad2)*r]);
Y=transpose(Y);
z=reshape(Y(:,start:finish),[SZ(1),SZ(2),1,(N+pad2)*r]);
% Write each frame to the file.

writeVideo(vidObj,uint8(round(z)));

% Close the file.
close(vidObj);


%create had object
S=hadcreate(strcat(name,'.avi'),N*r);
%save had to filename.had
k = strfind(name, '.avi');
hadsave(sprintf('%s%s',name(1:k-1),'.had'),S);


end