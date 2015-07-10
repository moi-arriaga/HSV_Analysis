%g = cos(bsxfun(@plus,2*pi*t*(0:11)*out8000(1).f1,out8000(1).phi))*out8000(1).a(:);
function [model1,model2]=plotmodelanddata(out,name,fs,k)
% k=156;

Nana=80;
Noffset=10;
Fs=fs;
no=k*Noffset;
tdat=(no+(0:Nana+Noffset-1))/Fs;
tmod=linspace(no/Fs,(no+Nana-1)/Fs,1000).';
% mat2to2=matfile('mke2to2.mat');

s=hadload(name);
area=s.GlottalArea;
% out
model1=cos(bsxfun(@plus,2*pi*tmod*out(k).f1*(0:length(out(k).a)-1),out(k).phi))*(out(k).a.');



k2=k+1;
no2=k2*Noffset;
tdat2=(no2+(0:Nana-1))/Fs;
tmod2=transpose(linspace(no2/Fs,(no2+Nana-1)/Fs,1000));

model2=cos(bsxfun(@plus,2*pi*tmod2*out(k2).f1*(0:length(out(k2).a)-1),out(k2).phi))*(out(k2).a.');

% figure;
plot(tdat,area(no+(1:Nana+Noffset)),'.-',tmod,model1,'.-',tmod2,model2,'.-');

% plot(tdat2,area(no+(1:Nana)),tmod2,model151);

% figure;


end