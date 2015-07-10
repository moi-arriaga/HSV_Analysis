function generate_videos(infiles,ns)

C=textscan(infiles,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','delimiter',',');
while size(C{n},1)==1
    filename=char(C{n});
    len=length(filename);
    fs=str2num(filename((len-7):(len-4)));
    filtervid(filename,fs,ns(n));
    downsampler(filename
    n=n+1;
end
