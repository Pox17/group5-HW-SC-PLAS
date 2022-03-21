(
var w = Window("arcTo", Rect(100, 200, 300, 300)).front;
var r= 15;
var xStart = 10, yStart = 10;
var width = 250;
var height = 200;
var radius = height /2;
var elRadius = 5;
var panSlider;
var alpha2 = 0;
w.drawFunc = { |v|
    Pen.fillColor = Color.black;
    Pen.strokeColor = Color.red;

    Pen.moveTo(xStart@yStart);
	Pen.lineTo((xStart+width)@yStart);
	Pen.lineTo((xStart+width)@(yStart+height));
	Pen.lineTo(xStart@(yStart+height));
    Pen.lineTo(xStart@yStart);
	Pen.fillStroke;
	Pen.addArc((xStart+(width/2))@(yStart+(height-20)),radius, 0*pi,-pi);
	Pen.stroke;
	Pen.fillColor = Color.green;
	Pen.strokeColor = Color.green;
	Pen.addArc(((xStart+(width/2))-radius)@(yStart+(height-20)),elRadius, 0,2pi);
	Pen.fillStroke;
	Pen.fillColor = Color.blue;
	Pen.strokeColor = Color.blue;
	Pen.addArc(((xStart+(width/2)+(radius*(panSlider.value/2).sinPi)))@(yStart+(height-20)-(radius*((panSlider.value/2).cosPi))),elRadius, 0,2pi);
	Pen.fillStroke;
	j = ControlSpec.new(-1, 1, \lin);

};
panSlider = EZSlider(parent:w, bounds:Rect(200,10,150,100), label:"pan", controlSpec:j, initVal: 0);
panSlider.action_({
	// specify later
	panSlider.value.postln;
		//x.set(\pan, panSlider.value);
	w.refresh;
});
)