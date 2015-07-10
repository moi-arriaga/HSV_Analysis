
%format is id#,fs
for i=0:35
    str(1+i*2:2+i*2)='%s';
end

% if nargin>0
%     C=textscan(infiles,str,'MultipleDelimsAsOne',1);
% else
    infiles='processvideos.txt';
    fid=fopen(infiles);
    C=textscan(fid,str,'MultipleDelimsAsOne',1);
    fclose(fid);
    n=1;
    c=1;
while (length(char(C{n}))~=0)
    if ~isempty(C{n})
        if c>9
            c=1;
        end
        filename
        filename=char(C{n}(1));
%         sprintf('%s%s', 'now working on ', filename)
%         ns(n)
        fs=str2double(filename((end-7):(end-4)));
        prepare_video(filename,sprintf('mk%d_',c),fs);
        n=n+1;
        c=c+1;
    end
end
