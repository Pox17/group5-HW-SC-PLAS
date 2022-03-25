s.boot;
a = Buffer.readChannel(s,"C:/Users/Scrapper/Desktop/1.wav",channels:[0]);

({
var center,hpf,verb,lpf,sig2,sigfin;
	sig2 = GrainBuf.ar(1,Impulse.ar(20),1,a,1,0.5)*WhiteNoise.ar();
	verb = FreeVerb.ar(sig2,0.2);
	center = Pan2.ar(verb,0,1);
	hpf = HPF.ar(center,500);
	lpf = LPF.ar(hpf,5000);
	sigfin = lpf*0.5;
}.play
)

