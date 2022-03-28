s.boot;


~scopefire;
~scopewolf;
~scopefrog;
~scopestep;
~wolfpath;
~path= thisProcess.nowExecutingPath.dirname;
~srcPath = ~path +/+ "buffer/1.wav";

(
//VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var f,wp,w1,w2,w3,w4,i1,i2,i3,i4,

bufFire,bufFrog,bufStep,bufWolf,

scopingSynth,image,

// margin

marg = 25,

// main window dimension

winWidth = 750,
winHeight = 650,
winUpDown = 50,
winRL = 900,

panWinRL = 900,
panWinUpDown = 750,
panWinWidth = 600,
panWinHeight = 300,

// single section dimensions

sectWinWidth = winWidth-(2*marg),
sectWinHeight = (winHeight-(5*marg))/4,

// label
titleWidth = 80,
titleHeight = 20,

//knob dimension
knobDim = 50,
knobIntraDist = 13,

knobLabelWidth = knobDim,
knobLabelHeight = 15,

//numberbox dimension

numBoxWidth = knobDim,
numBoxHeight = 15;


// panner variables

var elRadius = 8,
xStart=1,
yStart=1,
height=panWinHeight,
width=panWinWidth,
numOfPoints =4,
pos1D = Array.fill((numOfPoints*2),{10+(180.rand)}).postln,
pos=Array2D.fromArray(numOfPoints,2,pos1D).postln,
centerPosX = width/2,
centerPosY = height,
selPos = -1;

//WINDOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
~wolfpath =  ~path +/+ "/pointers/fire.png";
image = Image.new(~wolfpath);
//i1 = Image.new(	"C:/Users/Alberto/Desktop/Fire_crop.png");
//i2 = Image.new(	"C:/Users/Alberto/Desktop/Wolf_crop.png");
//i3 = Image.new(	"C:/Users/Alberto/Desktop/Shrek_crop.png");
//i4 = Image.new(	"C:/Users/Alberto/Desktop/Walk_crop.png");


Window.closeAll;

// main
w = Window.new("PLASgui",Rect(winRL,winUpDown,winWidth,winHeight), false)
.front
.alwaysOnTop_(true)
//.background_(Color.rand)
.drawFunc = {

    Pen.addRect(w.view.bounds.insetBy(0));
	Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.fromHexString("#05668d"), Color.fromHexString("#028090"));


	Pen.addRect(Rect(marg,marg,sectWinWidth,sectWinHeight))
	.width_(5)
	//.fillColor_(Color.black)
	//.fill
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(marg,(2*marg)+sectWinHeight,sectWinWidth,sectWinHeight))
	.width_(5)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(marg,(3*marg)+(2*sectWinHeight),sectWinWidth,sectWinHeight))
	.width_(5)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(marg,(4*marg)+(3*sectWinHeight),sectWinWidth,sectWinHeight))
	.width_(5)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	//i1.tileInRect(Rect(marg,marg,sectWinWidth,sectWinHeight),nil,2,0.5);
	//i2.tileInRect(Rect(marg,(2*marg)+sectWinHeight,sectWinWidth,sectWinHeight),nil,2,0.8);
	//i3.tileInRect(Rect(marg,(3*marg)+(2*sectWinHeight),sectWinWidth,sectWinHeight),nil,2,0.8);
	//i4.tileInRect(Rect(marg,(4*marg)+(3*sectWinHeight),sectWinWidth,sectWinHeight),nil,2,0.8);

	Pen.addRect(Rect(300,60, 150, 60))
	.width_(8)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(300,216, 150, 60))
	.width_(8)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(300,373, 150, 60))
	.width_(8)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

	Pen.addRect(Rect(300,529, 150, 60))
	.width_(8)
	.strokeColor_(Color.fromHexString("#78cdd7"))
	.stroke;

};

//panner---------------------------------------------------------------------------

wp = Window.new("spanner", Rect(panWinRL,panWinUpDown,panWinWidth,panWinHeight), false)
.front
.alwaysOnTop_(true)
//.background_(Color.rand)
.drawFunc = {
    Pen.addRect(wp.view.bounds.insetBy(0))
	.fillRadialGradient( (panWinWidth/2)@(panWinHeight),(panWinWidth/2)@(panWinHeight),80,600,
		Color.fromHexString("#05668d"), Color.fromHexString("#78cdd7"))
	.addOval(Rect((panWinWidth/2)-20,panWinHeight-20,40,40))
	.color_(Color.white)
    .fill;
	//i1.tileInRect(Rect(marg,marg,120,120),nil,2,1.0);
};


~angPos = Array2D.new(numOfPoints,2);
v = UserView(wp,Rect(0,0,height,width));

v.drawFunc = {

	"CIAO".postln;
	for (0, numOfPoints-1, {
		arg i;
		var angle, distance,angle01,distance01;
		i.postln;
		pos.at(i,0).postln;
		Pen.fillColor = Color.black;
		Pen.strokeColor = Color.white;
		"CIAO1".postln;
		//Pen.addArc((pos.at(i,0))@(pos.at(i,1)),elRadius, 0,2pi);
		Pen.drawImage( (pos.at(i,0)-17)@(pos.at(i,1)-17), image, operation: 'sourceOver', opacity:1);
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
		if((~angPos[0,0]>=1),{~angPos[0,0] = 1});
		p.set(\radius,~angPos[0,0]);
	v.refresh;

	}
	)
};


// sections----------------------------------------------------

w1 = CompositeView(w,Rect(marg,marg,sectWinWidth,sectWinHeight));
//.background_(Color.new255(30,144,255));

w2 = CompositeView(w,Rect(marg,(2*marg)+sectWinHeight,sectWinWidth,sectWinHeight));
//.background_(Color.new255(30,144,255));

w3 = CompositeView(w,Rect(marg,(3*marg)+(2*sectWinHeight),sectWinWidth,sectWinHeight));
//.background_(Color.new255(30,144,255));

w4 = CompositeView(w,Rect(marg,(4*marg)+(3*sectWinHeight),sectWinWidth,sectWinHeight));
//.background_(Color.new255(30,144,255));


//scope%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bufFire = Buffer.alloc(s, 1024, 1);
~scopefire = ScopeView(w1, Rect(275,35, 150, 60)).resize_(5).style_(0).fill_(false).waveColors = [Color.fromHexString("#78cdd7"), Color.green];
~scopefire.bufnum = bufFire.bufnum;
~scopefire.server_(s);
~scopefire.start;

bufWolf = Buffer.alloc(s, 1024, 1);
~scopewolf = ScopeView(w2, Rect(275,35, 150, 60)).resize_(5).style_(0).fill_(false).waveColors = [Color.fromHexString("#78cdd7"), Color.green];
~scopewolf.bufnum = bufWolf.bufnum;
~scopewolf.server_(s);
~scopewolf.start;

bufFrog = Buffer.alloc(s, 1024, 1);
~scopefrog = ScopeView(w3, Rect(275,35, 150, 60)).resize_(5).style_(0).fill_(false).waveColors = [Color.fromHexString("#78cdd7"), Color.green];
~scopefrog.bufnum = bufFrog.bufnum;
~scopefrog.server_(s);
~scopefrog.start;

bufStep = Buffer.alloc(s, 1024, 1);
~scopestep = ScopeView(w4, Rect(275,35, 150, 60)).resize_(5).style_(0).fill_(false).waveColors = [Color.fromHexString("#78cdd7"), Color.green];
~scopestep.bufnum = bufStep.bufnum;
~scopestep.server_(s);
~scopestep.start;

//SYNTHDEFS

SynthDef(\PassettiNeve, { |out, gate = 1, amp = 1, envbuf, hpfreq = 2000,speed = 1|
    var center,sig2,hpf,verb,shf,lpf, sig, a;
	a = Buffer.readChannel(s,~srcPath,channels:[0]);
	sig2 = GrainBuf.ar(1,Impulse.ar(speed),0.4,a,1,0.34,2,0);
	sig = sig2 * BrownNoise.ar(1,0);
	verb = FreeVerb.ar(sig,0.2);
	shf = PitchShift.ar(verb,0.2,0.2);
	center = Pan2.ar(shf,0,1);
	hpf = HPF.ar(center,hpfreq);
	lpf = LPF.ar(hpf,6000)*20;
    Out.ar(out,lpf);
}).add;

SynthDef(\scoping,{
	arg bus, buffy,outBus=0,amp=1;
	var in;
	in = In.ar(bus,1)*amp;
	ScopeOut2.ar(in, buffy);
	Out.ar(outBus,In.ar(bus,1));
}).add;

SynthDef(\s1, {arg bus;
	           Out.ar(bus, SinOsc.ar(100,0.0,0.5))

}).add;

// LABEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

~labeltitle = StaticText(w, Rect((winWidth/2)-(200/2),15,200,titleHeight))
.string_("Ti puzza l'ano, by Ric")
.align_(\center)
.font_(Font("Eras Bold ITC"/*"Cooper Black""Eras Bold ITC""Harlow Solid Italic""Matura MT Script Capitals""Swis721 BlkEx BT"*/, 15).boldVariant)
.stringColor_(Color.black)
.background_(Color.white);

//FIRE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

~labelFire = StaticText(w1, Rect(20,0,titleWidth,titleHeight))
.string_("fire")
.align_(\center)
.font_(Font("Eras Bold ITC", 18).boldVariant)
.background_(Color.white);

~knobLabelWood= StaticText(w1, Rect(3*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("wood")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobWood = Knob(w1, Rect(3*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.color_([
	Color.fromHexString("#78cdd7"),
	Color.white,
	Color.black,
	Color.red
])
.mode_(\vert)
.action_({
	arg wood;
	~numberboxWood.value_(wood.value.linlin(0,1,50,100));
});

~numberboxWood = NumberBox(w1, Rect(3*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg wood;
    ~knobWood.valueAction_(wood.value.linlin(50,100,0,1));
});

~knobLabelPanFire= StaticText(w1, Rect(36*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("right-left")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobPanFire = Knob(w1, Rect(36*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

~knobLabelDistFire= StaticText(w1, Rect(42*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("distance")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobDistFire = Knob(w1, Rect(42*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

Button.new(w1, Rect(48*knobIntraDist,40,60,knobDim))
.states_([
    ["PLAY", Color.black, Color.fromHexString("#78cdd7")],
    ["STOP",Color.white, Color.red(0.5)]
]).action_({ |b| QtGUI.palette = if(b.value == 0) });


//WOLF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

~labelWolf = StaticText(w2, Rect(20,0,titleWidth,titleHeight))
.string_("Wolf")
.align_(\center)
.font_(Font("Eras Bold ITC", 18).boldVariant)
.background_(Color.white);

~knobLabelLenght= StaticText(w2, Rect(3*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("lenght")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobLenght = Knob(w2, Rect(3*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg lenght;
	~numberboxLenght.value_(lenght.value.linlin(0,1,50,100));
});

~numberboxLenght = NumberBox(w2, Rect(3*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg lenght;
    ~knobLenght.valueAction_(lenght.value.linlin(50,100,0,1));
});

~knobLabelGrain= StaticText(w2, Rect(8*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("grain")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobGrain = Knob(w2, Rect(8*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg grain;
	~numberboxGrain.value_(grain.value.linlin(0,1,50,100));
});

~numberboxGrain = NumberBox(w2, Rect(8*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg grain;
    ~knobGrain.valueAction_(grain.value.linlin(50,100,0,1));
});

~knobLabelOcc = StaticText(w2, Rect(12*knobIntraDist,1.1*marg,1.5*knobLabelWidth,20))
.string_("occurrance")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobOcc = Knob(w2, Rect(13*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg occ;
	~numberboxOcc.value_(occ.value.linlin(0,1,50,100));
});

~numberboxOcc = NumberBox(w2, Rect(13*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg occ;
    ~knobOcc.valueAction_(occ.value.linlin(50,100,0,1));
});

~knobLabelPanWolf= StaticText(w2, Rect(36*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("right-left")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobPanWolf = Knob(w2, Rect(36*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

~knobLabelDistWolf= StaticText(w2, Rect(42*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("distance")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobDistWolf = Knob(w2, Rect(42*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

Button.new(w2, Rect(48*knobIntraDist,40,60,knobDim))
.states_([
    ["PLAY", Color.black, Color.fromHexString("#78cdd7")],
    ["STOP",Color.white, Color.red(0.5)]
]).action_({ |b| QtGUI.palette = if(b.value == 0) });



//FROG%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

~labelFrog = StaticText(w3, Rect(20,0,titleWidth,titleHeight))
.string_("Frog")
.align_(\center)
.font_(Font("Eras Bold ITC", 18).boldVariant)
.background_(Color.white);

~knobLabel= StaticText(w3, Rect(3*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("boh1")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knob = Knob(w3, Rect(3*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg boh1;
	~numberbox.value_(boh1.value.linlin(0,1,50,100));
});

~numberbox = NumberBox(w3, Rect(3*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg boh1;
    ~knob.valueAction_(boh1.value.linlin(50,100,0,1));
});

~knobLabel= StaticText(w3, Rect(8*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("boh2")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knob = Knob(w3, Rect(8*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg boh2;
	~numberbox.value_(boh2.value.linlin(0,1,50,100));
});

~numberbox = NumberBox(w3, Rect(8*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg boh2;
    ~knob.valueAction_(boh2.value.linlin(50,100,0,1));
});

~knobLabel = StaticText(w3, Rect(12*knobIntraDist,1.1*marg,1.5*knobLabelWidth,20))
.string_("boh3")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knob = Knob(w3, Rect(13*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg boh3;
	~numberbox.value_(boh3.value.linlin(0,1,50,100));
});

~numberbox = NumberBox(w3, Rect(13*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg boh3;
    ~knob.valueAction_(boh3.value.linlin(50,100,0,1));
});

~knobLabelPanFrog= StaticText(w3, Rect(36*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("right-left")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobPanFrog = Knob(w3, Rect(36*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

~knobLabelDistFrog= StaticText(w3, Rect(42*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("distance")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobDistFrog = Knob(w3, Rect(42*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

Button.new(w3, Rect(48*knobIntraDist,40,60,knobDim))
.states_([
    ["PLAY", Color.black, Color.fromHexString("#78cdd7")],
    ["STOP",Color.white, Color.red(0.5)]
]).action_({ |b| QtGUI.palette = if(b.value == 0) });



//STEP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



~stepSynth = Synth.newPaused(\PassettiNeve,[\out,0]);
~labelStep = StaticText(w4, Rect(20,0,titleWidth,titleHeight))
.string_("Step")
.align_(\center)
.font_(Font("Eras Bold ITC", 18).boldVariant)
.background_(Color.white);

~knobLabelSpeed= StaticText(w4, Rect(3*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("Speed")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobSpeed = Knob(w4, Rect(3*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg speed;
	~numberboxSpeed.value_(speed.value.linlin(0,1,1,2));
	~stepSynth.set(\speed,~knobSpeed.value.linlin(0,1,1,2));

});

~numberboxSpeed = NumberBox(w4, Rect(3*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
.value_(1)
.align_(\center)
.action_({
	arg speed;
    ~knobSpeed.valueAction_(speed.value.linlin(50,100,0,1));
});

~knobLabelSnowy= StaticText(w4, Rect(7*knobIntraDist,1.1*marg,1.5*knobLabelWidth,20))
.string_("Snow/Dirt")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobSnowy = Knob(w4, Rect(8*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"))
.action_({
	arg snowy;
	~numberboxSnowy.value_(snowy.value.linlin(0,1,200,2000));
	~stepSynth.set(\hpfreq,~knobSnowy.value.linlin(0,1,200,2000));
});

~numberboxSnowy = NumberBox(w4, Rect(8*knobIntraDist,(knobIntraDist)+knobDim+(1.7*marg),numBoxWidth,numBoxHeight))
.value_(200)
.align_(\center)
.action_({
	arg snowy;
    ~knobSnowy.valueAction_(snowy.value.linlin(200,2000,0,1));

});


~knobLabelPanStep= StaticText(w4, Rect(36*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("right-left")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobPanStep = Knob(w4, Rect(36*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

~knobLabelDistStep= StaticText(w4, Rect(42*knobIntraDist,1.1*marg,knobLabelWidth,20))
.string_("distance")
.align_(\center)
.font_(Font("arial", 12).boldVariant)
.stringColor_(Color.white);
//.background_(Color.rand);

~knobDistStep = Knob(w4, Rect(42*knobIntraDist,50,knobDim,knobDim))
.background_(Color.fromHexString("#78cdd7"));
//.action

Button.new(w4, Rect(48*knobIntraDist,40,60,knobDim))
.states_([
    ["PLAY", Color.black, Color.fromHexString("#78cdd7")],
    ["STOP",Color.white, Color.red(0.5)]
]).action_(
	{ |b| QtGUI.palette = if(b.value == 0);
		if(b.value == 0,
			{
				~stepSynth.run(false);
				postln("stepsynth true");
		},
			{
				~stepSynth.run(true);
				postln("stepsynth flase");
			}
		);
});

{Synth(\scoping, [\buffy, bufFire.bufnum, \bus, 5,\outBus,10])}.defer(0.1);
{Synth(\scoping, [\buffy, bufWolf.bufnum, \bus, 5,\outBus,10])}.defer(0.1);
{Synth(\scoping, [\buffy, bufFrog.bufnum, \bus, 5,\outBus,10])}.defer(0.1);
{Synth.after(~stepSynth,\scoping, [\buffy, bufStep.bufnum, \bus, 0,\outBus,0,\amp,8])}.defer(0.1);

{h = Synth(\s1, [\bus, 5,])}.defer(0.2);

//{ |out, gate = 1, amp = 1, envbuf, hpfreq = 2000,speed = 1|


/*
f = SoundFile.new;
f.openRead("C:/Users/Alberto/Documents/università/MAGISTRALE/corsi/CM-LANGUAGE AND SYSTEMS/progetto/group5-HW-SC-PLAS/1.wav");
~soundview = SoundFileView(w1, Rect(350,30, 150, 90))
.soundfile = f;

~soundview.read()
.timeCursorOn_(false)
.timeCursorColor_(Color.red)
.timeCursorPosition_(2050)
.drawsWaveForm_(true)
.gridOn_(false)
.gridResolution = 0.01;
*/
//SLIDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
~slider = Slider(w, Rect(50,50,150,20))
.background_(Color.rand)
.thumbSize_(50)
.knobColor_(Color.rand)
//.mouseOverAction_
.action_({
	arg x;
	var expctrl;
	expctrl = x.value.linexp(0,1,50,1000);
	s.set(\freq, expctrl);
	~numberbox.value_(x.value.linexp(0,1,50,1000));
});

~rangeslider = RangeSlider(w, Rect(50,30,150,20))
.background_(Color.rand)
.knobColor_(Color.rand)
//.mouseOverAction_
.action_({

});

*/

//ALTRO-----------------------

/*
~obj= MultiSliderView(w, Rect(100,100,90,90))
.size_(4);

~obj1= Slider2D(w, Rect(200,150,90,90))
.background_(Color.green)
.knobColor_(Color.green)
.setXY(0.1, 0.1)
.activex_()
.activey_
.action_({
	|sl|
	s.set(\freq, sl.x,\amp,sl.y);
});
*/

//f = SoundFile.new;
//f.openRead(Platform.C +/+ "/Desktop/1.wav");
//~soundview = SoundFileView(w, Rect(10,250, 250, 90))
//.soundfile = f;

//~soundview.read(0, f.numFrames)
//.timeCursorOn = true;
//.timeCursorColor = Color.red
//.timeCursorPosition = 2050
//.drawsWaveForm = true
//.gridOn = true;
//.gridResolution = 0.2;



)
s.plotTree;