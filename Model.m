
function models=Model(name)
rates=[2,4,5,8];
source=[2,8];

models(size(source,2)).rateN(size(rates,2))=ModelEstimation('mke8to8');

for n=1:size(source,2)
    for r=1:size(rates,2)
      models(n).rateN(r)=ModelEstimation(sprintf('%s%d%s%d',name,source(n),'to',rates(r)));
    end
end
end