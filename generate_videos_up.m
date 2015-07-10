% function generate_videos_up(filestring, nlist)
%if null arguments opens videos.txt to read in names and n0 values from
%there

%if 1 argument, takes that as list of names (full video names in format from prepare_video) separated by spaces
%if 2 arguments first is list of names, second is array of n0 values
% nargin=0;
for i=0:35
    str(1+i*2:2+i*2)='%s';
end
% 
% if nargin>0
%     infiles=filestring;
%     C=textscan(infiles,str,'MultipleDelimsAsOne',1);
%     ns=zeros(length(C));
%     if nargin>1
%         ns=nlist;
%     end
% else
    fid=fopen('videos.txt');
    C=textscan(fid,str);
    fclose(fid);
    ns=zeros(length(C));
    q=1;
    while length(C{q})>1
        ns(q)=str2num(char(C{q}(2)));
        q=q+1;
    end
    
% end
n=1;
while (length(char(C{n}))~=0)
        filename=char(C{n}(1))
%         sprintf('%s%s', 'now working on ', filename)
%         ns(n)
        fs=str2double(filename((end-7):(end-4)))
        upsample_videos(filename,fs);
        filtervidup(filename,fs,ns(n));
        n=n+1;
    
end
