s.boot;
(
SynthDef(\convRev, {
	arg outBus=[0,1], inBus=[0,1], mix=1, val=1,fftsize= 2048,irSpctrmLNum,irSpctrmRNum;
	var input, output, conv;

	input= In.ar(inBus,2);
	conv = PartConv.ar (
			input,
			fftsize,
			[irSpctrmLNum, irSpctrmRNum],
			0.2 // Adjust the number to get a proper amplitude.
		);
		//mix =(in * 0.5) + (conv * 0.5); mix!
		Out.ar(outBus, conv);

}).add;

)

(
{
	var convEl, conv, irL, irR, convTime, irSpctrmL,irSpctrmR,fftsize= 2048,bufsizeL,bufsizeR;


	convEl = thisProcess.nowExecutingPath.dirname +/+ "buffer/BIGSKY-01.wav";
	irL= Buffer.readChannel(s,convEl,channels:0); // IR left
	irR= Buffer.readChannel(s,convEl,channels:1); // IR right

	s.sync;
	bufsizeL= PartConv.calcBufSize(fftsize, irL);
	irSpctrmL= Buffer.alloc(s, bufsizeL, 1);
	irSpctrmL.preparePartConv(irL, fftsize);

	bufsizeR= PartConv.calcBufSize(fftsize, irR);
	irSpctrmR= Buffer.alloc(s, bufsizeR, 1);
	irSpctrmR.preparePartConv(irR, fftsize);
	s.sync;
	irL.free; irR.free;
	Synth(\convRev,[\irSpctrmLNum,irSpctrmL,\irSpctrmRNum,irSpctrmR])



}.play

)