function prepare_video(infile,id,fs)
% infil=sprintf('%s%s' ,'Z:\HSV 9710 Raw Data\LSU\moi\',infile);
% infile='mk14000.avi';
% id='mk1_';
% fs=4000;
infile
video=VideoReader(infile);
width=video.Width;
height=video.Height;
varrayrgb=video.read([1 inf]);
varray=squeeze(varrayrgb(:,:,1,:));
% varray=varrayrgb;

if width>128
%finds smallest columnwise
mins=min(varray,[],1); %1xWxF
meanofmins=mean(squeeze(mins),2); %average minimum along width
% figure('name', 'width');
% plot(meanofmins)
[~,locs]=findpeaks(meanofmins,'MINPEAKDISTANCE',128,'SORTSTR','descend');
% [~,ind]=max(pks);
xtemp=locs(1);
% pks(ind)=0; locs(ind)=0;
% [~,ind]=max(pks);
x2temp=locs(2);
 if xtemp<x2temp
     x1=xtemp;
     x2=x2temp;
 else
     x2=xtemp;
     x1=x2temp;
     
 end
else
    x1=1;
    x2=width;
end
% x1=round(x1*.9);
% x2=round(x2*1.1);
 
if height>128
 %finds smallest rowwise
mins2=min(varray(:,x1:x2,:),[],2); %Hx1xF
meanofmins2=mean(squeeze(mins2),2); %average minimum along height
% figure('name', 'height');
% plot(meanofmins2)
 [~,locs]=findpeaks(meanofmins2,'MINPEAKDISTANCE',128,'SORTSTR','descend');
% [~,ind]=max(pks);
ytemp=locs(1);
% pks(ind)=0; locs(ind)=0;
% [~,ind]=max(pks);
y2temp=locs(2);
 if ytemp<y2temp
     y1=ytemp;
     y2=y2temp;
 else
     y2=ytemp;
     y1=y2temp;
 end
else
    y1=1;
    y2=height;
end
%  y1=round(y1*.9);
%  y2=round(y2*1.1);

%function run_virtualdub(infile,outfile,offset,fs)
% set VCF file name (in temp dir)
vcfname = [tempname '.vcf'];
vdname = 'Veedub64';
outfile=sprintf('%s%d%s',id,fs,'.avi');
% create VCF file
fid = fopen(vcfname,'wt');
fprintf(fid,'VirtualDub.Open("%s",0,0);\n', strrep(infile,'\','\\\\'));
fprintf(fid,'VirtualDub.video.filters.Add("null transform");\n');
fprintf(fid,'VirtualDub.video.filters.instance[0].SetClipping(%d,%d,%d,%d);\n',x1-1,y1-1,width-x2,height-y2);

% fprintf(fid,'VirtualDub.SaveAVI("%s");\n',strrep(outfile,'\','\\\\'));
fprintf(fid,'VirtualDub.SaveAVI("%s");\n',strrep(outfile,'\','\\\\'));

fclose(fid);
%system(command line)
% run virtual dub
eval(['!' vdname ' /min /s ' vcfname '/x']);

% delete vcf file
delete(vcfname);
% hadsave(sprintf('%s%d',id,fs),hadcreate(outfile,fs));

end
