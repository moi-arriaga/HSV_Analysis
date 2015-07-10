function parout=Analyze(name)
rates=[2,4,5,8];
source=[2,8];
C=textscan(name,'%s%s');
% parout(size(source,2)).rateN(size(rates,2)).out=(ModelEstimation('mkef8to8'));
% parout(size(source,2)).rateN(size(rates,2)).par=Parameters(parout(size(source,2)).rateN(size(rates,2)).out);
for n=1:size(source,2)
    namen=char(C{n});
    for r=1:size(rates,2)
        if namen(length(namen))=='f'
            parout(n).rateN(r).out=(ModelEstimation(sprintf('%s%d%s%d',namen,source(n),'to',rates(r)),'f'));
            parout(n).rateN(r).par=Parameters(parout(n).rateN(r).out);
        else
            parout(n).rateN(r).out=ModelEstimation(sprintf('%s%d%s%d',namen,source(n),'to',rates(r)));
            parout(n).rateN(r).par=Parameters(parout(n).rateN(r).out);
        end
    end
end
end
