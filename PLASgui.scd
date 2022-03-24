s.boot

(

SynthDef(\oscprova,{
	arg freq = 440, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq,0,amp);
	Out.ar(0,sig);
}).add;
s = Synth(\oscprova);
)

(

//VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var f,wp,w1,w2,w3,w4,i1,i2,i3,i4,

// margin

marg = 25,

// main window dimension

winWidth = 750,
winHeight = 650,
winUpDown = 50,
winRL = 900,

panWinRL = 900,
panWinUpDown = 100,
panWinWidth = 300,
panWinHeight = 300,

// single section dimensions

sectWinWidth = winWidth-(2*marg),
sectWinHeight = (winHeight-(5*marg))/4,

// label
titleWidth = 80,
titleHeight = 20,

//knob dimension
knobDim = 30,
knobIntraDist = 10,

knobLabelWidth = knobDim,
knobLabelHeight = 10,

//numberbox dimension

numBoxWidth = knobDim,
numBoxHeight = 20;


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

//i1 = Image.new("C:/Users/Alberto/Desktop/wolf_1f43a.png"	);


Window.closeAll;

// main

w = Window.new("PLASgui",Rect(winRL,winUpDown,winWidth,winHeight), false)
.front
.alwaysOnTop_(true)
//.background_(Color.rand)
.drawFunc = {

    Pen.addRect(w.view.bounds.insetBy(0));
	Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.new255(255,255,255), Color.new255(135,206,250));
	//i1.tileInRect(Rect(marg,marg,sectWinWidth,sectWinHeight),nil,2,0.8);
	//i2.tileInRect(Rect(marg,(2*marg)+sectWinHeight,sectWinWidth,sectWinHeight),nil,2,1.0);
	//i3.tileInRect(Rect(marg,(3*marg)+(2*sectWinHeight),sectWinWidth,sectWinHeight),nil,2,1.0);
	//i4.tileInRect(Rect(marg,(4*marg)+(3*sectWinHeight),sectWinWidth,sectWinHeight),nil,2,1.0);

};
//.acceptsMouseOver=true;

//panner

wp = Window.new("spanner", Rect(panWinRL,panWinUpDown,panWinWidth,panWinHeight), false)
.front
.alwaysOnTop_(true)
//.background_(Color.rand)
.drawFunc = {
    Pen.addRect(wp.view.bounds.insetBy(0))
	.fillRadialGradient( (panWinWidth/2)@(panWinHeight),(panWinWidth/2)@(panWinHeight),50,400,
		Color.new255(0,0,102), Color.new255(135,206,250))
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
		if((~angPos[0,0]>=1),{~angPos[0,0] = 1});
		p.set(\radius,~angPos[0,0]);
	v.refresh;

	}
	)
};


// sections----------------------------------------------------

w1 = CompositeView(w,Rect(marg,marg,sectWinWidth,sectWinHeight))
.background_(Color.new255(30,144,255));

w2 = CompositeView(w,Rect(marg,(2*marg)+sectWinHeight,sectWinWidth,sectWinHeight))
.background_(Color.new255(30,144,255));

w3 = CompositeView(w,Rect(marg,(3*marg)+(2*sectWinHeight),sectWinWidth,sectWinHeight))
.background_(Color.new255(30,144,255));

w4 = CompositeView(w,Rect(marg,(4*marg)+(3*sectWinHeight),sectWinWidth,sectWinHeight))
.background_(Color.new255(30,144,255));

// LABEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//title labels----------------------------------------------------

~label= StaticText(w, Rect((winWidth/2)-(200/2),15,200,titleHeight))
.string_("plas  granular  synth")
.align_(\center)
.font_(Font("BigNoodleTitling", 25).boldVariant)
.background_(Color.white);

~label1= StaticText(w1, Rect(20,0,titleWidth,titleHeight))
.string_("fuoco")
.align_(\center)
.font_(Font("BigNoodleTitling", 18).boldVariant)
.background_(Color.white);

~label2= StaticText(w2, Rect(20,0,titleWidth,titleHeight))
.string_("lupo")
.align_(\center)
.font_(Font("BigNoodleTitling", 18).boldVariant)
.background_(Color.white);

~label3= StaticText(w3, Rect(20,0,titleWidth,titleHeight))
.string_("grilli/rane")
.align_(\center)
.font_(Font("BigNoodleTitling", 18).boldVariant)
.background_(Color.white);

~label4= StaticText(w4
	, Rect(20,0,titleWidth,titleHeight))
.string_("passi")
.align_(\center)
.font_(Font("BigNoodleTitling", 18).boldVariant)
.background_(Color.white);
//knob label section1 --------------------------------------------------

~knobLabelA= StaticText(w1, Rect(5*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("A")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelD= StaticText(w1, Rect(10*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("D")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelS= StaticText(w1, Rect(15*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("S")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelST= StaticText(w1, Rect(20*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("ST")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelR= StaticText(w1, Rect(25*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("R")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelPan= StaticText(w1, Rect(55*knobIntraDist,0.5*marg,knobLabelWidth,20))
.string_("PAN")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelDist= StaticText(w1, Rect(55*knobIntraDist,2.7*marg,knobLabelWidth,20))
.string_("DIST")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelVol= StaticText(w1, Rect(61*knobIntraDist,0.2*marg,2*knobDim,20))
.string_("VOL")
.align_(\center)
.font_(Font("arial", 15).boldVariant);
//.background_(Color.rand);


//knob label section2 -----------------------------------------------------

~knobLabelA= StaticText(w2, Rect(5*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("A")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelD= StaticText(w2, Rect(10*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("D")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelS= StaticText(w2, Rect(15*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("S")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelST= StaticText(w2, Rect(20*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("ST")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelR= StaticText(w2, Rect(25*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("R")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);


//knob label section3 ----------------------------------------------------

~knobLabelA= StaticText(w3, Rect(5*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("A")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelD= StaticText(w3, Rect(10*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("D")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelS= StaticText(w3, Rect(15*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("S")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelST= StaticText(w3, Rect(20*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("ST")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelR= StaticText(w3, Rect(25*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("R")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

//knob label section4 ----------------------------------------------------

~knobLabelA= StaticText(w4, Rect(5*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("A")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelD= StaticText(w4, Rect(10*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("D")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelS= StaticText(w4, Rect(15*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("S")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelST= StaticText(w4, Rect(20*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("ST")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

~knobLabelR= StaticText(w4, Rect(25*knobIntraDist,1.5*marg,knobLabelWidth,20))
.string_("R")
.align_(\center)
.font_(Font("arial", 13).boldVariant);
//.background_(Color.rand);

//NUMBERBOX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

//numberbox section1-----------------------------------------------

~numberboxA = NumberBox(w1, Rect(5*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxD = NumberBox(w1, Rect(10*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxS = NumberBox(w1, Rect(15*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxST = NumberBox(w1, Rect(20*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxR = NumberBox(w1, Rect(25*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

//numberbox section2---------------------------------------------

~numberboxA = NumberBox(w2, Rect(5*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxD = NumberBox(w2, Rect(10*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxS = NumberBox(w2, Rect(15*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxST = NumberBox(w2, Rect(20*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxR = NumberBox(w2, Rect(25*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

//numberbox section3----------------------------------------------

~numberboxA = NumberBox(w3, Rect(5*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxD = NumberBox(w3, Rect(10*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxS = NumberBox(w3, Rect(15*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxST = NumberBox(w3, Rect(20*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxR = NumberBox(w3, Rect(25*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

//numberbox section4----------------------------------------------

~numberboxA = NumberBox(w4, Rect(5*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxD = NumberBox(w4, Rect(10*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxS = NumberBox(w4, Rect(15*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxST = NumberBox(w4, Rect(20*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

~numberboxR = NumberBox(w4, Rect(25*knobIntraDist,(2*knobIntraDist)+knobDim+(2*marg),numBoxWidth,numBoxHeight))
//.value_(0)
.align_(\center)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});

//KNOB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//knob section 1--------------------------------------------------

~knobA = Knob(w1, Rect(5*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobD = Knob(w1, Rect(10*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobS = Knob(w1, Rect(15*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobST = Knob(w1, Rect(20*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobR = Knob(w1, Rect(25*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobPan = Knob(w1, Rect(55*knobIntraDist,1.4*marg,knobDim,knobDim))
.background_(Color.blue)
.action_({

});


~knobDist = Knob(w1, Rect(55*knobIntraDist,3.5*marg,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobVol = Knob(w1, Rect(61*knobIntraDist,27,2*knobDim,2*knobDim))
.background_(Color.blue);
//.action
//knob section 2------------------------------------------------------

~knobA = Knob(w2, Rect(5*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobD = Knob(w2, Rect(10*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobS = Knob(w2, Rect(15*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobST = Knob(w2, Rect(20*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobR = Knob(w2, Rect(25*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

//knob section 3------------------------------------------------------

~knobA = Knob(w3, Rect(5*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobD = Knob(w3, Rect(10*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobS = Knob(w3, Rect(15*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobST = Knob(w3, Rect(20*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobR = Knob(w3, Rect(25*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

//knob section 4------------------------------------------------------

~knobA = Knob(w4, Rect(5*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobD = Knob(w4, Rect(10*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobS = Knob(w4, Rect(15*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobST = Knob(w4, Rect(20*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action

~knobR = Knob(w4, Rect(25*knobIntraDist,65,knobDim,knobDim))
.background_(Color.blue);
//.action


//BUTTON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//section1---------------------------------------------------
Button.new(w1, Rect(61*knobIntraDist,3.7*marg,2.5*knobDim,30))
.states_([
    ["PLAY⏵", Color.white, Color.green(0.7)],
    ["STOP⏹",Color.white, Color.red(0.7)]
]).action_({ |b| QtGUI.palette = if(b.value == 0) });

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

/*
//KNOB ------------------------------------

~knob = Knob(w, Rect(250,50,knobdim,knobdim))
.background_(Color.green);
//.action

*/

//NUMBERBOX -------------------------------

/*
~numberbox = NumberBox(w, Rect(200,50,50,50))
.value_(100)
.action_({
	arg x;
    ~slider.valueAction_(x.value.explin(50,1000,0,1));
});
*/

//LABEL--------

/*
~label= StaticText(w, Rect(250,120,50,20))
.string_("knob1")
.background_(Color.rand);

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

/*(
var knobdim = 60;

Window.closeAll;
w = Window("nested",Rect(500,100,1060,570))
.front
.alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds,30@30, 30@30));

	c= Array.fill(3,{
		arg view;
	    view = CompositeView(w,1000@150)
		.background_(Color.rand);

		view.decorator_(FlowLayout(view.bounds, 15@15, 25@15
	));
	});
Array.fill([1, 9],{
	~knob = Knob(c[0], knobdim@knobdim)
	.background_(Color.green);
	//.action
},
{~label= StaticText(w, Rect(250,120,50,20))
.string_("knob1")
.background_(Color.rand);});
Array.fill(9,{
	~knob = Knob(c[1], knobdim@knobdim)
	.background_(Color.green);
	//.action
});
Array.fill(9,{
	~knob = Knob(c[2], knobdim@knobdim)
	.background_(Color.green);
	//.action
});

)
//KNOBS

knob1 = EZKnob(parent:w, bounds:Rect(10,10,100,100), label:"1", controlSpec:g, initVal:0.5);

knob1.action_({
	// specify later
	x.set(\mix, knob1.value);
});

knob2 = EZKnob(parent:w, bounds:Rect(150,10,100,100), label:"2", controlSpec:g, initVal:0.5);

knob2.action_({
	// specify later
	x.set(\mix, knob2.value);
});

knob3 = EZKnob(parent:w, bounds:Rect(300,10,100,100), label:"3", controlSpec:g, initVal:0.5);

knob3.action_({
	// specify later
	x.set(\mix, knob3.value);});

knob4 = EZKnob(parent:w, bounds:Rect(450,10,100,100), label:"4", controlSpec:g, initVal:0.5);

knob4.action_({
	// specify later
	x.set(\mix, knob4.value);
});

//KNOBS ENVELOPE

knobA = EZKnob(parent:w, bounds:Rect(600,10,100,100), label:"A", controlSpec:g, initVal:0.5);

knobA.action_({
	// specify later
	x.set(\mix, knobA.value);
});

knobD = EZKnob(parent:w, bounds:Rect(750,10,100,100), label:"D", controlSpec:g, initVal:0.5);

knobD.action_({
	// specify later
	x.set(\mix, knobD.value);
});

knobS = EZKnob(parent:w, bounds:Rect(900,10,100,100), label:"S", controlSpec:g, initVal:0.5);

knobS.action_({
	// specify later
	x.set(\mix, knobS.value);
});

knobST = EZKnob(parent:w, bounds:Rect(450,10,100,100), label:"ST", controlSpec:g, initVal:0.5);

knob4.action_({
	// specify later
	x.set(\mix, knobST.value);
});

knobR = EZKnob(parent:w, bounds:Rect(300,10,100,100), label:"S", controlSpec:g, initVal:0.5);

knobR.action_({
	// specify later
	x.set(\mix, knobR.value);
});





/*
x = QPalette.auto(Color.red(0.8), Color.red(0.5));
y = QPalette.auto(Color.cyan(1.4), Color.cyan(1.8));
p = QtGUI.palette;
QtGUI.palette = x;
w = Window.new("GUI Introduction").front;
w.onClose = {QtGUI.palette = p};
Button.new(w, Rect(10,10,100,30)).states_([
    ["Red", Color.black, Color.grey(0.7)],
    ["Cyan"]
]).action_({ |b| QtGUI.palette = if(b.value == 0){x}{y} });
ListView.new(w, Rect(10,50,200,100))
    .items_(["One","Two","Three"])
    .colors_([Color.grey(0.4),Color.grey(0.5),Color.grey(0.6)]);
Slider(w, Rect(10, 160, 200, 20));
RangeSlider(w, Rect(10, 190, 200, 20));

w = Window.new("GUI Introduction",Rect(200,200,200,70)).front;
a = [Font.defaultMonoFace, Font.defaultSansFace, Font.defaultSerifFace];
b = Button.new(w,Rect(10,10,180,50))
    .states_([["Monospace"],["Sans serif"],["Serif"]])
    .font_(a[0])
    .action_({|b| b.font = a[b.value]});


w = Window.new(bounds:Rect(200,200,200,50)).front;
b = Button.new(w,Rect(10,10,80,30)).states_([["Off"],["On"]]);
t = StaticText(w,Rect(100,10,90,30)).string_("Button released");
b.mouseDownAction = { t.string = "Button pressed" };
b.mouseUpAction = { t.string = "Button released" };
w.front;

*/


w.front;
)