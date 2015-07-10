filttest=lowp;
n=randn([1,200]);
m=filtfilt(lowp.Numerator,1,n);
t=1:200;
plot(t,n,t,m)
