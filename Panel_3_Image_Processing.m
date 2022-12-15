(* ::Package::{1100,897}::{{105,Automatic},{Automatic,Automatic}}:: *)

(* ::Input::Initialization:: *)
ImageProcessing= Function[{},

Panel[
Row[{
Panel[
Column[{
Style["Image Processing", "Title", 20, sectioncolor],
" ",
Style["Choose folder containing scan records", 14,Black],
Row[{ff=GetFolders[NotebookDirectory[]<>"Measurements/"];
Dynamic[PopupMenu[Dynamic[folder],ff]],
Button[Image[refresh],
ff= GetFolders[NotebookDirectory[]<>"Measurements/"],
Appearance->None
]
}],
" ",
Column[{
Column[{
Column[{
Row[{Style[Text["Moving Avarage Size (Number): "],14],Dynamic[MovAv]}],
Slider[Dynamic[MovAv],{10,500,10}]
}],
"",
Column[{
Row[{Style[Text["Laser Pulse Frequency (Hz): "],14],Dynamic[CenterFreq]}],
Slider[Dynamic[CenterFreq],{1,20000,1}]
}],
"",
Column[{
Row[{Style[Text["Filter Bandwidth (Hz): "],14],Dynamic[Bandwidth]}],
Slider[Dynamic[Bandwidth],{1,CenterFreq,1}]
}]
}],
""
}],
Row[{
Button["Start",
conf=Import[NotebookDirectory[]<>"main.conf"][[;;,#]]&/@{1,2};
confassoc=AssociationThread[conf[[1]],conf[[2]]];

CenterFreq=ToExpression[confassoc["LaserPulseFrequency"]];
Bandwidth=ToExpression[confassoc["FrequencyGap"]];
 MovAv=ToExpression[confassoc["MovingAvarage"]];

im=False;
status=Style["Started", 14,Black];
imglist={};
resamplingC=100;
filename=folder<>"/";
{dx,dy}=Import[NotebookDirectory[]<>"Measurements/"<>filename<>"dxdy.mx"];
recstop=Range[3,dy*3,3];

Do[
If[im,status=Style["Stopped", 14,Black];Break[]];
progress=Round[((iii*100.)/dy),0.1];
progresss=Style[ToString[progress], 14,Black];

pth=NotebookDirectory[] <>"Measurements/"<> filename<>ToString[recstop[[iii]]]<>".wav";
signalout=Import[pth];


bp=BandpassFilter[signalout,{Quantity[CenterFreq-Bandwidth,"Hertz"],Quantity[CenterFreq+Bandwidth,"Hertz"]}];
data=Abs[ArrayResample[AudioData[bp][[1]],50000]];

ll=Length[data];
half=Floor[ll/2];
fw=data[[;;half]];
bk=Reverse[data[[half+1;;]]];

ofset=Round[Length[fw]*0.05];

out1=MovingAverage[fw[[ofset;;-ofset]],MovAv];
out2=MovingAverage[bk[[ofset;;-ofset]],MovAv];

AppendTo[imglist,{out1,out2}],
{iii,Range[2,dy]}
];

imglistFW=imglist[[;;,1]];
imglistBK=imglist[[;;,2]];

resssBK=ImageResize[Image[imglistBK],{400,400}] //ImageAdjust;
resssFW=ImageResize[Image[imglistFW],{400,400}] //ImageAdjust;
resss=ImageAdd[resssFW,resssFW];
mm=MinMax[resss];
ires=(resss-mm[[1]])*(1/(mm[[2]]-mm[[1]]));
OutImage=Sharpen[ImageResize[Colorize[ires,ColorFunction->"SunsetColors"],{300,300}]]//ImageAdjust;
,ImageSize->{70,40},Method->"Queued"],

Button["STOP",
im=True;
status=Style["Stopped", 14,Black];
,Method->"Preemptive",ImageSize->{70,40}
],

Button["Save",
confassoc["LaserPulseFrequency"]=CenterFreq;
confassoc["FrequencyGap"]=Bandwidth;
confassoc["MovingAvarage"]=MovAv;
conflist={Keys[confassoc //Normal][[#]],Values[confassoc //Normal][[#]]}&/@Range[1,Length[conf[[1]]]];
Export[NotebookDirectory[]<>"main.conf",conflist,"CSV"];,
ImageSize->{70,40}]
}],
Row[{Style["Status: ", 14,Black],Dynamic[Refresh[status,UpdateInterval->0]]}],
Row[{Style["Progress: ", 14,Black],Dynamic[Refresh[progresss,UpdateInterval->0]],Style[" %", 14,Black]}]

}],
ImageSize->{350,500}],

Panel[Dynamic[Refresh[ImageRotate[OutImage,90Degree],UpdateInterval->0]],
ImageSize->{320,500}]
}]
]
];
ImageProcessing[]


