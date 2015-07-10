function frameShift(vidName, varargin)
if nargin == 1
    rates=[2000,4000,5000,8000];
else rates=varargin{1};
end
if nargin >2
    n0=varargin{2};
end
C=textscan(vidName,'%s%d');
VRO=VideoReader(sprintf('%s%d',C{1},C{2}));
for i=1:numel(rates)
    [p,q]=numden(rates(i)/C{2});
    if nargin==1
    changeFrames(p,q,C{2},VRO,sprintf('%s%d%s%s',C{1},(C{2}/1000),'to',(rates(i)/1000)));
    else changeFrames(p,q,C{2},VRO,sprintf('%s%d%s%s',C{1},(C{2}/1000),'to',(rates(i)/1000)),n0);
    end
end
end