


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

(
r = Routine(
{

		p = Synth(\positioner,[\inBus,b,\angle,~angPos[0,1]]);
	i = Synth.before(p,\impulse,[\outBus,b]);

	//r = Synth.after(p,\roomer,[\inBus,b])
}
);
)
r.play;

(

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
		"distance01".postln;
		distance01.postln;
		"angle01".postln;
		angle01.postln;
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
	v.refresh;

	}
	)
};

)