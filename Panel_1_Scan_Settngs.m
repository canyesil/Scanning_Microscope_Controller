(* ::Package::{1100,897}::{{Automatic,195},{Automatic,Automatic}}:: *)

(* ::Section:: *)
(**)


(* ::Input::Initialization:: *)
ScanSettings =
  Function[{},
    Panel[
      Row[
        {
          Panel[
            Column[
              {
                Style["Scanning Settings", "Title", 20, RGBColor[0.3490196078431372,0.349019607843137`,0.3529411764705882]],
                sldsample1 = Slider[Dynamic[dx], {2, 150, 2}],
                dx = 50;
                Row[{Style[Text["dx: "], 14], Dynamic[dx]}],
                sldsample2 = Slider[Dynamic[dy], {2, 150, 2}],
                dy = 50;
                Row[{Style[Text["dy: "], 14], Dynamic[dy]}],
                sldsample3 = Slider[Dynamic[ratio], {0.1, 3, 0.1}],
                ratio = 1;
                Row[{Style[Text["Magnification: "], 14], Dynamic[ratio
                  ]}],
                Row[
                  {
                    Button[
                      "Apply",
                      cmretto = Table[0, dx, dy];
                      img = Image[Table[{1., 1., 1.}, Round[dx * 3 * 
                        ratio], Round[dy * 3 * ratio]]];
                      dim = {dx, dy};
                      lines = process2[dim, cmretto];
                      plt = ListPlot[Accumulate[lines], AspectRatio ->
                         {dim}, PlotStyle -> PointSize[0.008], ImageSize -> 200, Frame -> None,
                         Axes -> None, FrameTicks -> None];
                      img = ImageResize[ImageRotate[Rasterize[plt], 0
                         * Degree], {Round[dx * 3 * ratio], Round[dy * 3 * ratio]}];
                      comngap = {comm, gap} = processC[LaserP, step, 
                        dx, dy];
                      Export[StringJoin[NotebookDirectory[], "commngap.mx"
                        ], comngap, "MX"];,
                      ImageSize -> {80, 27}
                    ],
                    Button[
                      "Reset",
                      ClearAll["Global`*"];
                      AudioStop[];
                      dx = 50;
                      dy = 50;
                      ratio = 1;
                      LaserP = 127;
                      step = 150;
                      path = StringJoin[NotebookDirectory[], "ControllerPalette.nb"
                        ];
                      SetDirectory[NotebookDirectory[]];
                      Import[StringJoin[NotebookDirectory[], "Functions.m"
                        ]];
                      img = Image[Table[{1., 1., 1.}, Round[dx * 3 * 
                        ratio], Round[dy * 3 * ratio]]];
                      Export[StringJoin[NotebookDirectory[], "dashed_area.png"
                        ], Framed[img]];
                      imgpath = StringJoin[NotebookDirectory[], "dashed_area.png"
                        ];
                      refresh = ImageResize[Import[StringJoin[NotebookDirectory[
                        ], "VistalCO_refresh_icon_2.png"]], {20, 20}];
                      inputDev = $DefaultAudioInputDevice;
                      fd = GetFiles["/dev/", "*usb*"];
                      ff = GetFolders[StringJoin[NotebookDirectory[],
                         "Measurements/"]];
                      conf = (Import[StringJoin[NotebookDirectory[], 
                        "main.conf"]][[1 ;; All, #1]]&) /@ {1, 2};
                      confassoc = AssociationThread[conf[[1]], conf[[
                        2]]];
                      CenterFreq = ToExpression[confassoc["LaserPulseFrequency"
                        ]];
                      Bandwidth = ToExpression[confassoc["FrequencyGap"
                        ]];
                      MovAv = ToExpression[confassoc["MovingAvarage"]
                        ];
                      If[onoff == 1,
                        onoff = 0;
                        DeviceClose[dev];
                      ];
                      c = Red;
                      OutImage = ConstantImage[0.6, {600, 600}];
                      status = Style["Ready", 14, Black];
                      progresss = Style["0", 14, Black];
                      progreS = Style["0", 14, Black];
                      ,
                      ImageSize -> {80, 27}
                    ]
                  }
                ]
              }
            ]
            ,
            ImageSize -> {250, 250}
          ]
          ,
          Panel[Dynamic[Refresh[img, UpdateInterval -> 0]], ImageSize
             -> {250, 250}]
        }
      ]
    ]
  ];

ScanSettings[]
