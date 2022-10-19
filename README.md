# Scanning Microscope Controller 

Basic scanning stage controller which consists of the following parts,

i) USB-Serial device including micro stage and laser driver circuits (Arduino Uno & two step-motor drivers are used in the prototype) 

ii) Platform-independent stage & laser controller interface based on Wolfram, Mathematica

iii) Utulity for dynamic measurement of input signal via mic input of the PC and external amplifier. Acquired signal is saved as audio file.

iv) Image processing tool including signal-filtering based on various methods such as band-pass, moving avarage, etc., and constraction of final result by processing audio signal into two-dimensional graphic of the measured sample.

The whole project is still under development.

So far, scanning laser microscopy as well as magneto-optical scanning Kerr microscopy have been successfully realized.

The following youtube link shows the first working version of the system,

https://www.youtube.com/watch?v=o69tt4DNoqU

***

Prerequisites: Wolfram Engine (Free for developers) or Mathematica must be installed.

Usage: Run Create_Controller_Palette.nb, that will create Mathematica Palette app like shown below.

To do: Control circuit diagram will be uploaded.

![alt text](https://github.com/canyesil/Scanning_Microscope_Controller/blob/main/App.png?raw=true)

