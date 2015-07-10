function extract_video(avifile,rngs,varargin)
%EXTRACT_VIDEO   Extract video segments to new video files
%   EXTRACT_VIDEO('avifile', [start end], 'outfile') extract 
%   EXTRACT_VIDEO('avifile', [start end], fs, 'outfile')

error(nargchk(2,4,nargin));

N = size(rngs,1); % number of extracted video segments to create

if nargin<3
   fs = [];
   outfiles = pwd; % output to the current directory
elseif nargin<4
   if ischar(varargin{1})
      outfiles = varargin{1};
      fs = [];
   else
      fs = varargin{1};
      outfiles = pwd;
   end
else
   fs = varargin{1};
   outfiles = varargin{2};
end


if ischar(outfiles)
   outfiles = cellstr(outfiles);
end
if numel(outfiles)==1 && (N~=1 || isdir(outfiles{1})) % directory given
   [tmp1,name] = fileparts(avifile);
   outfiles = strcat(outfiles,filesep,name,'_',num2str((1:N)'),'.avi');
elseif numel(outfiles)~=N
   error('OUTFILES must be of the same size as the RANGES.');
end

offset = comp_offset(avifile,rngs);
if isempty(offset)
   error('Failed to read AVI file.');
end

try
   for seg = 1:N
      run_virtualdub(avifile,outfiles{seg},offset(seg,:),fs);
   end
catch ME
   ME.throwAsCaller();
end

end

function offset = comp_offset(avifile,rngs)
% rngs: 0-based frame indices.
%
% offset: The start offset is measured in milliseconds from the beginning, and the
% end offset is in milliseconds from the end.

if isempty(rngs)
   offset = [0 0];
else
   try
      v = ver('MATLAB');
      if datenum(v.Date)>=datenum('03-Aug-2010')
         obj = VideoReader(avifile);
      else
         obj = mmreader(avifile);
      end
   catch %#ok
      offset = [];
      return;
   end
   
   offset = [rngs(:,1) (obj.NumberOfFrames-1-rngs(:,2))]/obj.FrameRate*1000;
end
end

function run_virtualdub(infile,outfile,offset,fs)

% set VCF file name (in temp dir)
vcfname = [tempname '.vcf'];

% ID 32/64-bit MATLAB
if strcmp(computer,'PCWIN64')
   vdname = 'Veedub64';
else
   vdname = 'VirtualDub';
end

% create VCF file
fid = fopen(vcfname,'wt');
fprintf(fid,'VirtualDub.Open("%s",0,0);\n', strrep(infile,'\','\\\\'));
fprintf(fid,'VirtualDub.video.SetRange(%g,%g);\n',offset(1),offset(2));
fprintf(fid,'VirtualDub.video.SetOutputFormat(0);\n');

if ~isempty(fs)
   [N,D] = rat(fs,1e-3);
   fprintf(fid,'VirtualDub.video.SetFrameRate2(%d,%d,1);\n',N,D);
end

fprintf(fid,'VirtualDub.SaveAVI("%s");\n',strrep(outfile,'\','\\\\'));
fclose(fid);
%system(command line)
% run virtual dub
eval(['!' vdname ' /min /s ' vcfname '/x']);

% delete vcf file
delete(vcfname);

end

