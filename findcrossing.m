function t = findcrossing(f0,t0,omega0,p,phi,a)

% Partial Sum function/1st derivative/2nd derivative
sfun = @(t,omega0,p,phi,a)cos(bsxfun(@plus,omega0*t*p,phi))*a;
dsfun = @(t,omega0,p,phi,a)-sin(bsxfun(@plus,omega0*t*p,phi))*(omega0*a.*p(:));
d2sfun = @(t,omega0,p,phi,a)-cos(bsxfun(@plus,omega0*t*p,phi))*(a.*(omega0*p(:)).^2);

ffun = @(t)(sfun(t,omega0,p,phi,a)-f0).^2;
dffun = @(t)2*(sfun(t,omega0,p,phi,a)-f0)*dsfun(t,omega0,p,phi,a);
d2ffun = @(t)2*(dsfun(t,omega0,p,phi,a).^2 + (sfun(t,omega0,p,phi,a)-f0)*d2sfun(t,omega0,p,phi,a));

L = numel(p)-1;
DeltaMax = pi/omega0/(2*L); % maximum allowed displacement in one step

t = trust_region(t0,DeltaMax,ffun,dffun,d2ffun);

