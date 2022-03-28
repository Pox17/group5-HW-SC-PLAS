/*--------------------------------------------------------------------------------*/
/*----------------------------------BUFFERS---------------------------------------*/
/*--------------------------------------------------------------------------------*/

(
~samplePath1;
~samplePath2;
~samplePath3;
~samplePath1= thisProcess.nowExecutingPath.dirname +/+ "buffer/1.wav";
~samplePath2= thisProcess.nowExecutingPath.dirname +/+ "buffer/2.wav";
~samplePath3= thisProcess.nowExecutingPath.dirname +/+ "buffer/3.wav";

a = Buffer.readChannel(s, ~samplePath1, channels:[0]);
b = Buffer.readChannel(s, ~samplePath2, channels:[0]);
c = Buffer.readChannel(s, ~samplePath3, channels:[0]);
)

/*--------------------------------------------------------------------------------*/


(
/*--------------------------------------------------------------------------------*/
// FIRE
/*--------------------------------------------------------------------------------*/
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

/*--------------------------------------------------------------------------------*/
// FROGZ
/*--------------------------------------------------------------------------------*/
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
}).add;


/*--------------------------------------------------------------------------------*/
// STEPS
/*--------------------------------------------------------------------------------*/
SynthDef(\PassettiNeve, {
	|out, gate = 1, amp = 1, envbuf, hpfreq = 2000,speed = 1|

    var center,sig2,hpf,verb,shf,lpf, sig;

	// sig2 = GrainBuf.ar(1,Impulse.ar(speed),0.4,a,1,0.34,2,0);
	sig2 = GrainBuf.ar(
		numChannels: 1,
		trigger: Impulse.ar(speed),
		dur: 0.4,
		sndbuf: a,
		rate: 1,
		pos: 0.34,
		interp: 2,
		pan: 0,
		envbufnum: -1,
		maxGrains: 512,
		mul: 1,
		add: 0);
	sig = sig2 * BrownNoise.ar(1,0);
	// verb = FreeVerb.ar(sig,0.2);
	shf = PitchShift.ar(sig,0.2,0.2);
	// center = Pan2.ar(shf,0,1);
	hpf = HPF.ar(shf,hpfreq);
	lpf = LPF.ar(hpf,6000)*20;
    Out.ar(out,
		lpf)
}).add;


/*--------------------------------------------------------------------------------*/
// WOLF
/*--------------------------------------------------------------------------------*/
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

SynthDef(\positioner,{
	arg inBus=0, mainOut=[0,1], effectOut=[2,3], angle = 0, radius =0 ;
	var val,valEf, input,effect, output, panMain,panEf, inGain,efGain;

	efGain = (0.2+(0.1*radius));//(((radius+0.5).log10)+0.1)*0.8;
	inGain = (1-(0.95*radius));//1-radius;//1.1-((radius+0.15).log10);
	input = In.ar(inBus,1); //(1-(radius-0.1));
	val = input*inGain;
	valEf = input*efGain; //*(efGain)*(inGain+0.1);
	panMain = Pan2.ar(val,angle);
	panEf = Pan2.ar(valEf,angle);
	Out.ar(mainOut,panMain);
	Out.ar(effectOut,panEf);
}).add;

)




(
var b = Bus.audio(s,1);
var b2 = Bus.audio(s,2);
var elRadius = 8,
xStart=1,
yStart=1,
height=400,
width=400,
numOfPoints =1,
pos1D = Array.fill((numOfPoints*2),{10+(180.rand)}).postln,
pos=Array2D.fromArray(numOfPoints,2,pos1D).postln,
centerPosX = width/2,
centerPosY = height,
selPos = -1;

~wolf = Synth(\wolf).run(false);
~fire = Synth(\fire).run(false);
~steps = Synth(\PassettiNeve).run(false);
~frogs = Synth(\frog).run(false);


~angPos = Array2D.new(numOfPoints,2);
w = Window.new("gui",Rect(100,100,(width+(100)),(height+(100)))).front;
v = UserView(w,Rect(50,50,height+2,width+2));

r = Routine(
{

	p = Synth(\positioner,[\inBus,b,\angle,~angPos[0,1],\mainOut,[0,1],\effectOut,b2]);
		// i = Synth(\PassettiNeve,[\out,b]);//Synth.before(p,\impulse,[\outBus,b]);
		~wolf.run(true);
		~wolf.set(\outBus, b)
		// j = Synth.after(p,\roomer,[\inBus,b2,\outBus,[0,1]]);
}
);
//i = Synth(\PassettiNeve,[]);
r.play;

v.drawFunc = {
	Pen.fillColor = Color.black;
    Pen.strokeColor = Color.red;

	Pen.moveTo((xStart@yStart));
	Pen.lineTo(((xStart+width)@yStart));
	Pen.lineTo(((xStart+width)@(yStart+height)));
	Pen.lineTo((xStart@(yStart+height)));
	Pen.lineTo((xStart@yStart));
	Pen.fillStroke;
	// "CIAO".postln;
	for (0, numOfPoints-1, {
		arg i;
		var angle, distance,angle01,distance01;
		i.postln;
		pos.at(i,0).postln;
		Pen.fillColor = Color.green;
		Pen.strokeColor = Color.blue;
		// "CIAO1".postln;
		Pen.addArc((pos.at(i,0))@(pos.at(i,1)),elRadius, 0,2pi);
		// "CIAO2".postln;
		angle = ((pos[i,0]-centerPosX)/(pos[i,1]-centerPosY).abs).atan;
		angle01 = angle/(pi/2);
		distance = (((pos[i,0]-centerPosX).squared)+((pos[i,1]-centerPosY).squared)).sqrt;
		distance01 = distance/height;
		//"distance01".postln;
		//distance01.postln;
		//"angle01".postln;
		//angle01.postln;
		~angPos[i,0] = distance01;
		~angPos[i,1] = angle01;

		Pen.fillStroke;
	});
};

v.mouseDownAction = { arg view, x,y, m;
    //m.postln;
    ([256, 0].includes(m)).if{ // restrict to no modifier
    //value = (x).linlin(0,v.bounds.width,0,1); v.doAction};
	var found = false;
		for (0, numOfPoints-1, {
		arg i;
			if((x>=(pos[i,0]-elRadius))&&((x<=(pos[i,0]+elRadius)))&&((y>=(pos[i,1]-elRadius)))&&((y<=(pos[i,1]+elRadius))),{
				selPos = i;
				found =true;
			});
	});
		if(found!=true,{selPos= (-1)});
		selPos.postln
};
};
v.mouseMoveAction = { arg view, x,y, m;
	if(selPos!=(-1),{
		if(x<=(elRadius+1),{x=(elRadius+1)});
		if(x>=(width-(elRadius+1)),{x=(width-(elRadius+1))});
		if(y<=(elRadius+1),{y=(elRadius+1)});
			if(y>=(height-(elRadius+1)),{y=(height-(elRadius+1))});
	pos[selPos,0] =x;
	pos[selPos,1] =y;


		p.set(\angle,~angPos[0,1]);
		if((~angPos[0,0]>=1),{~angPos[0,0] = 1});
		"distance".postln;
		~angPos[0,0].postln;
		"angle".postln;
		~angPos[0,1].postln;
		p.set(\radius,~angPos[0,0]);
	v.refresh;

	}
	)
};


)