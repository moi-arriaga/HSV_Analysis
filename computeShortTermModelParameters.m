% function params = computeModelParameters(f0,ain,phiin)
clear; close all; drawnow;

datadir = '..\data\';
matfiles = dir([datadir,'*.mat']);
filenames = {matfiles.name};

pnames = {'F0','HNR','H1','H2',...
   'OQ','SQ','SI','RQ',...
   'BO','PDI','PSPI','MOR','MCR','NMOR','NMCR'};

sfun = @(t,omega0,p,phi,a)cos(bsxfun(@plus,omega0*t*p,phi))*a;

for n = 1:numel(filenames)
   matfile = [datadir filenames{n}];
   load(matfile,'Nana','Noffset','Ncycles','outcome','f')
   outcome = squeeze(struct2cell(outcome));
   
   Ncycles = size(outcome,2); % number of observatgion windows
   
   params = cell2struct(repmat({zeros(Ncycles,1)},1,numel(pnames)),pnames,2);
   params.F0(:) = cell2mat(outcome(1,:));
   params.HNR(:) = cell2mat(outcome(4,:))./cell2mat(outcome(5,:));
   params.H1 = cellfun(@(x)x(2)/x(1),outcome(2,:));
   params.H2 = cellfun(@(x)x(3)/x(2),outcome(2,:));
   
   omega0 = 2*pi*params.F0;
   T = 1./params.F0;
   ain = outcome(2,:);
   phiin = outcome(3,:);
   L = cellfun(@numel,ain);
   
   for k=1:Ncycles
      a = ain{k}(:);
      phi = phiin{k};
      p = 0:numel(a)-1;
      
      % t = linspace(0,T(k),1001)';
      % plot(t,sfun(t,omega0(k),p,phi,a))
      
      % Find all the local peaks and troughs
      [text,Aext] = findlocalextrema(T(k),omega0(k),p,phi,a);
      Next = numel(text);
      
      % adjust waveform delay so that the global peak is at t = 0
      phi(:) = phi + omega0(k)*p*text(1);
      text = [text-text(1);T(k)];
      Aext = Aext([1:end 1]);
      
      % A0 crossings
      % hi->lo: first crossing after the max
      I = find(Aext(1:end-1)>a(1) & Aext(2:end)<a(1),1,'first');
      t3 = findcrossing(a(1),mean(text([I I+1])),omega0(k),p,phi,a);
      
      % lo->hi: last crossing before the max
      I = find(Aext(1:end-1)<a(1) & Aext(2:end)>a(1),1,'last');
      t2 = findcrossing(a(1),mean(text([I I+1])),omega0(k),p,phi,a) - T(k);
      
      % Determine the minimum value (average of "closed" extremes)
      Amin = 0;
      Amin_new = min(Aext(2:end));
      Amax_new = Aext(1);
      while Amin_new~=Amin
         Amin = Amin_new;
         Amax = Amax_new;
         a10pct = Amax*0.1 + Amin*0.9; % 10% weighted average
         a90pct = Amax*0.9 + Amin*0.1; % 90% weighted average
         I1 = find(Aext(1:end-1)>a10pct & Aext(2:end)<a10pct,1,'first');
         I2 = find(Aext(1:end-1)<a10pct & Aext(2:end)>a10pct,1,'last');
         Amin_new = mean(Aext(I1+1:I2));
         
         I3 = find(Aext(1:end-1)<a90pct & Aext(2:end)>a90pct,1,'last');
         I4 = find(Aext(1:end-1)>a90pct & Aext(2:end)<a90pct,1,'first');
         Amax_new = mean(Aext([I3+1:end-1 1:I4]));
      end
      a1pct = Aext(1)*0.01 + Amin*0.99; % weighted average
      I1 = find(Aext(1:end-1)>a1pct & Aext(2:end)<a1pct,1,'first');
      I2 = find(Aext(1:end-1)<a1pct & Aext(2:end)>a1pct,1,'last');
      
      % Determine the peak time (weighted average of >a90pct extrema
      Amax = Aext([I3+1:end-1 1:I4]).';
      tmax = (Amax*[text(I3+1:end-1)-T(k);text(1:I4)])/sum(Amax);
      Amax = mean(Amax);
      
      % Determine the 1% crossing
      % hi->lo: first crossing after t2
      t4 = findcrossing(a1pct,mean(text([I1 I1+1])),omega0(k),p,phi,a);
      % lo->hi: last crossing before the max
      t1 = findcrossing(a1pct,mean(text([I2 I2+1])),omega0(k),p,phi,a) - T(k);
      
%             figure;
%                t = linspace(-0.75*T(k),1.1*T(k),1001)';
%                plot(t,sfun(t,omega0(k),p,phi,a))
%                %plot(t,sfun(t,omega0(k),p,phi,a),t,dsfun(t,omega0(k),p,phi,a)/omega0(k))
%                yrng = ylim;
%                xrng = t([1 end]);
%                xlim(xrng);
%                hold on; plot(tmax*[1 1],yrng,'--k',xrng,Aext(1)*[1 1],'--k',... % peak
%                   xrng,a(1)*[1 1],'--r',t2*[1 1],yrng,'--r',t3*[1 1],yrng,'--r',...% a0 crossing
%                   xrng,a1pct*[1 1],'--m',t1*[1 1],yrng,'--m',t4*[1 1],yrng,'--m')
%                hold off
      
      % compute extrema of derivatives
      [tdext,Adext] = findlocalderivextrema(T(k),omega0(k),p,phi,a);
      
      to = t4-t1;
      tco = tmax-t1;
      toc = t4-tmax;
      App = Amax-Amin;
      
      params.OQ(k) = to/T(k);
      params.SQ(k) = tco/toc;
      params.SI(k) = (tco-toc)/to;
      params.RQ(k) = (tco+T(k)-t4)/toc;
      if Amin<0
         params.BO(k) = 0;
      else
         params.BO(k) = Amin/Amax;
      end
      params.PDI(k) = (t3-t2)/T(k);
      [params.MOR(k),Idmax] = max(Adext);
      [params.MCR(k),Idmin] = max(-Adext);
      params.NMOR(k) = params.MOR(k)*T(k)/App;
      params.NMCR(k) = params.MCR(k)*T(k)/App;
      params.PSPI(k) = App^2*(1/params.MOR(k)+1/params.MCR(k))/(2*(a(1)-Amin)*T(k));
      
      tdmax = mod(tdext(Idmax)-t1,T(k))+t1;
      tdmin = mod(tdext(Idmin)-t1,T(k))+t1;
      Ad = sfun([tdmax;tdmin],omega0(k),p,phi,a);
      
      t5 = (Amin-Ad(1))/params.MOR(k)+tdmax;
      t6 =(Ad(2)-Amin)/params.MCR(k)+tdmin;
      toalt = t6-t5;
      params.PSPI2(k) = App/(1/params.MOR(k)+1/params.MCR(k))/toalt;
   end
   
   %    figure
   %    plot(params.OQ); title OQ
   %    figure
   %    plot(params.SQ); title SQ
   %    figure
   %    plot(params.SI); title SI
   %    figure
   %    plot(params.RQ); title RQ
   %    figure
   %    plot(params.BO); title BO
   %    figure
   %    plot(params.PDI); title PDI
   %    figure
   %    plot([params.MOR params.MCR]); title MaxRates
   %    figure
   %    plot([params.NMOR params.NMCR]); title NormMaxRates
   %    figure
   %    plot(params.PSPI); title PSPI
   
   save(matfile,'-append','params')
end

% max/min rates
% a(:) = a./(App(k)*OT50(k));
% [to,SI(k,1)] = fminsearch(@(x)-dsdtfun(x,f0(k),p,phi,a),t0,opts);
% [tc,SI(k,2)] = fminsearch(@(x)dsdtfun(x,f0(k),p,phi,a),t0,opts);
% PSPI(:) = -sum(1./SI,2)/2; % range: 0-2*pi
