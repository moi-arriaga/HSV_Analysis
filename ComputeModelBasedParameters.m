clear; close all; drawnow;

datadir = '..\data\';
summaryxls = '..\DataSummary.xlsx';
modelxls = '..\Individual_ModelBased_Parameters.xlsx';

% Retrieve study data
[~,~,raw] = xlsread(summaryxls);
info = {'ID','Condition','VHI'};
[~,I] = ismember(info,raw(1,:));
info{2} = 'Pre/Post'; % rename
sid = raw(2:end,I(1));
cond = raw(2:end,I(2));
vhi = raw(2:end,I(3));
Nfiles = size(raw,1)-1;

% generalize condition to "Pre" and "Post"
cond(strcmp('pre',cond),2) = {'Pre'};
cond(strcmp('1mo',cond),2) = {'Post'};
cond(strcmp('3mos',cond),2) = {'Post'};

% parameter names
aux = {'Number of Cycles',...
   'Mean Number of Harmonics',...
   'SD Number of Harmnics'};

params= {'F0','HNR','H1','H2',...
   'OQ','SQ','SI','RQ',...
   'BO','PDI','PSPI','PSPI2','MOR','MCR','NMOR','NMCR'};

M = numel(params);
data = cell(Nfiles,M,2);
auxdata = cell(Nfiles,numel(aux));

delta = 0.01; % skip windows with F0 such that Fs/F0 is close to an integer

% Create MAT file for each HAD data
for n = 1:Nfiles

   % get filename
   filename = sprintf('%s%s_%s.mat',datadir,sid{n},cond{n,1});

   S = load(filename);

   %    'Number of Cycles',...
   auxdata{n,1} = S.Ncycles;
   %    'Mean Number of Harmonics',...
   auxdata{n,2} = mean(cellfun(@numel,{S.outcome.a}))-1;
   auxdata{n,3} = std(cellfun(@numel,{S.outcome.a}))-1;

   % Create mask
   N0 = S.Fs./S.params.F0;
   N0range = ceil(min(N0)):floor(max(N0));
   mask = true(numel(S.params.F0),1);
   for m = 1:numel(N0range)
      mask(:) = mask & ( N0<(N0range(m)-delta) | N0>(N0range(m)+delta));
   end
   save(filename,'mask','-append');
   
   for m = 1:M
      data{n,m,1} = mean(S.params.(params{m})(mask));
      data{n,m,2} = std(S.params.(params{m})(mask));
   end
end

% 'HNR (dB)',...
I = find(strcmp(params,'HNR'),1);
data(:,I,2) = cellfun(@(x,y)10*log10((x+y)/x),data(:,I,1),data(:,I,2),'UniformOutput',false);
data(:,I,1) = cellfun(@(x)10*log10(x),data(:,I,1),'UniformOutput',false);

% keep 3 significant digits
auxdata = cellfun(@(x)round(x*1000)/1000,auxdata,'UniformOutput',false);
data = cellfun(@(x)round(x*1000)/1000,data,'UniformOutput',false);

delete(modelxls);
params = [strrep(strcat('Mean_',params),'_',' ') strrep(strcat('SD_',params),'_',' ')];
xlswrite(modelxls,[[info;[sid cond(:,2) vhi]] [aux params;auxdata reshape(data,Nfiles,2*M)]]);
