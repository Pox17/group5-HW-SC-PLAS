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
/*--------------------------------FROGS SYNTH-------------------------------------*/
/*--------------------------------------------------------------------------------*/
(
SynthDef(\frog, {
	arg buff = a,
	outBus = 0,
	grainPos = 0.162215,
	randomness = 1, // 0.0 - 1.0
	excited1 = 1,  // 0.5 - 1.7
	excited2 = 1.7;  // 0.5 - 1.7
	

	var sig, sig2, mix, out,
	envPitch,env,
	trig, trig2;
	
	envPitch = EnvGen.kr(Env.perc(1, 3, curve:0));
	env = EnvGen.kr(Env.perc(0.01, 3));
	trig = Trig1.ar((LFSaw.ar(0.3*excited2)+LFSaw.ar(1.2*excited2, 0, 0.25) + LFNoise1.ar(randomness).range(-0.5, 2)*randomness), 0.3);
	sig = GrainBuf.ar(
		numChannels: 1,
		trigger: Impulse.ar(30 * trig ),
		dur: 0.01,
		sndbuf: buff,
		rate: 5 + EnvGen.kr(Env.asr(0.3, 1, 0.1), gate: trig),
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 5,
		add: 0
	);

	trig2 = Trig1.ar(SinOsc.ar(80), 0.3);
	sig2 = GrainBuf.ar(
		numChannels: 1,
		trigger: Impulse.ar(60 * LFPulse.ar((4*excited1) + LFNoise1.ar(1).bipolar(2), 0, 0.3, 0.5, 0.5)),
		dur: 0.01,
		sndbuf: buff,
		rate: 15 + EnvGen.ar(Env.asr(0.2, 2, 0.2), gate:trig2),
		pos: 0.553747,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 0.3,
		add: 0
	);

	mix = Mix([sig, sig2]*0.3);
	out = LPF.ar(mix, 1500);

	Out.ar(outBus, out);
}).add
)
/*--------------------------------------------------------------------------------*/