function PlotParameters(parray,varargin)
%parray=pars;
source=[2000,8000];
if size(parray,2)<4
    for n=1:size(source,2)
        
        figure('name',sprintf('%s%d%s','mkef ',source(n),' FPS Original File'))
        
        subplot(5,1,1);
        plot([parray(n).rateN(1).par.Fo(:) parray(n).rateN(2).par.Fo(:) parray(n).rateN(3).par.Fo(:) parray(n).rateN(4).par.Fo(:)],'.-');
        ylabel('Fo')
        legend('2000','4000','5000','8000')
        
        subplot(5,1,2);
        plot([parray(n).rateN(1).par.OQ(:) parray(n).rateN(2).par.OQ(:) parray(n).rateN(3).par.OQ(:) parray(n).rateN(4).par.OQ(:)],'.-');
        ylabel('OQ')
        
        subplot(5,1,3);
        plot([parray(n).rateN(1).par.SI(:) parray(n).rateN(2).par.SI(:) parray(n).rateN(3).par.SI(:) parray(n).rateN(4).par.SI(:)],'.-');
        ylabel('SI')
        
        subplot(5,1,4);
        plot([parray(n).rateN(1).par.RGG(:) parray(n).rateN(2).par.RGG(:) parray(n).rateN(3).par.RGG(:) parray(n).rateN(4).par.RGG(:)],'.-');
        ylabel('RGG')
        
        subplot(5,1,5);
        plot([parray(n).rateN(1).par.HNR(:) parray(n).rateN(2).par.HNR(:) parray(n).rateN(3).par.HNR(:) parray(n).rateN(4).par.HNR(:)],'.-');
        ylabel('HNR')
    end
else
    for n=1:size(parray,2)
        Fs(n)=std(parray(n).par.Fo);
        Os(n)=std(parray(n).par.OQ);
        Ss(n)=std(parray(n).par.SI);
        Hs(n)=std(parray(n).par.HNR);
        Rs(n)=std(parray(n).par.RGG);
        F(n)=mean(parray(n).par.Fo);
        O(n)=mean(parray(n).par.OQ);
        S(n)=mean(parray(n).par.SI);
        H(n)=mean(parray(n).par.HNR);
        R(n)=mean(parray(n).par.RGG);
    end
        points=varargin{1};
        rawpoints=varargin{2};
        x=200+(0:29)*(3800/30);
        
        for k=1:4
            fp(k)=mean(points(end).rateN(k).par.Fo);
            op(k)=mean(points(end).rateN(k).par.OQ);
            sp(k)=mean(points(end).rateN(k).par.SI);
            hp(k)=mean(points(end).rateN(k).par.HNR);
            rp(k)=mean(points(end).rateN(k).par.RGG);
            
            fps(k)=std(points(end).rateN(k).par.Fo);
            ops(k)=std(points(end).rateN(k).par.OQ);
            sps(k)=std(points(end).rateN(k).par.SI);
            hps(k)=std(points(end).rateN(k).par.HNR);
            rps(k)=std(points(end).rateN(k).par.RGG);
        end
        for k=1:4
            fpr(k)=mean(rawpoints(end).rateN(k).par.Fo);
            opr(k)=mean(rawpoints(end).rateN(k).par.OQ);
            spr(k)=mean(rawpoints(end).rateN(k).par.SI);
            hpr(k)=mean(rawpoints(end).rateN(k).par.HNR);
            rpr(k)=mean(rawpoints(end).rateN(k).par.RGG);
            
            fpsr(k)=std(rawpoints(end).rateN(k).par.Fo);
            opsr(k)=std(rawpoints(end).rateN(k).par.OQ);
            spsr(k)=std(rawpoints(end).rateN(k).par.SI);
            hpsr(k)=std(rawpoints(end).rateN(k).par.HNR);
            rpsr(k)=std(rawpoints(end).rateN(k).par.RGG);
        end

        figure('name','8000 FPS with varying GAW filters')
        
        subplot(5,1,1)
        plot(x,F)
        hold on
        plot(1000,fp(3),'*',1000,fp(2),'+',1000,fp(1),'o');
        plot(4000,fpr(4),'p',2500,fpr(3),'*',2000,fpr(2),'+',1000,fpr(1),'o');
        legend('8000 at different cutoffs','Decimated to 5000', 'Decimated to 4000', 'Decimated to 2000')
        ylabel('Fo')
        hold off
        subplot(5,1,2)
        plot(x,O)
        hold on
        plot(1000,op(3),'*',1000,op(2),'+',1000,op(1),'o');
        plot(4000,opr(4),'p',2500,opr(3),'*',2000,opr(2),'+',1000,opr(1),'o');
        ylabel('OQ')
        subplot(5,1,3)
        plot(x,S)
        hold on
        plot(1000,sp(3),'*',1000,sp(2),'+',1000,sp(1),'o');
        plot(4000,spr(4),'p',2500,spr(3),'*',2000,spr(2),'+',1000,spr(1),'o');
        ylabel('SI')
        subplot(5,1,4)
        plot(x,R)
        hold on
        plot(1000,rp(3),'*',1000,rp(2),'+',1000,rp(1),'o');
        plot(4000,rpr(4),'p',2500,rpr(3),'*',2000,rpr(2),'+',1000,rpr(1),'o');
        ylabel('RGG')
        subplot(5,1,5)
        plot(x,H)
        hold on
        plot(1000,hp(3),'*',1000,hp(2),'+',1000,hp(1),'o');
        plot(4000,hpr(4),'p',2500,hpr(3),'*',2000,hpr(2),'+',1000,hpr(1),'o');
        ylabel('HNR')
        xlabel('Filter Cutoff Frequency')
        hold off
       figure
        unfiltered=hadload('mk8to8');
        pwelch(unfiltered.GlottalArea,hanning(1024),800,1024,8000)
        
        figure('name','StDev 8000 FPS with varying GAW filters')
        
        subplot(5,1,1)
        plot(x,Fs)
        hold on
        plot(1000,fps(3),'*',1000,fps(2),'+',1000,fps(1),'o');
        plot(4000,fpsr(4),'p',2500,fpsr(3),'*',2000,fpsr(2),'+',1000,fpsr(1),'o');
        legend('8000 at different cutoffs','Decimated to 5000 and filtered at 1000', 'Decimated to 4000 and filtered at 1000', 'Decimated to 2000 and filtered at 1000','Not decimated, not filtered', '5000','4000','2000')
        ylabel('Fo')
        hold off
        subplot(5,1,2)
        plot(x,Os)
        hold on
        plot(1000,ops(3),'*',1000,ops(2),'+',1000,ops(1),'o');
        plot(4000,opsr(4),'p',2500,opsr(3),'*',2000,opsr(2),'+',1000,opsr(1),'o');
       ylabel('OQ')
        subplot(5,1,3)
        plot(x,Ss)
        hold on
        plot(1000,sps(3),'*',1000,sps(2),'+',1000,sps(1),'o');
        plot(4000,spsr(4),'p',2500,spsr(3),'*',2000,spsr(2),'+',1000,spsr(1),'o');
       ylabel('SI')
        subplot(5,1,4)
        plot(x,Rs)
        hold on
         plot(1000,rps(3),'*',1000,rps(2),'+',1000,rps(1),'o');
         plot(4000,rpsr(4),'p',2500,rpsr(3),'*',2000,rpsr(2),'+',1000,rpsr(1),'o');
        ylabel('RGG')
        subplot(5,1,5)
        plot(x,Hs)
        hold on
        plot(1000,hps(3),'*',1000,hps(2),'+',1000,hps(1),'o');
        plot(4000,hpsr(4),'p',2500,hpsr(3),'*',2000,hpsr(2),'+',1000,hpsr(1),'o');
       
        ylabel('HNR')
        xlabel('Filter Cutoff Frequency')
        hold off
%     
%         figure('name','8000 FPS with varying GAW filters')
%         
%         subplot(5,1,1);
%         plot([parray(n).rateN(1).par.Fo(:) parray(n).rateN(2).par.Fo(:) parray(n).rateN(3).par.par.Fo(:) parray(n).rateN(4).par.Fo(:)],'.-');
%         ylabel('Fo')
%         legend('2000','4000','5000','8000')
%         
%         subplot(5,1,2);
%         plot([parray(n).rateN(1).par.OQ(:) parray(n).rateN(2).par.OQ(:) parray(n).rateN(3).par.OQ(:) parray(n).rateN(4).par.OQ(:)],'.-');
%         ylabel('OQ')
%         
%         subplot(5,1,3);
%         plot([parray(n).rateN(1).par.SI(:) parray(n).rateN(2).par.SI(:) parray(n).rateN(3).par.SI(:) parray(n).rateN(4).par.SI(:)],'.-');
%         ylabel('SI')
%         
%         subplot(5,1,4);
%         plot([parray(n).rateN(1).par.RGG(:) parray(n).rateN(2).par.RGG(:) parray(n).rateN(3).par.RGG(:) parray(n).rateN(4).par.RGG(:)],'.-');
%         ylabel('RGG')
%         
%         subplot(5,1,5);
%         plot([parray(n).rateN(1).par.HNR(:) parray(n).rateN(2).par.HNR(:) parray(n).rateN(3).par.HNR(:) parray(n).rateN(4).par.HNR(:)],'.-');
%         ylabel('HNR')
end
end














%
% figure('name','8000 FPS Original File')
% subplot(5,1);
% plot([parray(2).rateN(1).par.Fo(:) parray(2).rateN(2).par.Fo(:) parray(2).rateN(3).par.Fo(:) parray(2).rateN(4).par.Fo(:)],'.-');
%    ylabel('Fo')
%    legend('2000','4000','5000','8000')
%
% subplot(5,1,2);
%     plot([parray(2).rateN(1).par.OQ(:) parray(2).rateN(2).par.OQ(:) parray(2).rateN(3).par.OQ(:) parray(2).rateN(4).par.OQ(:)],'.-');
%     ylabel('OQ')
%
% subplot(5,1,3);
%    plot([parray(2).rateN(1).par.SI(:) parray(2).rateN(2).par.SI(:) parray(2).rateN(3).par.SI(:) parray(2).rateN(4).par.SI(:)],'.-');
%     ylabel('SI')
%
% subplot(5,1,4);
%    plot([parray(2).rateN(1).par.RGG(:) parray(2).rateN(2).par.RGG(:) parray(2).rateN(3).par.RGG(:) parray(2).rateN(4).par.RGG(:)],'.-');
%    ylabel('RGG')
%
% subplot(5,1,5);
%    plot([parray(2).rateN(1).par.HNR(:) parray(2).rateN(2).par.HNR(:) parray(2).rateN(3).par.HNR(:) parray(2).rateN(4).par.HNR(:)],'.-');
%    ylabel('HNR')
