                                                                                                                                    
                                             
function [t,A] = findlocalextrema(T,omega0,p,phi,a)

L = numel(p)-1;
DeltaMax = pi/omega0/(2*L); % maximum allowed displacement in one step
deltat = T/(2*L);

t = zeros(2*L,1);
A = zeros(2*L,1);

% Partial Sum function/1st derivative/2nd derivative
sfun = @(t,omega0,p,phi,a)cos(bsxfun(@plus,omega0*t*p,phi))*a;
dsfun = @(t,omega0,p,phi,a)-sin(bsxfun(@plus,omega0*t*p,phi))*(omega0*a.*p(:));
d2sfun = @(t,omega0,p,phi,a)-cos(bsxfun(@plus,omega0*t*p,phi))*(a.*(omega0*p(:)).^2);

% peak finder
fxfuns = {@(t)sfun(t,omega0,p,phi,-a)
   @(t)dsfun(t,omega0,p,phi,-a)
   @(t)d2sfun(t,omega0,p,phi,-a)};

% trough finder
fnfuns = {@(t)sfun(t,omega0,p,phi,a)
   @(t)dsfun(t,omega0,p,phi,a)
   @(t)d2sfun(t,omega0,p,phi,a)};

% start with the peak near H1 peak
N = 1;
[t(N),Ap] = trust_region(-phi(2)/omega0,DeltaMax,fxfuns{:});
A(N) = -Ap;

% Get all the local peaks and troughs
Tend = t(1)+T-deltat/2;
while true
   % find next minima
   [t(N+1),A(N+1)] = trust_region(t(N)+deltat,DeltaMax,fnfuns{:});
   % and subsequent maxima
   [tp,Ap] = trust_region(t(N+1)+deltat,DeltaMax,fxfuns{:});
   N = N+2;
   if tp>=Tend, break; end
   t(N) = tp;
   A(N) = -Ap;
end

% make sure that the extrema are within one cycle
while N>2 && t(N-1)>t(1)+T
   N = N-2;
end

t(N:end) = [];
A(N:end) = [];

% place the maximum A at the first position
[~,Imax] = max(A);
if Imax~=1
   t(:) = [t(Imax:N-1);t(1:Imax-1)+T];
   A(:) = A([Imax:N-1 1:Imax-1]);
end