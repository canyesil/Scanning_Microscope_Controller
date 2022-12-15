(* ::Package:: *)

(* ::Input::Initialization:: *)
processCC=Function[{LaserH,step,vecx,vecy,Nstepx,Nstepy},
comm=StringJoin[ToString[LaserH],vecx,ToString[Nstepy*step],"m2",vecy,ToString[Nstepx*step],"\n"];
gap=(Nstepx+Nstepy)*step;
{comm,gap}
];

processC=Function[{las,stp,dimx,dimy},
commgap=Table[{processCC[las,stp,"r","r",dimx,0],processCC[las,stp,"r","l",dimx,0],processCC[las,stp,"r","r",0,1]},dimy];
commn=Flatten[commgap,1][[;;,1]];
gapn=Flatten[commgap,1][[;;,2]];
{commn,gapn}
];

process2=Function[{dim,cmretto},
pos=-1*{Round[dim[[1]]/2],Round[dim[[2]]/2]};
poses=Position[cmretto,0];
commands=Partition[Flatten[Table[Join[{{1,0}},Join[Join[Table[{0,1},dim[[2]]],{{1,0}}],Join[Table[{0,-1},dim[[2]]]]]],Round[dim[[1]]/2]]],2];
pose=Accumulate[commands];
LaserOn=Table[If[MemberQ[poses,pose[[X]]],1,0],{X,1,Length[pose]}];
lines={};
pos={0,0};
For[i=1,i<Length[commands],i++,
pos+=commands[[i]];
If[LaserOn[[i]]==1,
AppendTo[lines,pos];
pos={0,0};
];
];
lines
];

process3=Function[{lines,LaserH,step},
LaserOnR=Table[If[lines[[XX,1]]==0&&Abs[lines[[XX,2]]]<=1,1,0],{XX,1,Length[lines]}];
dir=<|-1->"l",1->"r",0->"r"|>;
comm=StringPadLeft[ToString[LaserH*LaserOnR[[#]]],3,"0"]<>dir[Sign[lines[[#,1]]]]<>ToString[step*Abs[lines[[#,1]]]]<>"m2"<>dir[Sign[lines[[#,2]]]]<>ToString[step*Abs[lines[[#,2]]]]<>"\n"&/@Range[1,Length[lines]];
gap=step*Abs[lines[[#,1]]]+step*Abs[lines[[#,2]]]&/@Range[1,Length[lines]];
{comm,gap}
];
commandget=Function[{comX,comY},
dir=<|-1->"l",1->"r",0->"r"|>;
comm="127"<>dir[Sign[comX]]<>ToString[step*Abs[comX]]<>"m2"<>dir[Sign[comY]]<>ToString[step*Abs[comY]]<>"\n"];
GetFiles=Function[{folderpath,prefix},
pro = StartProcess[$SystemShell];
command="ls "<>folderpath<>prefix<>"*";
WriteLine[pro,command];
Pause[0.2]; 
r = ReadString[pro, EndOfBuffer];
Pause[0.2];
rm = StringSplit[r, "\n"];
WriteLine[pro, "exit"];
rm
];
GetFolders=Function[{folderpath},
pro = StartProcess[$SystemShell];
command="ls "<>folderpath;
WriteLine[pro,command];
Pause[0.2]; 
r = ReadString[pro, EndOfBuffer];
Pause[0.2];
rm = StringSplit[r, "\n"];
WriteLine[pro, "exit"];
rm
];
