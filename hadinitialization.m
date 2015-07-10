function had=hadinitialization(n,fs,t)
    S=hadcreate(n,fs);
    hadname=n(1:end-4);
    S=SegmInit(S,true);
    if nargin==3
       S.SegmCfg.KeyFrames.Thresholds=t; 
    end
    S(:)=SegmRunPass1(S);
    S(:)=SegmRunPass2(S);
    hadsave(hadname,S);
    had=S;
end