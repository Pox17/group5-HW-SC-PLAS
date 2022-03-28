
(
.
a = Buffer.readChannel(s,~samplePath,channels:[0]);
)
(
SynthDef(\PassettiNeve, {
	arg a, out, gate = 1, amp = 1, envbuf, hpfreq = 2000,speed = 1;
    var center,sig2,hpf,verb,shf,lpf, sig;

	sig2 = GrainBuf.ar(1,Impulse.ar(speed),0.4,a,1,0.34,2,0);
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