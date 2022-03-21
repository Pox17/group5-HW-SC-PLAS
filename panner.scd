s.boot

(
SynthDef(\positioner,{
	arg inBus, outBus, angle = 0, radius = 0;
	var input, output, pan;

	input = In.ar(inBus,1);
	Out.ar(in,Pan2.ar(input,angle,radius))
}).add
)
b = Bus.audio(s,2);
(

SynthDef(\roomer,{
	arg inBus, outBus = 0, dimension=0.5, distance=0.5;
	var input, output, rev;

	input = In.ar(inBus,2);
	output = FreeVerb2.ar(input[0],input[1],distance,dimension);
} ).add
)

(
{
	i = Impulse.ar(1);

	//p = Synth.before(i,\positioner,[\inBus,i,\outBus,0]);
}.play;
)


