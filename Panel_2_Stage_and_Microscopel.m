(* ::Package::{1202,897}::{{Automatic,115},{Automatic,Automatic}}:: *)

(* ::Input::Initialization:: *)
DeviceSettings=Function[{},
Panel[
c=Red;

temp=Style["Device", 14,Black];
t=False;
Row[{
Panel[
Column[{
Style["USB-Serial Micro-Positioner", "Title", 20,sectioncolor],
"", 
 Row[{
Button[Image[refresh],
fd= GetFiles["/dev/","*usb*"],
Appearance->None
],
fd=GetFiles["/dev/","*usb*"];
Dynamic[PopupMenu[Dynamic[xrn],fd,ImageSize->{180,20}]],
"   ",
Button["ON",
c=c/. {Red->Green,Green->Red};
If[onoff==0,
dev = DeviceOpen["Serial", {xrn, "BaudRate" -> 115200}];
onoff=1,
DeviceClose[dev];
onoff=0;
]
,Background->Dynamic[Refresh[c,UpdateInterval->0]],ImageSize->{30,30},Appearance->"DialogBox"],
 " "
}],
" ",
      Column[{
"",
Style["Signal Input Device", "Title", 20,sectioncolor],
inputDev=$DefaultAudioInputDevice;
Dynamic[PopupMenu[Dynamic[inputDev],$AudioInputDevices]]
}],
"  ",
"  ",
Style["Scaning", "Title", 20, sectioncolor],
"",
LaserP=127;Row[{Style[Text["Laser Power(%): "],14],Dynamic[LaserP]}],
sldLaser=Slider[Dynamic[LaserP],{0,255,1}],
"",
step=150;Row[{Style[Text["Step interval (ms): "],14],Dynamic[step]}],
sldStep=Slider[Dynamic[step],{0,1000,10}],
"",
Row[{
Button["RUN",
t=False;
ddy=1;

fold="Signal_out_"<>StringReplace[DateString[],{" "->"_",":"->"-"}];
CreateDirectory[NotebookDirectory[]<>"Measurements/"<>fold];
Export[NotebookDirectory[]<>"Measurements/"<>fold<>"/dxdy.mx",{dx,dy}];
{comm, gap} = Import[NotebookDirectory[] <> "commngap.mx"];
temp=Style["Running... ", 14,Black];

astream=AudioStream[inputDev];
len=Length[comm];
recstart=Range[1,len,3];
recstop=Range[3,len,3];

For[ii = 1, ii <= len, ii++,
progreS=Style[ToString[((ii*100.)/len)], 14,Black];
If[MemberQ[recstop,ii],
AudioStop[];
aud=Audio[recording];
Export[NotebookDirectory[]<>"Measurements/"<>fold<>"/"<>ToString[ii]<>".wav",aud];
Pause[0.5];
];

If[t,temp=Style["Stopped", 14,Black];Break[]];
If[MemberQ[recstart,ii],
imgd=ImageData[img];
ddy+=3;
imgd[[ddy;;ddy+3]]=imgd[[ddy;;ddy+3]]*0;
img=Image[imgd];

recording=AudioRecord[astream]; 
];

 DeviceWriteBuffer[dev, comm[[ii]]];
 Pause[gap[[ii]] * 10^-3 + 0.2];
];
temp=Style["Finished", 14,Black];

,ImageSize->{70,40},Method->"Queued"],

Button["STOP",t=True;temp=Style["Stopped", 14,Black];AudioStop[];,Method->"Preemptive",ImageSize->{70,40}]
}],

Dynamic[Refresh[temp,UpdateInterval->0]],
Row[{Style["Progress: ", 14,Black],Dynamic[Refresh[progreS,UpdateInterval->0]],Style[" %", 14,Black]}]

}]
,ImageSize -> {340, 500}],
Panel[
Column[{
Style["Microscope Capture", 20,sectioncolor],
img0=ImageResize[Image[Table[0.3,300,300]],{300,240}];
c1=Red;
onoffC=0;
Row[{
Button[Image[refresh],
cam=$ImagingDevices,
Appearance->None
],
cam=$ImagingDevices;
Dynamic[PopupMenu[Dynamic[cam0],cam]],
"   ",
Button["ON",
c1=c1/. {Red->Green,Green->Red};
If[onoffC==0,
$DefaultImagingDevice=cam0;
onoffC=1,
onoffC=0;
],
Background->Dynamic[Refresh[c1,UpdateInterval->0]],ImageSize->{30,30},Appearance->"DialogBox"],
 " "
}],
Panel[
DynamicModule[{img=img0},Dynamic[If[onoffC==1,img=CurrentImage[RasterSize->{640,480},ImageSize->300],img=img0],UpdateInterval->1/10,TrackedSymbols->{}]],ImageSize -> {300, 240}],
"     ",
Column[{
Style["Stage Positioning", 20, sectioncolor],
Panel[
{x,y}={0,0};
tb= Table["      ",3,3];
tb[[1,2]]=Button["\[UpArrow]",x=0;y=1; DeviceWriteBuffer[dev, commandget[x,y]];Pause[step/1000.];];
tb[[2,1]]=Button["\[LeftArrow]",x=-1;y=0;DeviceWriteBuffer[dev, commandget[x,y]];Pause[step/1000.];];
tb[[2,3]]=Button["\[RightArrow]",x=1;y=0;DeviceWriteBuffer[dev, commandget[x,y]];Pause[step/1000.];];
tb[[3,2]]=Button["\[DownArrow]",x=0;y=-1;DeviceWriteBuffer[dev, commandget[x,y]];Pause[step/1000.];];
Column[{
Grid[tb],
Dynamic[Refresh[{x,y},UpdateInterval->0]]
}]
]
}]
}]
,ImageSize -> {300, 500}]
}]
,ImageSize -> {680, 500}]
];
DeviceSettings[]

