s.boot

(
SynthDef(\positioner,{
	arg inBus=0, outBus=0, angle = 0, radius = 0;
	var input, output, pan;

	input = In.ar(inBus,1);
	Out.ar(outBus,Pan2.ar(input,angle));
}).add;
)
(
SynthDef(\impulse,{
	arg outBus=0;
	var input, output;

	input = Impulse.ar(1);
	Out.ar(outBus,input);
}).add;
)


b = Bus.audio(s,1);


(

SynthDef(\roomer,{
	arg inBus, outBus = 0, dimension=0.5, distance=1;
	var input, output, rev;

	input = In.ar(inBus,2);
	output = FreeVerb2.ar(input[0],input[1],distance,dimension);
	Out.ar(outBus,output)
} ).add
)

(
r = Routine(
{

	p = Synth(\positioner,[\inBus,b,\angle,0.7]);
	i = Synth.before(p,\impulse,[\outBus,b]);

	//r = Synth.after(p,\roomer,[\inBus,b])
}
);
)
r.play;
s.meter(26,26)
