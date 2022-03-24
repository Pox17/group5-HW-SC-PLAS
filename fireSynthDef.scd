/*--------------------------------------------------------------------------------*/
/*----------------------------------BUFFERS---------------------------------------*/
/*--------------------------------------------------------------------------------*/

(
a = Buffer.readChannel(s, "./buffer/1.wav", channels:[0]);
b = Buffer.readChannel(s, "./buffer/2.wav", channels:[0]);
c = Buffer.readChannel(s, "./buffer/3.wav", channels:[0]);
);

/*--------------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------------*/
/*---------------------------------FIRE SYNTH-------------------------------------*/
/*--------------------------------------------------------------------------------*/

(
SynthDef(\fire, {
	arg buff = a,
	outBus = 0,
	grainPos = 0.22,
	wood = 1;

	var sig1, sig2, sig3, mix, out;

	// High sparkles
	sig1 = GrainBuf.ar(
		numChannels: 1,
		trigger: Dust.ar((0.3*wood)+LFNoise1.ar(3).bipolar(0.2)),
		dur: 0.001,
		sndbuf: buff,
		rate: 3*SinOsc.ar(0.2).range(1,2),
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 10 + LFNoise1.ar(0.3).range(0,2) + (wood/100),
		add: 0
	);

	// Low Sparkles
	sig2 = GrainBuf.ar(
		numChannels: 1,
		trigger: Dust.ar(SinOsc.kr(0.5, 0, 0.5, 1) + LFNoise1.ar(0.3).bipolar(1)),
		dur: 0.005+SinOsc.ar(0.1).bipolar(0.001),
		sndbuf: buff,
		rate: 0.7+SinOsc.ar(0.5).bipolar(0.1),
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 2*SinOsc.ar(0.2, 0, 1, 1)+LFNoise1.ar(0.3).bipolar(1) + (wood/100),
		add: 0
	)*0.2;

	// Noise
	sig3 = GrainBuf.ar(
		numChannels: 1,
		trigger: Dust.ar(20000+LFNoise1.ar(10).bipolar(1000)),
		dur: 0.0005,
		sndbuf: buff,
		rate: 4,
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: (0.3 + SinOsc.ar(0.2+LFNoise1.ar(1).bipolar(0.1)).range(-0.05, 0))*0.1 + (wood/100),
		add: 0
	);

	sig3 = LPF.ar(sig3, 4000+SinOsc.ar(0.3).bipolar(50));

	mix = Mix([sig1, sig2, sig3]);
	out = LPF.ar(mix, 5000);
	out = HPF.ar(out, 1000);
	out = Limiter.ar(out, 0.99);
	Out.ar(outBus, out);

}).add;
);

/*--------------------------------------------------------------------------------*/
