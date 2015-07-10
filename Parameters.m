function [params]=Parameters(outcomes)
%clear; close all; drawnow;


outcomes=squeeze(struct2cell(outcomes));

Fo=cell2mat(outcomes(1,:));
HNR=10*log10(cell2mat(outcomes(4,:))./cell2mat(outcomes(5,:)));

%OQ is ratio of open phase duration and period To/T
T=1./Fo;
omega0=2*pi*Fo;
ain=outcomes(2,:);
phiin=outcomes(3,:);
OQ=ones(1,size(ain,1));
SI=ones(1,size(ain,1));

for k=1:size(outcomes,2) %1->number of values in outcome
    
    a=ain{k}(:);
    phi=phiin{k};
    p=0:numel(a)-1;
    %find extremas
    [t_ext,A_ext]=findlocalextrema(T(k),omega0(k),p,phi,a);
    %number of extrema
    N_ext=numel(t_ext);
    
        %set global peak to t=0;
        phi(:)=phi+omega0(k)*p*t_ext(1);
        t_ext=[t_ext-t_ext(1);T(k)];
        A_ext=A_ext([1:end 1]);
    
%         Amax = A_ext(1); tmax = t_ext(1);
%         [Amin,I] = min(A_ext); tmin = t_ext(I);
%     
%         %first crossing after max
%         I = find(A_ext(1:end-1)>a(1) & A_ext(2:end)<a(1),1,'first');
%         t3 = findcrossing(a(1),mean(t_ext([I I+1])),omega0(k),p,phi,a);
%     
%         % lo->hi: last crossing before the max
%         I = find(A_ext(1:end-1)<a(1) & A_ext(2:end)>a(1),1,'last');
%         t2 = findcrossing(a(1),mean(t_ext([I I+1])),omega0(k),p,phi,a) - T(k);
%     
    Amin = 0;
    Amin_new = min(A_ext(2:end));
    Amax_new = A_ext(1);
    %     find min and max
    while Amin_new~=Amin
        Amin = Amin_new;
        Amax = Amax_new;
        a10pct = Amax*0.1 + Amin*0.9; % 10% weighted average
        a90pct = Amax*0.9 + Amin*0.1; % 90% weighted average
        %         a10pct=Amin;
        %         a90pct=Amax;
        I1 = find(A_ext(1:end-1)>a10pct & A_ext(2:end)<a10pct,1,'first');
        %         I1=find(A_ext(:)==Amin);
        I2 = find(A_ext(1:end-1)<a10pct & A_ext(2:end)>a10pct,1,'last');
        %         I2=find(A_ext(:)==Amin);
        Amin_new = mean(A_ext(I1+1:I2));
        
        I3 = find(A_ext(1:end-1)<a90pct & A_ext(2:end)>a90pct,1,'last');
        % I3=find(A_ext(:)==Amax,1,'last');
        I4 = find(A_ext(1:end-1)>a90pct & A_ext(2:end)<a90pct,1,'first');
        % I4=find(A_ext(:)==Amax,1,'first');
        Amax_new = mean(A_ext([I3+1:end-1 1:I4]));
    end
    a5pct = A_ext(1)*0.07 + Amin*0.93; % weighted average
%     a5pct = Amax_new*0.07 + Amin*0.93; % weighted average
    %     a1pct=A_ext(1);
    I1 = find(A_ext(1:end-1)>a5pct & A_ext(2:end)<a5pct,1,'first');
    %             I1=find(A_ext(:)==Amin,1,'first');
    
    I2 = find(A_ext(1:end-1)<a5pct & A_ext(2:end)>a5pct,1,'last');
    %             I2=find(A_ext(:)==Amin,1,'last');
    
    
    % Determine the peak time (weighted average of >a90pct extrema
    Amax = A_ext([I3+1:end-1 1:I4]).';
    tmax = (Amax*[t_ext(I3+1:end-1)-T(k);t_ext(1:I4)])/sum(Amax);
    Amax = mean(Amax);
    
    %       [Amin Amax]
    
    % Determine the 1% crossing
    % hi->lo: first crossing after t2
    t2 = findcrossing(a5pct,mean(t_ext([I1 I1+1])),omega0(k),p,phi,a);
    % lo->hi: last crossing before the max
    t1 = findcrossing(a5pct,mean(t_ext([I2 I2+1])),omega0(k),p,phi,a) - T(k);
    to = t2(1,1)-t1(1,1);
    tco = tmax-t1(1,1);
    toc = t2(1,1)-tmax;
    OQ(k)=to/T(k);
    SI(k)=(tco-toc)/to;
    if Amin<0
        RGG(k)=0;
    else
        RGG(k)=Amin/Amax;
    end
    
end


%params=[Fo;OQ;SI;HNR];
params.Fo=Fo;
params.OQ=OQ;
params.SI=SI;
params.HNR=HNR;
params.RGG=RGG;
end