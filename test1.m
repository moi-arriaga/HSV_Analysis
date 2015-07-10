avidir = 'Y:\HSV 9710 Raw Data\cosna 5 4 12\';
avifile = 'cosna5 4 12.avi';
fs = 8000;

S = hadcreate([avidir avifile],fs);

S.StartFrame = 0;
S.NumberOfFrames = 11400;
S.QVP((S.StartFrame+S.NumberOfFrames+1):end) = [];
