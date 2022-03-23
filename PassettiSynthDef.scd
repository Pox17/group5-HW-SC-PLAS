s.boot

(a = Buffer.readChannel(s,"C:/Users/Scrapper/Desktop/1.wav",channels:[0]));

//PassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassettiPassetti

//hpfreq goes from 200 (snowy ground) to 2000 (dirt)
(
SynthDef(\PassettiNeve, { |out, gate = 1, amp = 1, envbuf, hpfreq = 200|
    var center,sig2,hpf,verb,shf,lpf, sig;
	sig2 = GrainBuf.ar(1,Impulse.ar(1),0.4,a,1,0.34,2,0);
	sig = sig2 * BrownNoise.ar(1,0);
	verb = FreeVerb.ar(sig,0.2);
	shf = PitchShift.ar(verb,0.2,0.2);
	center = Pan2.ar(shf,0,1);
	hpf = HPF.ar(center,hpfreq);
	lpf = LPF.ar(hpf,6000)*20;
    Out.ar(out,
		lpf)
}).add;
)

s = Synth(\PassettiNeve);
