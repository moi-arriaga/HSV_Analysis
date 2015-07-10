
infile='mk2000wide.avi';
video=VideoReader('mk20000bw.avi');
width=video.Width;
%returns HxWxBxF, we only want greyscale not rgb though
% varray=ones(video.Height,video.Width,video.NumberOfFrames);
% varrayrgb=ones(video.Height,video.Width,3,video.NumberOfFrames);
%converts to grayscale

% for n=1:50%(video.NumberOfFrames-1)
%     varrayrgb(:,:,:,n)=video.read(n);
% end
%  varray(:,:,:)=varrayrgb(:,:,1,:);
% mins=min(varray,[],1);
% 
% meanofmins=mean(squeeze(mins),2);
% [pks,locs]=findpeaks(meanofmins,'MINPEAKDISTANCE',30);
% [~,ind]=max(pks);
% xtemp=locs(ind);
% pks(ind)=0; locs(ind)=0;
% [~,ind]=max(pks);
% x2temp=locs(ind);
% if xtemp<x2temp
%     x1=xtemp;
%     x2=x2temp;
% else
%     x2=xtemp;
%     x1=x2temp;
% end

for w=0:round(video.NumberofFrames/1000)
    n=1; clear varray; clear varrayrgb;clear meanofmins;
    while n<1001 && w*1000+n<video.NumberofFrames
        varrayrgb(:,:,:,(w*1000+n))=video.read((w*1000+n));
        n=n+1;
    end
     %HxWxF
     varray(:,:,:)=varrayrgb(:,:,1,:);
    %1xWxF
    mins=min(varray,[],1);
    %Wx1
    meanofmins(:,w)=mean(squeeze(mins),2);
end
    meanofmins=reshape(meanofmins,numel(meanofmins),1);
    [pks,locs]=findpeaks(meanofmins,'MINPEAKDISTANCE',30);
    [~,ind]=max(pks);
    xtemp(w)=locs(ind);
    ytemp(w)=pks(ind);
    pks(ind)=0; locs(ind)=0;
    [~,ind]=max(pks);
    x2temp(w)=locs(ind);
    y2temp(w)=pks(ind);




%function run_virtualdub(infile,outfile,offset,fs)
% set VCF file name (in temp dir)
vcfname = [tempname '.vcf'];
vdname = 'Veedub64';
outfile='vdubcropped.avi';
% create VCF file
fid = fopen(vcfname,'wt');
fprintf(fid,'VirtualDub.Open("%s",0,0);\n', strrep(infile,'\','\\\\'));
fprintf(fid,'VirtualDub.video.filters.Add("null transform");\n');
fprintf(fid,'VirtualDub.video.filters.instance[0].SetClipping(%d,%d,%d,%d);\n',xL,0,width-xR,0);

% fprintf(fid,'VirtualDub.SaveAVI("%s");\n',strrep(outfile,'\','\\\\'));
fprintf(fid,'VirtualDub.SaveAVI("%s");\n',strrep(outfile,'\','\\\\'));

fclose(fid);
%system(command line)
% run virtual dub
eval(['!' vdname ' /min /s ' vcfname '/x']);

% delete vcf file
delete(vcfname);

% end
