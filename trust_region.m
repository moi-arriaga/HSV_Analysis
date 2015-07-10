function [x,fval] = trust_region(x0,Delta0,ffun,dffun,d2ffun,opts)

error(nargchk(5,6,nargin));
if nargin<6
   opts.eta = 0.125;
   opts.maxiter = 500; % Maximum # of iterations
   opts.tol = 1e-6;
   opts.epsilon = 1e-3;
   opts.DeltaMax = 1e10;
end

x = x0;
Delta = Delta0/2;
% xh = zeros(opts.maxiter+1,1);
for k = 1:opts.maxiter
%    xh(k) = x;
   f = ffun(x);
   g = dffun(x);
   B = d2ffun(x);
   mfun = @(p)f+g'*p+p'*B*p/2;
   
   % obtain p by solving (4.3)
   [~,p] = chol(B);
   if p % if B is not PD use dogleg method
      % only applicable for 1-D minimization
      if g<0 % move to +Delta
         p = Delta;
      else
         p = -Delta;
      end
   else % B not PD: use 2-D subspace minimization
      p = -g/B;              % Newton's method update
      if abs(p)>Delta % too big of an update
         p = sign(p)*Delta;
      end
   end
   
   % termination condition
   df = f - mfun(p);
   if abs(df)<opts.tol
      break;
   end
   
   % evaluate rho from (4.4)
   rho = (f - ffun(x+p))/df;
   
   if rho<0.25 % shrink the trust region
      Delta = Delta/4;
   elseif rho>0.75 && abs(p'*p - Delta)<1e-6
      Delta = min(2*Delta,opts.DeltaMax);
   % else no change
   end 
   
   if rho>opts.eta
      x = x + p;
   end

end

if nargout>1
   fval = ffun(x);
end
