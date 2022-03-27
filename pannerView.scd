
s.boot;

(
~samplePath;
~samplePath= thisProcess.nowExecutingPath.dirname +/+ "buffer/1.wav";
~a = Buffer.readChannel(s,~samplePath,channels:[0]);
)
(
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

SynthDef(\PassettiNeve, {
	arg out, gate = 1, amp = 1, envbuf, hpfreq = 2000,speed = 1;
    var center,sig2,hpf,verb,shf,lpf, sig;

	sig2 = GrainBuf.ar(1,Impulse.ar(speed),0.4,~a,1,0.34,2,0);
	sig = sig2 * BrownNoise.ar(1,0);
	verb = FreeVerb.ar(sig,0.2);
	shf = PitchShift.ar(verb,0.2,0.2);
	center = Pan2.ar(shf,0,1);
	hpf = HPF.ar(center,hpfreq);
	lpf = LPF.ar(hpf,6000)*20;
    Out.ar(out,
		lpf)
}).add;


SynthDef(\impulse,{
	arg outBus=0;
	var input, output;

	input = Impulse.ar(1);
	Out.ar(outBus,input);
}).add;


SynthDef(\roomer,{
	arg inBus, outBus = [0,1], dimension=0.2, mix=1.0;
	var input, output, rev;

	input = In.ar(inBus,2);
	output = //FreeVerb2.ar(input[0],input[1],mix,dimension);
GVerb.ar(in, roomsize: 10, revtime: 3, damping: 0.5, inputbw: 0.5, spread: 15, drylevel: 1, earlyreflevel: 0.7, taillevel: 0.5, maxroomsize: 300, mul: 1, add: 0)
	Out.ar(outBus,output)
} ).add
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
~angPos = Array2D.new(numOfPoints,2);
w = Window.new("gui",Rect(100,100,(width+(100)),(height+(100)))).front;
v = UserView(w,Rect(50,50,height+2,width+2));

r = Routine(
{

	p = Synth(\positioner,[\inBus,b,\angle,~angPos[0,1],\mainOut,[0,1],\effectOut,b2]);
	i = Synth(\PassettiNeve,[\out,b]);//Synth.before(p,\impulse,[\outBus,b]);
	j = Synth.after(p,\roomer,[\inBus,b2,\outBus,[0,1]]);
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
	"CIAO".postln;
	for (0, numOfPoints-1, {
		arg i;
		var angle, distance,angle01,distance01;
		i.postln;
		pos.at(i,0).postln;
		Pen.fillColor = Color.green;
		Pen.strokeColor = Color.blue;
		"CIAO1".postln;
		Pen.addArc((pos.at(i,0))@(pos.at(i,1)),elRadius, 0,2pi);
		"CIAO2".postln;
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