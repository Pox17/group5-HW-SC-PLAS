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
/*---------------------------------WOLF SYNTH-------------------------------------*/
/*--------------------------------------------------------------------------------*/

(
SynthDef(\wolf, {
	arg buff = a,
	outBus = 0,
	length = 3.5,
	grainPos = 0.162215,
	occurence = 0.2;

	var sig,
	env, env1, envgen1,
	lpf, trig;

	trig = Trig1.ar(LFNoise1.kr(occurence), length+LFNoise1.kr(0.5).range(-1, 0));

	env = EnvGen.kr(Env.adsr(1, 0.5, 1, 2, 0.8, \sin), trig, 1, 0.1);
	env1 = Env.sine(3.5);
	envgen1= EnvGen.kr(env1, trig);


	sig = GrainBuf.ar(
		numChannels: 1,
		trigger: Impulse.ar(envgen1*50*SinOsc.kr(1/7).range(0.8, 1.1) + 350),
		dur: 0.3,
		sndbuf: buff,
		rate: 0.2*env+LFNoise1.kr(4).bipolar(0.001),
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 1,
		add: 0
	)*0.8 + LFNoise1.kr(10).bipolar(0.1);

	lpf = LPF.ar(sig, 900);

	Out.ar(outBus, lpf);

}).add;
);

Synth(\wolf);

/*--------------------------------------------------------------------------------*/