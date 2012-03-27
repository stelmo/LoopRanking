function [sys,x0,str,ts] = TESFUNCo(t,x,u,flag)
%                Tennessee Eastman Process Control Test Problem
% 						        Re-Written in MATLAB 5.2 
%								         	by	
%     					Martin Braun and Daniel E. Rivera
%
%										  Box 876006
%						Control Systems Engineering Laboratory
%								Manufacturing Institute
%				Department of Chemical, Bio and Materials Engineering
%								Arizona State University
%								  Tempe, AZ 85287-6006
%									  Copyright 1999
%
% 						  	Please report any problems to:
% 								  mwbraun@imap4.asu.edu
%								  daniel.rivera@asu.edu
%
%  Please note, due to the way MATLAB executes the exp() function,
%  there are slight discrepancies in the output compared to the FORTRAN
%  version.
%
% ************************************************************************
%                Tennessee Eastman Process Control Test Problem
% 
%                     James J. Downs and Ernest F. Vogel
% 
%                   Process and Control Systems Engineering
%                        Tennessee Eastman Company
%                               P.O. Box 511
%                           Kingsport,TN  37662
% 
% ************************************************************************
%   Reference:
%     "A Plant-Wide Industrial Process Control Problem"
%     Presented at the AIChE 1990 Annual Meeting
%     Industrial Challenge Problems in Process Control,Paper #24a
%     Chicago,Illinois,November 14,1990
% 
%  Revised 4-4-91 to correct error in documentation of manipulated variables
%
%
% t -> time vector
% x -> state vector
% u -> input vector
% flag -> S-Function Flag
%
% See below for output description.
% 
%SFUNTMPL General M-file S-function template
%   With M-file S-functions, you can define you own ordinary differential
%   equations (ODEs), discrete system equations, and/or just about
%   any type of algorithm to be used within a Simulink block diagram.
%
%   The general form of an M-File S-function syntax is:
%       [SYS,X0,STR,TS] = SFUNC(T,X,U,FLAG,P1,...,Pn)
%
%   What is returned by SFUNC at a given point in time, T, depends on the
%   value of the FLAG, the current state vector, X, and the current
%   input vector, U.
%
%   FLAG   RESULT             DESCRIPTION
%   -----  ------             --------------------------------------------
%   0      [SIZES,X0,STR,TS]  Initialization, return system sizes in SYS,
%                             initial state in X0, state ordering strings
%                             in STR, and sample times in TS.
%   1      DX                 Return continuous state derivatives in SYS.
%   2      DS                 Update discrete states SYS = X(n+1)
%   3      Y                  Return outputs in SYS.
%   4      TNEXT              Return next time hit for variable step sample
%                             time in SYS.
%   5                         Reserved for future (root finding).
%   9      []                 Termination, perform any cleanup SYS=[].
%
%
%   The state vectors, X and X0 consists of continuous states followed
%   by discrete states.
%
%   Optional parameters, P1,...,Pn can be provided to the S-function and
%   used during any FLAG operation.
%
%   When SFUNC is called with FLAG = 0, the following information
%   should be returned:
%
%      SYS(1) = Number of continuous states.
%      SYS(2) = Number of discrete states.
%      SYS(3) = Number of outputs.
%      SYS(4) = Number of inputs.
%               Any of the first four elements in SYS can be specified
%               as -1 indicating that they are dynamically sized. The
%               actual length for all other flags will be equal to the
%               length of the input, U.
%      SYS(5) = Reserved for root finding. Must be zero.
%      SYS(6) = Direct feedthrough flag (1=yes, 0=no). The s-function
%               has direct feedthrough if U is used during the FLAG=3
%               call. Setting this to 0 is akin to making a promise that
%               U will not be used during FLAG=3. If you break the promise
%               then unpredictable results will occur.
%      SYS(7) = Number of sample times. This is the number of rows in TS.
%
%
%      X0     = Initial state conditions or [] if no states.
%
%      STR    = State ordering strings which is generally specified as [].
%
%      TS     = An m-by-2 matrix containing the sample time
%               (period, offset) information. Where m = number of sample
%               times. The ordering of the sample times must be:
%
%               TS = [0      0,      : Continuous sample time.
%                     0      1,      : Continuous, but fixed in minor step
%                                      sample time.
%                     PERIOD OFFSET, : Discrete sample time where
%                                      PERIOD > 0 & OFFSET < PERIOD.
%                     -2     0];     : Variable step discrete sample time
%                                      where FLAG=4 is used to get time of
%                                      next hit.
%
%               There can be more than one sample time providing
%               they are ordered such that they are monotonically
%               increasing. Only the needed sample times should be
%               specified in TS. When specifying than one
%               sample time, you must check for sample hits explicitly by
%               seeing if
%                  abs(round((T-OFFSET)/PERIOD) - (T-OFFSET)/PERIOD)
%               is within a specified tolerance, generally 1e-8. This
%               tolerance is dependent upon your model's sampling times
%               and simulation time.
%
%               You can also specify that the sample time of the S-function
%               is inherited from the driving block. For functions which
%               change during minor steps, this is done by
%               specifying SYS(7) = 1 and TS = [-1 0]. For functions which
%               are held during minor steps, this is done by specifying
%               SYS(7) = 1 and TS = [-1 -1].

%   Copyright (c) 1990-1998 by The MathWorks, Inc. All Rights Reserved.
%   $Revision: 1.12 $

%
% The following outlines the general structure of an S-function.
%
switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes(t);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3
    sys = mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  case { 2, 4, 9 },
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(t)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
%sizes = simsizes;

sizes.NumContStates  = 50;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 41;
sizes.NumInputs      = 32;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

%sys = simsizes(sizes);
sys = sizes;


%
% initialize the initial conditions
%
global XMEAS XMV YP0 NN YY IDV
  NN = 50;
  TIME = t;
  YY = zeros(50,1);
  YP = zeros(50,1);

  

%  TEINIT Subroutine injected into S-function 
%  Command lines for MATLAB:
%  clear all
%  global YY YP;
%  NN = 50;
%  TIME = 0;
%  YY = zeros(50,1);
%  YP = zeros(50,1);
%  TEINIT_3(NN,TIME,YY,YP)
%
%
%        Initialization
% 
%          Inputs:
% 
%            NN   = Number of differential equations
% 
%          Outputs:
% 
%            Time = Current time(hrs)
%            YY   = Current state values
%            YP   = Current derivative values
% 
%       DOUBLE PRECISION XMEAS,XMV

% global IDV 
%       DOUBLE PRECISION G
global G
%       DOUBLE PRECISION
%      .UCLR,UCVR,UTLR,UTVR,
%      .XLR,XVR,ETR,ESR,
%      .TCR,TKR,DLR,
%      .VLR,VVR,VTR,
%      .PTR,PPR,
%      .CRXR,RR,RH,
%      .FWR,TWR,QUR,HWR,UAR,
%      .UCLS,UCVS,UTLS,UTVS,
%      .XLS,XVS,ETS,ESS,
%      .TCS,TKS,DLS,
%      .VLS,VVS,VTS,
%      .PTS,PPS,
%      .FWS,TWS,QUS,HWS,
%      .UCLC,UTLC,XLC,
%      .ETC,ESC,TCC,DLC,
%      .VLC,VTC,QUC,
%      .UCVV,UTVV,XVV,
%      .ETV,ESV,TCV,TKV,
%      .VTV,PTV,
%      .VCV,VRNG,VTAU,
%      .FTM,
%      .FCM,XST,XMWS,
%      .HST,TST,SFR,
%      .CPFLMX,CPPRMX,CPDH,
%      .TCWR,TCWS,
%      .HTR,AGSP,
%      .XDEL,XNS,
%      .TGAS,TPROD,VST
global UCLR UCVR UTLR UTVR XLR XVR ETR ESR...
      TCR TKR DLR VLR VVR VTR PTR PPR CRXR RR RH FWR TWR QUR HWR UAR...
      UCLS UCVS UTLS UTVS XLS XVS ETS ESS TCS TKS DLS...
      VLS VVS VTS PTS PPS FWS TWS QUS HWS UCLC UTLC XLC...
      ETC ESC TCC DLC VLC VTC QUC UCVV UTVV XVV ETV ESV TCV TKV...
      VTV PTV VCV VRNG VTAU FTM FCM XST XMWS...
      HST TST SFR CPFLMX CPPRMX CPDH TCWR TCWS HTR AGSP...
      XDEL XNS TGAS TPROD VST IVST 
	  
 TCR = 0; % put in by MWB, since it is not defined in the program, just initialized.
 TCS = 0; % put in by MWB, since it is not defined in the program, just initialized.
 TCC = 0; % put in by MWB, since it is not defined in the program, just initialized.
 DLR = 0; % put in by MWB, since it is not defined in the program, just initialized.
 DLS = 0; % put in by MWB, since it is not defined in the program, just initialized.
 DLC = 0; % put in by MWB, since it is not defined in the program, just initialized.
 TCV = 0; % put in by MWB, since it is not defined in the program, just initialized.
 HST = zeros(13,1); % put in by MWB, since it is not defined in the program, just initialized.

%       DOUBLE PRECISION
%      .ADIST,
%      .BDIST,
%      .CDIST,
%      .DDIST,
%      .TLAST,
%      .TNEXT,
%      .HSPAN,
%      .HZERO,
%      .SSPAN,
%      .SZERO,
%      .SPSPAN
global ADIST BDIST CDIST DDIST TLAST TNEXT HSPAN...
      HZERO SSPAN SZERO SPSPAN IDVWLK
% 	  DOUBLE PRECISION
%      .AVP,BVP,CVP,
%      .AH,BH,CH,
%      .AG,BG,CG,
%      .AV,
%      .AD,BD,CD,
%      .XMW
global AVP BVP CVP AH BH CH AG BG CG AV...
      AD BD CD XMW
%       DOUBLE PRECISION YY(NN),
%      .YP(NN),
%      .TIME
      XMW(1,1) = 2.0;
      XMW(2,1) = 25.4;
      XMW(3,1) = 28.0;
      XMW(4,1) = 32.0;
      XMW(5,1) = 46.0;
      XMW(6,1) = 48.0;
      XMW(7,1) = 62.0;
      XMW(8,1) = 76.0;
      AVP(1,1) = 0.0;
      AVP(2,1) = 0.0;
      AVP(3,1) = 0.0;
      AVP(4,1) = 15.92;
      AVP(5,1) = 16.35;
      AVP(6,1) = 16.35;
      AVP(7,1) = 16.43;
      AVP(8,1) = 17.21;
      BVP(1,1) = 0.0;
      BVP(2,1) = 0.0;
      BVP(3,1) = 0.0;
      BVP(4,1) = -1444.0;
      BVP(5,1) = -2114.0;
      BVP(6,1) = -2114.0;
      BVP(7,1) = -2748.0;
      BVP(8,1) = -3318.0;
      CVP(1,1) = 0.0;
      CVP(2,1) = 0.0;
      CVP(3,1) = 0.0;
      CVP(4,1) = 259.0;
      CVP(5,1) = 265.5;
      CVP(6,1) = 265.5;
      CVP(7,1) = 232.9;
      CVP(8,1) = 249.6;
      AD(1,1) = 1.0;
      AD(2,1) = 1.0;
      AD(3,1) = 1.0;
      AD(4,1) = 23.3;
      AD(5,1) = 33.9;
      AD(6,1) = 32.8;
      AD(7,1) = 49.9; 
      AD(8,1) = 50.5;
      BD(1,1) = 0.0;
      BD(2,1) = 0.0;
      BD(3,1) = 0.0;
      BD(4,1) = -0.0700;
      BD(5,1) = -0.0957;
      BD(6,1) = -0.0995;
      BD(7,1) = -0.0191;
      BD(8,1) = -0.0541;
      CD(1,1) = 0.0;
      CD(2,1) = 0.0;
      CD(3,1) = 0.0;
      CD(4,1) = -0.0002;
      CD(5,1) = -0.000152;
      CD(6,1) = -0.000233;
      CD(7,1) = -0.000425;
      CD(8,1) = -0.000150;
      AH(1,1) = 1 * 10 ^ (-6);
      AH(2,1) = 1 * 10 ^ (-6);
      AH(3,1) = 1 * 10 ^ (-6);
      AH(4,1) = 0.960 * 10^(-6);
      AH(5,1) = 0.573 * 10^(-6);
      AH(6,1) = 0.652 * 10^(-6);
      AH(7,1) = 0.515 * 10^(-6);
      AH(8,1) = 0.471E-6;
      BH(1,1) = 0.0;
      BH(2,1) = 0.0;
      BH(3,1) = 0.0;
      BH(4,1) = 8.70E-9;
      BH(5,1) = 2.41E-9;
      BH(6,1) = 2.18E-9;
      BH(7,1) = 5.65E-10;
      BH(8,1) = 8.70E-10;
      CH(1,1) = 0.0;
      CH(2,1) = 0.0;
      CH(3,1) = 0.0;
      CH(4,1) = 4.81E-11;
      CH(5,1) = 1.82E-11;
      CH(6,1) = 1.94E-11;
      CH(7,1) = 3.82E-12;
      CH(8,1) = 2.62E-12;
      AV(1,1) = 1.0E-6;
      AV(2,1) = 1.0E-6;
      AV(3,1) = 1.0E-6;
      AV(4,1) = 86.7E-6;
      AV(5,1) = 160.E-6;
      AV(6,1) = 160.E-6;
      AV(7,1) = 225.E-6;
      AV(8,1) = 209.E-6;
      AG(1,1) = 3.411E-6;
      AG(2,1) = 0.3799E-6;
      AG(3,1) = 0.2491E-6;
      AG(4,1) = 0.3567E-6;
      AG(5,1) = 0.3463E-6;
      AG(6,1) = 0.3930E-6;
      AG(7,1) = 0.170E-6;
      AG(8,1) = 0.150E-6;
      BG(1,1) = 7.18E-10;
      BG(2,1) = 1.08E-9;
      BG(3,1) = 1.36E-11;
      BG(4,1) = 8.51E-10;
      BG(5,1) = 8.96E-10;
      BG(6,1) = 1.02E-9;
      BG(7,1) = 0;
      BG(8,1) = 0;
      CG(1,1) = 6.0E-13;
      CG(2,1) = -3.98E-13;
      CG(3,1) = -3.93E-14;
      CG(4,1) = -3.12E-13;
      CG(5,1) = -3.27E-13;
      CG(6,1) = -3.12E-13;
      CG(7,1) = 0;
      CG(8,1) = 0;
      YY(1,1) = 10.40491389;
      YY(2,1) = 4.363996017;
      YY(3,1) = 7.570059737;
      YY(4,1) = 0.4230042431;
      YY(5,1) = 24.15513437;
      YY(6,1) = 2.942597645;
      YY(7,1) = 154.3770655;
      YY(8,1) = 159.1865960;
      YY(9,1) = 2.808522723;
      YY(10,1) = 63.75581199;
      YY(11,1) = 26.74026066;
      YY(12,1) = 46.38532432;
      YY(13,1) = 0.2464521543;
      YY(14,1) = 15.20484404;
      YY(15,1) = 1.852266172;
      YY(16,1) = 52.44639459;
      YY(17,1) = 41.20394008;
      YY(18,1) = 0.5699317760;
      YY(19,1) = 0.4306056376;
      YY(20,1) = 7.9906200783E-03;
      YY(21,1) = 0.9056036089;
      YY(22,1) = 1.6054258216E-02;
      YY(23,1) = 0.7509759687;
      YY(24,1) = 8.8582855955E-02;
      YY(25,1) = 48.27726193;
      YY(26,1) = 39.38459028;
      YY(27,1) = 0.3755297257;
      YY(28,1) = 107.7562698;
      YY(29,1) = 29.77250546;
      YY(30,1) = 88.32481135;
      YY(31,1) = 23.03929507;
      YY(32,1) = 62.85848794;
      YY(33,1) = 5.546318688;
      YY(34,1) = 11.92244772;
      YY(35,1) = 5.555448243;
      YY(36,1) = 0.9218489762;
      YY(37,1) = 94.59927549;
      YY(38,1) = 77.29698353;
      YY(39,1) = 63.05263039;
      YY(40,1) = 53.97970677;
      YY(41,1) = 24.64355755;
      YY(42,1) = 61.30192144;
      YY(43,1) = 22.21000000;
      YY(44,1) = 40.06374673;
      YY(45,1) = 38.10034370;
      YY(46,1) = 46.53415582;
      YY(47,1) = 47.44573456;
      YY(48,1) = 41.10581288;
      YY(49,1) = 18.11349055;
      YY(50,1) = 50.00000000;
	  
for I = 1:12
      XMV(I,1) = YY(I + 38,1);
      VCV(I,1) = XMV(I,1);
      VST(I,1) = 2.0;
      IVST(I,1) = 0;
end
  
      VRNG(1,1) = 400.00;
      VRNG(2,1) = 400.00;
      VRNG(3,1) = 100.00;
      VRNG(4,1) = 1500.00;
      VRNG(7,1) = 1500.00;
      VRNG(8,1) = 1000.00;
      VRNG(9,1) = 0.03;
      VRNG(10,1) = 1000;
      VRNG(11,1) = 1200.0;
      VTR = 1300.0;
      VTS = 3500.0;
      VTC = 156.5;
      VTV = 5000.0;
      HTR(1,1) = 0.06899381054;
      HTR(2,1) = 0.05;
      HWR = 7060;
      HWS = 11138;
      SFR(1,1) = 0.99500;
      SFR(2,1) = 0.99100;
      SFR(3,1) = 0.99000;
      SFR(4,1) = 0.91600;
      SFR(5,1) = 0.93600;
      SFR(6,1) = 0.93800;
      SFR(7,1) = 5.80000E-02;
      SFR(8,1) = 3.01000E-02;
      XST(1,1) = 0.0;
      XST(2,1) = 0.0001;
      XST(3,1) = 0.0;
      XST(4,1) = 0.9999;
      XST(5,1) = 0.0;
      XST(6,1) = 0.0;
      XST(7,1) = 0.0;
      XST(8,1) = 0.0;
      TST(1,1) = 45;
      XST(1,2) = 0.0;
      XST(2,2) = 0.0;
      XST(3,2) = 0.0;
      XST(4,2) = 0.0;
      XST(5,2) = 0.9999;
      XST(6,2) = 0.0001;
      XST(7,2) = 0.0;
      XST(8,2) = 0.0;
      TST(2,1) = 45;
      XST(1,3) = 0.9999;
      XST(2,3) = 0.0001;
      XST(3,3) = 0.0;
      XST(4,3) = 0.0;
      XST(5,3) = 0.0;
      XST(6,3) = 0.0;
      XST(7,3) = 0.0;
      XST(8,3) = 0.0;
      TST(3,1) = 45;
      XST(1,4) = 0.4850;
      XST(2,4) = 0.0050;
      XST(3,4) = 0.5100;
      XST(4,4) = 0.0;
      XST(5,4) = 0.0;
      XST(6,4) = 0.0;
      XST(7,4) = 0.0;
      XST(8,4) = 0.0;
      TST(4,1) = 45;
      CPFLMX = 280275;
      CPPRMX = 1.3;
      VTAU(1,1) = 8;
      VTAU(2,1) = 8;
      VTAU(3,1) = 6;
      VTAU(4,1) = 9;
      VTAU(5,1) = 7;
      VTAU(6,1) = 5;
      VTAU(7,1) = 5;
      VTAU(8,1) = 5;
      VTAU(9,1) = 120;
      VTAU(10,1) = 5;
      VTAU(11,1) = 5;
      VTAU(12,1) = 5;
	  
for I=1:12
      VTAU(I,1) = VTAU(I,1) / 3600;
end
  
      G = 1431655765;
      XNS(1,1) = 0.0012;
      XNS(2,1) = 18.000;
      XNS(3,1) = 22.000;
      XNS(4,1) = 0.0500;
      XNS(5,1) = 0.2000;
      XNS(6,1) = 0.2100;
      XNS(7,1) = 0.3000;
      XNS(8,1) = 0.5000;
      XNS(9,1) = 0.0100;
      XNS(10,1) = 0.0017;
      XNS(11,1) = 0.0100;
      XNS(12,1) = 1.0000;
      XNS(13,1) = 0.3000;
      XNS(14,1) = 0.1250;
      XNS(15,1) = 1.0000;
      XNS(16,1) = 0.3000;
      XNS(17,1) = 0.1150;
      XNS(18,1) = 0.0100;
      XNS(19,1) = 1.1500;
      XNS(20,1) = 0.2000;
      XNS(21,1) = 0.0100;
      XNS(22,1) = 0.0100;
      XNS(23,1) = 0.250;
      XNS(24,1) = 0.100;
      XNS(25,1) = 0.250;
      XNS(26,1) = 0.100;
      XNS(27,1) = 0.250;
      XNS(28,1) = 0.025;
      XNS(29,1) = 0.250;
      XNS(30,1) = 0.100;
      XNS(31,1) = 0.250;
      XNS(32,1) = 0.100;
      XNS(33,1) = 0.250;
      XNS(34,1) = 0.025;
      XNS(35,1) = 0.050;
      XNS(36,1) = 0.050;
      XNS(37,1) = 0.010;
      XNS(38,1) = 0.010;
      XNS(39,1) = 0.010;
      XNS(40,1) = 0.500;
      XNS(41,1) = 0.500;
	  
for I=1:20
      IDV(I,1)=0;
end
  
      HSPAN(1,1) = 0.2;
      HZERO(1,1) = 0.5;
      SSPAN(1,1) = 0.03;
      SZERO(1,1) = 0.485;
      SPSPAN(1,1) = 0;
      HSPAN(2,1) = 0.7;
      HZERO(2,1) = 1.0;
      SSPAN(2,1) = 0.003;
      SZERO(2,1) = 0.005;
      SPSPAN(2,1) = 0;
      HSPAN(3,1) = 0.25;
      HZERO(3,1) = 0.5;
      SSPAN(3,1) = 10;
      SZERO(3,1) = 45;
      SPSPAN(3,1) = 0;
      HSPAN(4,1) = 0.7;
      HZERO(4,1) = 1.0;
      SSPAN(4,1) = 10;
      SZERO(4,1) = 45;
      SPSPAN(4,1) = 0;
      HSPAN(5,1) = 0.15;
      HZERO(5,1) = 0.25;
      SSPAN(5,1) = 10;
      SZERO(5,1) = 35;
      SPSPAN(5,1) = 0;
      HSPAN(6,1) = 0.15;
      HZERO(6,1) = 0.25;
      SSPAN(6,1) = 10;
      SZERO(6,1) = 40;
      SPSPAN(6,1) = 0;
      HSPAN(7,1) = 1;
      HZERO(7,1) = 2;
      SSPAN(7,1) = 0.25;
      SZERO(7,1) = 1.0;
      SPSPAN(7,1) = 0;
      HSPAN(8,1) = 1;
      HZERO(8,1) = 2;
      SSPAN(8,1) = 0.25;
      SZERO(8,1) = 1.0;
      SPSPAN(8,1) = 0;
      HSPAN(9,1) = 0.4;
      HZERO(9,1) = 0.5;
      SSPAN(9,1) = 0.25;
      SZERO(9,1) = 0.0;
      SPSPAN(9,1) = 0;
      HSPAN(10,1) = 1.5;
      HZERO(10,1) = 2.0;
      SSPAN(10,1) = 0.0;
      SZERO(10,1) = 0.0;
      SPSPAN(10,1) = 0;
      HSPAN(11,1) = 2.0;
      HZERO(11,1) = 3.0;
      SSPAN(11,1) = 0.0;
      SZERO(11,1) = 0.0;
      SPSPAN(11,1) = 0;
      HSPAN(12,1) = 1.5;
      HZERO(12,1) = 2.0;
      SSPAN(12,1) = 0.0;
      SZERO(12,1) = 0.0;
      SPSPAN(12,1) = 0;
	  
for I=1:12
      TLAST(I,1)=0;
      TNEXT(I,1)=0.1;
      ADIST(I,1)=SZERO(I,1);
      BDIST(I,1)=0;
      CDIST(I,1)=0;
      DDIST(I,1)=0;
end
  
      TIME=0.0;
	  
%     TEFUNC(NN,TIME,YY,YP);
%     TEFUNCVAL = TEFUNC(NN,TIME,YY,YP)
%
% Substitution of TEFUNC for call statement. MWB
%
%                Tennessee Eastman Process Control Test Problem
% 
%                     James J. Downs and Ernest F. Vogel
% 
%                   Process and Control Systems Engineering
%                        Tennessee Eastman Company
%                               P.O. Box 511
%                           Kingsport,TN  37662
% 
% ************************************************************************
%
% 						Re-Written in Matlab 5.0 
%									by	
%								Martin Braun
%
%			Department of Chemical, Bio and Materials Engineering
%						Arizona State University
%
% ************************************************************************
%   Reference:
%     "A Plant-Wide Industrial Process Control Problem"
%     Presented at the AIChE 1990 Annual Meeting
%     Industrial Challenge Problems in Process Control,Paper #24a
%     Chicago,Illinois,November 14,1990
% 
%  Revised 4-4-91 to correct error in documentation of manipulated variables
% 
%  Subroutines:
% 
%     TEFUNC - Function evaluator to be called by integrator
%     TEINIT - Initialization
%     TESUBi - Utility subroutines, i=1,2,..,8
% 
% 
%   The process simulation has 50 states (NN=50).
%   Differences between the code and its description in the paper:
% 
%   1.  Subroutine TEINIT has TIME in the argument list.  TEINIT sets TIME
%       to zero.
% 
%   2.  There are 8 utility subroutines (TESUBi) rather than 5.
% 
%   3.  Process disturbances 14 through 20 do NOT need to be used in
%       conjunction with another disturbance as stated in the paper.  All
%       disturbances can be used alone or in any combination.
%  
%   Manipulated Variables
% 
%     XMV(1,1)     D Feed Flow (stream 2)            (Corrected Order)
%     XMV(1,2)     E Feed Flow (stream 3)            (Corrected Order)
%     XMV(1,3)     A Feed Flow (stream 1)            (Corrected Order)
%     XMV(1,4)     A and C Feed Flow (stream 4)
%     XMV(1,5)     Compressor Recycle Valve (stream 8)
%     XMV(1,6)     Purge Valve (stream 9)
%     XMV(1,7)     Separator Pot Liquid Flow (stream 10)
%     XMV(1,8)     Stripper Liquid Product Flow (stream 11)
%     XMV(1,9)     Stripper Steam Valve
%     XMV(1,10)    Reactor Cooling Water Flow
%     XMV(1,11)    Condenser Cooling Water Flow
%     XMV(1,12)    Agitator Speed
% 
%   Continuous Process Measurements
% 
%     XMEAS(1,1)   A Feed  (stream 1)                    kscmh
%     XMEAS(1,2)   D Feed  (stream 2)                    kg/hr
%     XMEAS(1,3)   E Feed  (stream 3)                    kg/hr
%     XMEAS(1,4)   A and C Feed  (stream 4)              kscmh
%     XMEAS(1,5)   Recycle Flow  (stream 8)              kscmh
%     XMEAS(1,6)   Reactor Feed Rate  (stream 6)         kscmh
%     XMEAS(1,7)   Reactor Pressure                      kPa gauge
%     XMEAS(1,8)   Reactor Level                         %
%     XMEAS(1,9)   Reactor Temperature                   Deg C
%     XMEAS(1,10)  Purge Rate (stream 9)                 kscmh
%     XMEAS(1,11)  Product Sep Temp                      Deg C
%     XMEAS(1,12)  Product Sep Level                     %
%     XMEAS(1,13)  Prod Sep Pressure                     kPa gauge
%     XMEAS(1,14)  Prod Sep Underflow (stream 10)        m3/hr
%     XMEAS(1,15)  Stripper Level                        %
%     XMEAS(1,16)  Stripper Pressure                     kPa gauge
%     XMEAS(1,17)  Stripper Underflow (stream 11)        m3/hr
%     XMEAS(1,18)  Stripper Temperature                  Deg C
%     XMEAS(1,19)  Stripper Steam Flow                   kg/hr
%     XMEAS(1,20)  Compressor Work                       kW
%     XMEAS(1,21)  Reactor Cooling Water Outlet Temp     Deg C
%     XMEAS(1,22)  Separator Cooling Water Outlet Temp   Deg C
% 
%   Sampled Process Measurements
% 
%     Reactor Feed Analysis (Stream 6)
%         Sampling Frequency = 0.1 hr
%         Dead Time = 0.1 hr
%         Mole %
%     XMEAS(1,23)   Component A
%     XMEAS(1,24)   Component B
%     XMEAS(1,25)   Component C
%     XMEAS(1,26)   Component D
%     XMEAS(1,27)   Component E
%     XMEAS(1,28)   Component F
% 
%     Purge Gas Analysis (Stream 9)
%         Sampling Frequency = 0.1 hr
%         Dead Time = 0.1 hr
%         Mole %
%     XMEAS(1,29)   Component A
%     XMEAS(1,30)   Component B
%     XMEAS(1,31)   Component C
%     XMEAS(1,32)   Component D
%     XMEAS(1,33)   Component E
%     XMEAS(1,34)   Component F
%     XMEAS(1,35)   Component G
%     XMEAS(1,36)   Component H
% 
%     Product Analysis (Stream 11)
%         Sampling Frequency = 0.25 hr
%         Dead Time = 0.25 hr
%         Mole %
%     XMEAS(1,37)   Component D
%     XMEAS(1,38)   Component E
%     XMEAS(1,39)   Component F
%     XMEAS(1,40)   Component G
%     XMEAS(1,41)   Component H
% 
%   Process Disturbances
% 
%     IDV(1,1)   A/C Feed Ratio, B Composition Constant (Stream 4)          Step
%     IDV(1,2)   B Composition, A/C Ratio Constant (Stream 4)               Step
%     IDV(1,3)   D Feed Temperature (Stream 2)                              Step
%     IDV(1,4)   Reactor Cooling Water Inlet Temperature                    Step
%     IDV(1,5)   Condenser Cooling Water Inlet Temperature                  Step
%     IDV(1,6)   A Feed Loss (Stream 1)                                     Step
%     IDV(1,7)   C Header Pressure Loss - Reduced Availability (Stream 4)   Step
%     IDV(1,8)   A, B, C Feed Composition (Stream 4)            Random Variation
%     IDV(1,9)   D Feed Temperature (Stream 2)                  Random Variation
%     IDV(1,10)  C Feed Temperature (Stream 4)                  Random Variation
%     IDV(1,11)  Reactor Cooling Water Inlet Temperature        Random Variation
%     IDV(1,12)  Condenser Cooling Water Inlet Temperature      Random Variation
%     IDV(1,13)  Reaction Kinetics                                    Slow Drift
%     IDV(1,14)  Reactor Cooling Water Valve                            Sticking
%     IDV(1,15)  Condenser Cooling Water Valve                          Sticking
%     IDV(1,16)  Unknown
%     IDV(1,17)  Unknown
%     IDV(1,18)  Unknown
%     IDV(1,19)  Unknown
%     IDV(1,20)  Unknown
% 
%
% =============================================================================
%        Function Evaluator
% 
%          Inputs:
% 
%            NN   = Number of differential equations
%            Time = Current time(hrs)
%            YY   = Current state values
% 
%          Outputs:
% 
%            YP   = Current derivative values
% 
%   MEASUREMENT AND VALVE COMMON BLOCK

global XMEAS XMV 
%    DISTURBANCE VECTOR COMMON BLOCK

global NN
	
XMNS = 0; % Initialization by MWB
% 	NOTE: I have included isd in the /PV/ common.  This is set
% 		non-zero when the process is shutting down.
     global  UCLR UCVR UTLR UTVR...
     XLR XVR ETR ESR...
     TCR TKR DLR ...
     VLR VVR VTR ...
     PTR PPR...
     CRXR RR RH ...
     FWR TWR QUR HWR UAR...
     UCLS UCVS UTLS UTVS...
     XLS XVS ETS ESS...
     TCS TKS DLS...
     VLS VVS VTS...
     PTS PPS...
     FWS TWS QUS HWS...
     UCLC UTLC XLC...
     ETC ESC TCC DLC...
     VLC VTC QUC...
     UCVV UTVV XVV...
     ETV ESV TCV TKV...
     VTV PTV...
     VCV VRNG VTAU...
     FTM...
     FCM XST XMWS...
     HST TST SFR...
     CPFLMX CPPRMX CPDH...
     TCWR TCWS...
     HTR AGSP...
     XDEL XNS...
     TGAS TPROD VST IVST;
	 global...
     ADIST...
     BDIST...
     CDIST...
     DDIST...
     TLAST...
     TNEXT...
     HSPAN...
     HZERO...
     SSPAN...
     SZERO...
     SPSPAN...
     IDVWLK;
     global...
     AVP BVP CVP...
     AH BH CH...
     AG BG CG...
     AV...
     AD BD CD...
     XMW;
	 
for I = 1:20
	if IDV(I,1) > 0
    	IDV(I,1) = 1;
	else
		IDV(I,1) = 0;
	end
end

IDVWLK(1,1)=IDV(8,1);
IDVWLK(2,1)=IDV(8,1);
IDVWLK(3,1)=IDV(9,1);
IDVWLK(4,1)=IDV(10,1);
IDVWLK(5,1)=IDV(11,1);
IDVWLK(6,1)=IDV(12,1);
IDVWLK(7,1)=IDV(13,1);
IDVWLK(8,1)=IDV(13,1);
IDVWLK(9,1)=IDV(16,1);
IDVWLK(10,1)=IDV(17,1);
IDVWLK(11,1)=IDV(18,1);
IDVWLK(12,1)=IDV(20,1);
for I = 1:9
	if TIME >= TNEXT(I,1);
	HWLK=TNEXT(I,1)-TLAST(I,1);
    SWLK=ADIST(I,1)+HWLK*(BDIST(I,1)+HWLK*(CDIST(I,1)+HWLK*DDIST(I,1)));
    SPWLK=BDIST(I,1)+HWLK*(2*CDIST(I,1)+3*HWLK*DDIST(I,1));
    TLAST(I,1)=TNEXT(I,1);
	% TESUB5(SWLK,SPWLK,ADIST(I,1),BDIST(I,1),CDIST(I,1),DDIST(I,1),...
	% TLAST(I,1),TNEXT(I,1),HSPAN(I,1),HZERO(I,1),SSPAN(I,1),SZERO(I,1),...
	% SPSPAN(I,1),IDVWLK(I,1));
	% TESUB5(S,SP,ADIST,BDIST,CDIST,DDIST,
	% TLAST,TNEXT,HSPAN,HZERO,SSPAN,SZERO,...
	% SPSPAN,IDVFLAG) "VAL" added to subroutine variables.  "I" changed to "It".
	% Substitution of TESUB5 for call statement. MWB
	S5 = SWLK;
	SP5 = SPWLK;
	ADISTVAL = ADIST(I,1);
	BDISTVAL = BDIST(I,1);
	CDISTVAL = CDIST(I,1);
	DDISTVAL = DDIST(I,1);
	TLASTVAL = TLAST(I,1);
	TNEXTVAL = TNEXT(I,1);
	HSPANVAL = HSPAN(I,1);
	HZEROVAL = HZERO(I,1);
	SSPANVAL = SSPAN(I,1);
	SZEROVAL = SZERO(I,1);
	SPSPANVAL = SPSPAN(I,1);
	IDVFLAGVAL = IDVWLK(I,1);
	It = -1;
    H5 = HSPANVAL * TESUB7(It) + HZEROVAL;
    S1 = SSPANVAL * TESUB7(It) * IDVFLAGVAL + SZEROVAL;
    S1P = SPSPANVAL * TESUB7(It) * IDVFLAGVAL;
    ADISTVAL = S5;
    BDISTVAL = SP5;
    CDISTVAL = (3 * (S1 - S5) - H5 * (S1P + 2 * SP5)) / H5^2;
    DDISTVAL = (2 * (S5 - S1) + H5 * (S1P + SP5)) / H5^3;
    TNEXTVAL = TLASTVAL + H5;
	ADIST(I,1) = ADISTVAL; 
	BDIST(I,1) = BDISTVAL;
	CDIST(I,1) = CDISTVAL;
	DDIST(I,1) = DDISTVAL;
	TNEXT(I,1) = TNEXTVAL;  
	%
	% End of TESUB5
	%
	end
end
for I = 10:12
    if TIME >= TNEXT(I,1)
    HWLK = TNEXT(I,1) - TLAST(I,1);
    SWLK = ADIST(I,1) + HWLK * (BDIST(I,1) + HWLK * (CDIST(I,1) + HWLK * DDIST(I,1)));
    SPWLK = BDIST(I,1) + HWLK * (2 * CDIST(I,1) + 3 * HWLK * DDIST(I,1));
    TLAST(I,1) = TNEXT(I,1);
    	if SWLK > 0.1
      	ADIST(I,1) = SWLK;
      	BDIST(I,1) = SPWLK;
      	CDIST(I,1) = -(3 * SWLK + 0.2 * SPWLK) / 0.01;
      	DDIST(I,1) = (2 * SWLK + 0.1 * SPWLK) / 0.001;
      	TNEXT(I,1) = TLAST(I,1) + 0.1;
      	else
      	ISD = -1;
      	HWLK = HSPAN(I,1) * TESUB7(ISD) + HZERO(I,1);
     	ADIST(I,1) = 0;
      	BDIST(I,1) = 0;
      	CDIST(I,1) = (IDVWLK(I,1)) / HWLK^2;
      	DDIST(I,1) = 0;
      	TNEXT(I,1) = TLAST(I,1) + HWLK;
  		end
	end
end
if TIME == 0
	for I = 1:12
    ADIST(I,1)=SZERO(I,1);
    BDIST(I,1)=0;
    CDIST(I,1)=0;
    DDIST(I,1)=0;
    TLAST(I,1)=0.0;
    TNEXT(I,1)=0.1;
  	end
end

XST(1,4) = TESUB8(1,TIME) - IDV(1,1) * 0.03 - IDV(2,1) * 2.43719 * 10 ^ (-3);
XST(2,4) = TESUB8(2,TIME) + IDV(2,1) * 0.005;
XST(3,4) = 1 - XST(1,4) - XST(2,4);
TST(1,1) = TESUB8(3,TIME) + IDV(3,1) * 5;
TST(4,1) = TESUB8(4,TIME);
TCWR = TESUB8(5,TIME) + IDV(4,1) * 5;
TCWS = TESUB8(6,TIME) + IDV(5,1) * 5;
R1F = TESUB8(7,TIME);
R2F = TESUB8(8,TIME);
for I = 1:3
      UCVR(I,1)=YY(I,1);
      UCVS(I,1)=YY(I+9,1);
      UCLR(I,1)=0.0;
      UCLS(I,1)=0.0;
end
for I = 4:8
      UCLR(I,1) = YY(I,1);
      UCLS(I,1) = YY(I+9,1);
end
  
for I = 1:8
      UCLC(I,1) = YY(I+18,1);
      UCVV(I,1) = YY(I+27,1);
end
  
      ETR = YY(9,1);
      ETS = YY(18,1);
      ETC = YY(27,1);
      ETV = YY(36,1);
      TWR = YY(37,1);
      TWS = YY(38,1);
	  
%	  TWS shows an error here.  For the initialization,
%     it's value is  7.729698353000001e+01, when it should be
%     77.296983530000
	  
for I = 1:12
      VPOS(I,1) = YY(I+38,1);
end
      UTLR = 0.0;
      UTLS = 0.0;
      UTLC = 0.0;
      UTVV = 0.0;
	  
for I = 1:8
      UTLR = UTLR + UCLR(I,1);
      UTLS = UTLS + UCLS(I,1);
      UTLC = UTLC + UCLC(I,1);
      UTVV = UTVV + UCVV(I,1);
end
for I = 1:8
      XLR(I,1) = UCLR(I,1)/UTLR;
      XLS(I,1) = UCLS(I,1)/UTLS;
      XLC(I,1) = UCLC(I,1)/UTLC;
      XVV(I,1) = UCVV(I,1)/UTVV;
end
  
      ESR = ETR/UTLR;
      ESS = ETS/UTLS;
      ESC = ETC/UTLC;
      ESV = ETV/UTVV;
% Additional precision errors show up in XLR XLS XLC XVV ESR ESS ESC ESV 

%     TESUB2(XLR,TCR,ESR,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLR;
T = TCR;
H = ESR;
ITY = 0;
	  TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
    	HTEST = 0;
		for I = 1:8
      		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
      	HTEST = 0;
		for I = 1:8 
      		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HI = HI + AV(I,1);
      		HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
      	R1 = 3.57696 / 1000000;
     	HTEST = HTEST - R1 * (T + 273.15);
  	end
	%
	% End of TESUB1 sub
	%
	
    ERR = HTEST - H;
	
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
      	DH = 0.0;
    	for I = 1:8
      		DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
      	DH=0.0;
    	for I = 1:8
      		DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
      	R3 = 3.57696/1000000;
     	DH = DH - R3;
 	end
	%
	% End of TESUB3 substitution.
	%
    DT = -ERR / DH;
    T = T + DT;
  	if abs(DT) < 1*10^(-12)
    	break
  	end
  	if J == 100
  		T = TIN;
  	end
end
TCR = T;
% End of TESUB2.

      TKR = TCR+273.15;

%     TESUB2(XLS,TCS,ESS,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLS;
T = TCS;
H = ESS;
ITY = 0;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%	
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
 	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
   		DH = 0.0;
   		for I = 1:8
   			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
   			DHI = 1.8 * DHI;
   			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
   		DH=0.0;
   		for I = 1:8
   			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
   			DHI = 1.8 * DHI;
   			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
    	R3 = 3.57696/1000000;
    	DH = DH - R3;
  	end
	%
	% End of TESUB3 substitution.
	%
    DT = -ERR / DH;
    T = T + DT;
	if abs(DT) < 1*10^(-12)
    	break
  	end
	if J == 100
  		T = TIN;
  	end
end
TCS = T;
% End of TESUB2.

      TKS = TCS+273.15;
      
%     TESUB2(XLC,TCC,ESC,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLC;
T = TCC;
H = ESC;
ITY = 0;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
		DH = 0.0;
    	for I = 1:8
			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
		DH=0.0;
		for I = 1:8
			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
		R3 = 3.57696/1000000;
		DH = DH - R3;
	end
	%
	% End of TESUB3 substitution.
	%
	DT = -ERR / DH;
	T = T + DT;
	if abs(DT) < 1*10^(-12)
		break
	end
	if J == 100
		T = TIN;
	end
end
TCC = T;
% End of TESUB2.
      
%     TESUB2(XVV,TCV,ESV,2);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XVV;
T = TCV;
H = ESV;
ITY = 2;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
		DH = 0.0;
    	for I = 1:8
			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
		DH=0.0;
    	for I = 1:8
			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
		R3 = 3.57696/1000000;
		DH = DH - R3;
	end
	%
	% End of TESUB3 substitution.
	%
	DT = -ERR / DH;
	T = T + DT;
	if abs(DT) < 1*10^(-12)
		break
	end
	if J == 100
		T = TIN;
	end
end
TCV = T;
% End of TESUB2.
	  
TKV = TCV+273.15;
      
%	  TESUB4(XLR,TCR,DLR);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLR;
T4 = TCR;
R4 = DLR;
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLR = R4;
% End of TESUB4.

      
%	  TESUB4(XLS,TCS,DLS);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLS;
T4 = TCS;
R4 = DLS;
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLS = R4;
% End of TESUB4.
      
%	  TESUB4(XLC,TCC,DLC);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLC;
T4 = TCC;
R4 = DLC;
V = 0.0;
for I = 1:8
      V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLC = R4;
% End of TESUB4.
VLR = UTLR/DLR;
VLS = UTLS/DLS;
VLC = UTLC/DLC;
VVR = VTR-VLR;
VVS = VTS-VLS;
RG = 998.9;
PTR = 0.0;
PTS = 0.0;
for I = 1:3
      PPR(I,1) = UCVR(I,1)*RG*TKR/VVR;
      PTR = PTR+PPR(I,1);
      PPS(I,1) = UCVS(I,1)*RG*TKS/VVS;
      PTS = PTS+PPS(I,1);
  end
% Some precision error with PTS
for I = 4:8
      VPR=exp(AVP(I,1)+BVP(I,1)/(TCR+CVP(I,1)));
      PPR(I,1)=VPR*XLR(I,1);
      PTR=PTR+PPR(I,1);
      VPR=exp(AVP(I,1)+BVP(I,1)/(TCS+CVP(I,1)));
      PPS(I,1)=VPR*XLS(I,1);
      PTS=PTS+PPS(I,1);
  end
      PTV=UTVV*RG*TKV/VTV;
for I=1:8
      XVR(I,1)=PPR(I,1)/PTR;
      XVS(I,1)=PPS(I,1)/PTS;
end
UTVR=PTR*VVR/RG/TKR;
UTVS=PTS*VVS/RG/TKS;
for I=4:8
      UCVR(I,1)=UTVR*XVR(I,1);
      UCVS(I,1)=UTVS*XVS(I,1);
  end
  
% This is where the Matlab RR's show different values than the FORTRAN 77
% RR's.  The code below has been modified with the chop command to 
% elliminate the stray numbers that are created by the matlab code.
% Matlab:				FORTRAN 77:
% R1F
% 1						1.0000000000000
% R2F
% 1						1.0000000000000
% TKR
% 3.935500000017000e+02	393.55000000169
% RR(1,1)
% 3.181229946057000e-09	3.1812215872809D-09
% RR(2,1)
% 1.569591352140000e-10	1.5695892900646D-10
% RR(3,1)
% 7.437635682791000e-11	7.4376432806282D-11
% RR(4,1)
% 5.708298619084000e-11	5.7083044503356D-11
%
% NOTE:  I DID A COMPARISON OF THE EXP FUNCTIONS OF MATLAB
%        AND FORTRAN 77 AND THERE IS A CONSISTENT DISCREPANCY AT
%        10^-16 BETWEEN THE OUTPUT OF THE TWO LANGUAGES
%

R1F = chop(R1F,13);
R2F = chop(R2F,13);
TKR = chop(TKR,13);
RR(1,1)=chop(exp(31.5859536-40000.0/1.987/TKR)*R1F,13);
RR(2,1)=chop(exp(3.00094014-20000.0/1.987/TKR)*R2F,13);
RR(3,1)=chop(exp(53.4060443-60000.0/1.987/TKR),13);
RR(4,1)=chop(RR(3,1)*0.767488334,13);

% This next section has the following output:
% Matlab:				FORTRAN 77:
% PPR(1,1)
% 5.717769731191162e+03	5717.7697311912     * good
% PPR(3,1)
% 4.159943934675613e+03 4159.9439346756		* good
% R1F
% 2.174415112221978e+04 21744.151122220		* good
% R2F
% 2.247652526817436e+01 22.476525268174		* good
% RR(1,1)
% 3.517133031511259e-01 0.35171237901398	
% RR(2,1)
% 2.861611337089543e-01 0.28616075776025

if PPR(1,1) > 0.0 & PPR(3,1) > 0.0
      R1F=PPR(1,1)^1.1544;
      R2F=PPR(3,1)^0.3735;
      RR(1,1)=RR(1,1)*R1F*R2F*PPR(4,1);
      RR(2,1)=RR(2,1)*R1F*R2F*PPR(5,1);
  else
	  
      RR(1,1)=0.0;
      RR(2,1)=0.0;
  end
%
% This next section has the following output:
% Matlab:				FORTRAN 77:
% RR(1,1)
% 2.516069042865577e+02 251.60624318195
% RR(2,1)
% 2.047125210635105e+02 204.71225211921
% RR(3,1)
% 1.134874248863408e+00 1.1348754081821
% RR(4,1)
% 5.281888235868223e-02 5.2818936315249D-02
%
RR(3,1)=RR(3,1)*PPR(1,1)*PPR(5,1);
RR(4,1)=RR(4,1)*PPR(1,1)*PPR(4,1);
for I=1:4
    RR(I,1)=RR(I,1)*VVR;
end
%
% This next section has the following output:
% Matlab:					FORTRAN 77:
% CRXR(1,1)
% -4.574542995989316e+02	-457.45337070934
% CRXR(3,1)
% -4.563194253500682e+02	-456.31849530116
% CRXR(4,1)
% -2.516861326100957e+02	-251.68547158642
% CRXR(5,1)
% -2.058473953123739e+02	-205.84712752739
% CRXR(6,1)
% 1.187693131222090e+00		1.1876943444973
% CRXR(7,1)
% 2.516069042865577e+02		251.60624318195
% CRXR(8,1)
% 2.047125210635105e+02		204.71225211921
% RH
% 2.759494513807820e+01		27.594886078737
CRXR(1,1)=-RR(1,1)-RR(2,1)-RR(3,1);
CRXR(3,1)=-RR(1,1)-RR(2,1);
CRXR(4,1)=-RR(1,1)-1.5*RR(4,1);
CRXR(5,1)=-RR(2,1)-RR(3,1);
CRXR(6,1)=RR(3,1)+RR(4,1);
CRXR(7,1)=RR(1,1);
CRXR(8,1)=RR(2,1);
RH=RR(1,1)*HTR(1,1)+RR(2,1)*HTR(2,1);
XMWS(1,1)=0.0;
XMWS(2,1)=0.0;
XMWS(6,1)=0.0;
XMWS(8,1)=0.0;
XMWS(9,1)=0.0;
XMWS(10,1)=0.0;
%
% XST & XMWS seem to be calculated correcly in the next 
% section with little error.
%
for I=1:8
	  XST(I,6)=XVV(I,1);
	  XST(I,8)=XVR(I,1);
	  XST(I,9)=XVS(I,1);
      XST(I,10)=XVS(I,1);
      XST(I,11)=XLS(I,1);
      XST(I,13)=XLC(I,1);
      XMWS(1,1)=XMWS(1,1)+XST(I,1)*XMW(I,1);
      XMWS(2,1)=XMWS(2,1)+XST(I,2)*XMW(I,1);
      XMWS(6,1)=XMWS(6,1)+XST(I,6)*XMW(I,1);
      XMWS(8,1)=XMWS(8,1)+XST(I,8)*XMW(I,1);
      XMWS(9,1)=XMWS(9,1)+XST(I,9)*XMW(I,1);
      XMWS(10,1)=XMWS(10,1)+XST(I,10)*XMW(I,1);
  end
TST(6,1)=TCV;
TST(8,1)=TCR;
TST(9,1)=TCS;
TST(10,1)=TCS;
TST(11,1)=TCS;
TST(13,1)=TCC;

% The HST's from the following substitutions for TESUB1 are 
% computed correctly.

%
%      TESUB1(XST(1,1),TST(1,1),HST(1,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,1);
T=TST(1,1);
H=HST(1,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
	R1 = 3.57696 / 1000000;
	H = H - R1 * (T + 273.15);
end
HST(1,1) = H;
% end of TESUB1


%      TESUB1(XST(1,2),TST(2,1),HST(2,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,2);
T=TST(2,1);
H=HST(2,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(2,1) = H;
% end of TESUB1

%      TESUB1(XST(1,3),TST(3,1),HST(3,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,3);
T=TST(3,1);
H=HST(3,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(3,1) = H;
% end of TESUB1

%      TESUB1(XST(1,4),TST(4,1),HST(4,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,4);
T=TST(4,1);
H=HST(4,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(4,1) = H;
% end of TESUB1

%      TESUB1(XST(1,6),TST(6,1),HST(6,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,6);
T=TST(6,1);
H=HST(6,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(6,1) = H;
% end of TESUB1

%      TESUB1(XST(1,8),TST(8,1),HST(8,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,8);
T=TST(8,1);
H=HST(8,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(8,1) = H;
% end of TESUB1

%      TESUB1(XST(1,9),TST(9,1),HST(9,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,9);
T=TST(9,1);
H=HST(9,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(9,1) = H;
% end of TESUB1

      HST(10,1)=HST(9,1);
	  
%      TESUB1(XST(1,11),TST(11,1),HST(11,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,11);
T=TST(11,1);
H=HST(11,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
 		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(11,1) = H;
% end of TESUB1

%      TESUB1(XST(1,13),TST(13,1),HST(13,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,13);
T=TST(13,1);
H=HST(13,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(13,1) = H;
% end of TESUB1

% This next section is good.
FTM(1,1)=VPOS(1,1)*VRNG(1,1)/100.0;
FTM(2,1)=VPOS(2,1)*VRNG(2,1)/100.0;
FTM(3,1)=VPOS(3,1)*(1-IDV(6,1))*VRNG(3,1)/100.0;
FTM(4,1)=VPOS(4,1)*(1-IDV(7,1)*0.2)*VRNG(4,1)/100.0+1.E-10;
FTM(11,1)=VPOS(7,1)*VRNG(7,1)/100.0;
FTM(13,1)=VPOS(8,1)*VRNG(8,1)/100.0;
UAC=VPOS(9,1)*VRNG(9,1)*(1+TESUB8(9,TIME))/100.0;
FWR=VPOS(10,1)*VRNG(10,1)/100.0;
FWS=VPOS(11,1)*VRNG(11,1)/100.0;
AGSP=(VPOS(12,1)+150.0)/100.0;
DLP=PTV-PTR;

if DLP<0 
	DLP=0.0;
end
FLMS=1937.6*sqrt(DLP);
FTM(6,1)=FLMS/XMWS(6,1);
DLP=PTR-PTS;
if DLP<0 
	DLP=0.0;
end
FLMS=4574.21*sqrt(DLP)*(1-0.25*TESUB8(12,TIME));
FTM(8,1)=FLMS/XMWS(8,1);
DLP=PTS-760.0;
if DLP < 0 
	DLP=0.0;
end
FLMS=VPOS(6,1)*0.151169*sqrt(DLP);
FTM(10,1)=FLMS/XMWS(10,1);
PR=PTV/PTS;
if PR < 1
	PR=1.0;
end
if PR > CPPRMX
	PR=CPPRMX;
end
FLCOEF=CPFLMX/1.197;
FLMS=CPFLMX+FLCOEF*(1.0-PR^3);
CPDH=FLMS*(TCS+273.15)*1.8E-6*1.9872*(PTV-PTS)/(XMWS(9,1)*PTS);
DLP=PTV-PTS;
if DLP < 0.0
	DLP=0.0;
end
FLMS=FLMS-VPOS(5,1)*53.349*sqrt(DLP);
if FLMS < 1.E-3
	FLMS=1.E-3;
end
FTM(9,1)=FLMS/XMWS(9,1);
HST(9,1)=HST(9,1)+CPDH/FTM(9,1);
for I=1:8
      FCM(I,1)=XST(I,1)*FTM(1,1);
      FCM(I,2)=XST(I,2)*FTM(2,1);
      FCM(I,3)=XST(I,3)*FTM(3,1);
      FCM(I,4)=XST(I,4)*FTM(4,1);
      FCM(I,6)=XST(I,6)*FTM(6,1);
      FCM(I,8)=XST(I,8)*FTM(8,1);
      FCM(I,9)=XST(I,9)*FTM(9,1);
      FCM(I,10)=XST(I,10)*FTM(10,1);
      FCM(I,11)=XST(I,11)*FTM(11,1);
      FCM(I,13)=XST(I,13)*FTM(13,1);
  end

if FTM(11,1) > 0.1
	if TCC > 170
		TMPFAC=TCC-120.262;
	elseif TCC < 5.292
		TMPFAC=0.1;
	else
		TMPFAC=363.744/(177.-TCC)-2.22579488;
	end
	VOVRL=FTM(4,1)/FTM(11,1)*TMPFAC;
	SFR(4,1)=8.5010*VOVRL/(1.0+8.5010*VOVRL);
	SFR(5,1)=11.402*VOVRL/(1.0+11.402*VOVRL);
	SFR(6,1)=11.795*VOVRL/(1.0+11.795*VOVRL);
	SFR(7,1)=0.0480*VOVRL/(1.0+0.0480*VOVRL);
	SFR(8,1)=0.0242*VOVRL/(1.0+0.0242*VOVRL);
else
	SFR(4,1)=0.9999;
	SFR(5,1)=0.999;
	SFR(6,1)=0.999;
	SFR(7,1)=0.99;
	SFR(8,1)=0.98;
end
for I=1:8
      FIN(I,1)=0.0;
      FIN(I,1)=FIN(I,1)+FCM(I,4);
      FIN(I,1)=FIN(I,1)+FCM(I,11);
  end

FTM(5,1)=0.0;
FTM(12,1)=0.0;
for I=1:8
      FCM(I,5)=SFR(I,1)*FIN(I,1);
      FCM(I,12)=FIN(I,1)-FCM(I,5);
      FTM(5,1)=FTM(5,1)+FCM(I,5);
      FTM(12,1)=FTM(12,1)+FCM(I,12);
end
for I=1:8
      XST(I,5)=FCM(I,5)/FTM(5,1);
      XST(I,12)=FCM(I,12)/FTM(12,1);
end
TST(5,1)=TCC;
TST(12,1)=TCC;
%      TESUB1(XST(1,5),TST(5,1),HST(5,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,5);
T=TST(5,1);
H=HST(5,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(5,1) = H;
% end of TESUB1

%      TESUB1(XST(1,12),TST(12,1),HST(12,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,12);
T=TST(12,1);
H=HST(12,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
	R1 = 3.57696 / 1000000;
	H = H - R1 * (T + 273.15);
end
HST(12,1) = H;
% end of TESUB1

FTM(7,1)=FTM(6,1);
HST(7,1)=HST(6,1);
TST(7,1)=TST(6,1);

for I=1:8
	
      XST(I,7)=XST(I,6);
      FCM(I,7)=FCM(I,6);
end

if VLR/7.8 > 50.0
	UARLEV=1.0;
elseif VLR/7.8 < 10.0
    UARLEV=0.0;
else
      UARLEV=0.025*VLR/7.8-0.25;
  end
  
UAR=UARLEV*(-0.5*AGSP^2+2.75*AGSP-2.5)*855490.E-6;
QUR=UAR*(TWR-TCR)*(1-0.35*TESUB8(10,TIME));
UAS=0.404655*(1.0-1.0/(1.0+(FTM(8,1)/3528.73)^4));
QUS=UAS*(TWS-TST(8,1))*(1-0.25*TESUB8(11,TIME));
QUC=0;

if TCC < 100
	QUC=UAC*(100.0-TCC);
end
      XMEAS(1,1)=FTM(3,1)*0.359/35.3145;
      XMEAS(2,1)=FTM(1,1)*XMWS(1,1)*0.454;
      XMEAS(3,1)=FTM(2,1)*XMWS(2,1)*0.454;
      XMEAS(4,1)=FTM(4,1)*0.359/35.3145;
      XMEAS(5,1)=FTM(9,1)*0.359/35.3145;
      XMEAS(6,1)=FTM(6,1)*0.359/35.3145;
      XMEAS(7,1)=(PTR-760.0)/760.0*101.325;
      XMEAS(8,1)=(VLR-84.6)/666.7*100.0;
      XMEAS(9,1)=TCR;
      XMEAS(10,1)=FTM(10,1)*0.359/35.3145;
      XMEAS(11,1)=TCS;
      XMEAS(12,1)=(VLS-27.5)/290.0*100.0;
      XMEAS(13,1)=(PTS-760.0)/760.0*101.325;
      XMEAS(14,1)=FTM(11,1)/DLS/35.3145;
      XMEAS(15,1)=(VLC-78.25)/VTC*100.0;
      XMEAS(16,1)=(PTV-760.0)/760.0*101.325;
      XMEAS(17,1)=FTM(13,1)/DLC/35.3145;
      XMEAS(18,1)=TCC;
      XMEAS(19,1)=QUC*1.04E3*0.454;
      XMEAS(20,1)=CPDH*0.0003927E6;
      XMEAS(20,1)=CPDH*0.29307E3;
      XMEAS(21,1)=TWR;
      XMEAS(22,1)=TWS;
	 ISD=0;
if XMEAS(7,1) > 3000.0
	ISD=1;
	end
if VLR/35.3145 > 24.0
	ISD=1;
	end
if VLR/35.3145 < 2.0
	ISD=1;
	end
if XMEAS(9,1) > 175.0
	ISD=1;
	end
if VLS/35.3145 > 12.0
	ISD=1;
	end
if VLS/35.3145 < 1.0
	ISD=1;
	end
if VLC/35.3145 > 8.0
	ISD=1;
	end
if VLC/35.3145 < 1.0
	ISD=1;
	end
if TIME > 0.0 & ISD == 0
	for I=1:22
		%      TESUB6(XNS(I,1),XMNS)
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter =1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6.

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
	end
end
      XCMP(23,1)=XST(1,7)*100.0;
      XCMP(24,1)=XST(2,7)*100.0;
      XCMP(25,1)=XST(3,7)*100.0;
      XCMP(26,1)=XST(4,7)*100.0;
      XCMP(27,1)=XST(5,7)*100.0;
      XCMP(28,1)=XST(6,7)*100.0;
      XCMP(29,1)=XST(1,10)*100.0;
      XCMP(30,1)=XST(2,10)*100.0;
      XCMP(31,1)=XST(3,10)*100.0;
      XCMP(32,1)=XST(4,10)*100.0;
      XCMP(33,1)=XST(5,10)*100.0;
      XCMP(34,1)=XST(6,10)*100.0;
      XCMP(35,1)=XST(7,10)*100.0;
      XCMP(36,1)=XST(8,10)*100.0;
      XCMP(37,1)=XST(4,13)*100.0;
      XCMP(38,1)=XST(5,13)*100.0;
      XCMP(39,1)=XST(6,13)*100.0;
      XCMP(40,1)=XST(7,13)*100.0;
      XCMP(41,1)=XST(8,13)*100.0;
	  
if TIME == 0
	for I=23:41
		XDEL(I,1)=XCMP(I,1);
		XMEAS(I,1)=XCMP(I,1);
	end

	TGAS=0.1;
	TPROD=0.25;
end

if TIME >= TGAS %feed and purge side
	for I=23:36
		XMEAS(I,1)=XDEL(I,1);
		%      TESUB6(XNS(I,1),XMNS);
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter=1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
		XDEL(I,1)=XCMP(I,1);
	end
	TGAS=TGAS+0.1;
end
 
if TIME >= TPROD %only prod side
	for I=37:41
		XMEAS(I,1)=XDEL(I,1);
      
		%      TESUB6(XNS(I,1),XMNS)
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter=1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
		XDEL(I,1)=XCMP(I,1);
	end
	TPROD=TPROD+0.25;
end
% 
for iter = 1:8
      YP(iter,1) = FCM(iter,7) - FCM(iter,8) + CRXR(iter,1);
      YP(iter+9,1) = FCM(iter,8) - FCM(iter,9) - FCM(iter,10) - FCM(iter,11);
      YP(iter+18,1) = FCM(iter,12) - FCM(iter,13);
      YP(iter+27,1) = FCM(iter,1) + FCM(iter,2) + FCM(iter,3) + FCM(iter,5) + FCM(iter,9) - FCM(iter,6);
  end
  
% 		Here is the "correct" version of the separator energy balance:
% 
% 	YP(18)=HST(8)*FTM(8)-(HST(9)*FTM(9)-cpdh)-HST(10)*FTM(10)-HST(11)*FTM(11)+QUS
% 
%   	Here is the original version
	  YP(9,1)=HST(7,1) * FTM(7,1) - HST(8) * FTM(8) + RH + QUR;
      YP(18,1)=HST(8,1)*FTM(8,1)-HST(9,1)*FTM(9,1)-HST(10,1)*FTM(10,1)-HST(11,1)*FTM(11,1)+QUS;
      YP(27,1)=HST(4,1)*FTM(4,1)+HST(11,1)*FTM(11,1)-HST(5,1)*FTM(5,1)-HST(13,1)*FTM(13,1)+QUC;
      YP(36,1)=HST(1,1)*FTM(1,1)+HST(2,1)*FTM(2,1)+HST(3,1)*FTM(3,1)+HST(5,1)*FTM(5,1)+HST(9,1)*FTM(9,1)-HST(6,1)*FTM(6,1);
      YP(37,1)=(FWR*500.53*(TCWR-TWR)-QUR*1000000/1.8)/HWR;
      YP(38,1)=(FWS*500.53*(TCWS-TWS)-QUS*1000000/1.8)/HWS;
      IVST(10,1)=IDV(14,1);
      IVST(11,1)=IDV(15,1);
      IVST(5,1)=IDV(19,1);
      IVST(7,1)=IDV(19,1);
      IVST(8,1)=IDV(19,1);
      IVST(9,1)=IDV(19,1);
for I=1:12
	if TIME == 0 | abs(VCV(I,1)-XMV(I,1)) > VST(I,1)*IVST(I,1)
		VCV(I,1)=XMV(I,1);
	end
	if VCV(I,1) < 0.0
		VCV(I,1)=0.0;
	end
	if VCV(I,1) > 100.0
		VCV(I,1)=100.0;
	end
	YP(I+38,1)=(VCV(I,1)-VPOS(I,1))/VTAU(I,1);
end
if TIME > 0.0 & ISD ~= 0
	for I=1:NN
		YP(I,1)=0.0;
	end
end
% This is the final output of the subroutine:
% Everything up to this point (except what has been
% documented in the code) runs very similar to the FORTRAN 77
% version. MWB 
%  7/12/98
%  Matlab:						FORTRAN77:
%  YY
% 	   1.040491389000000e+01     1.040491389000000e+01
%      4.363996017000000e+00     4.363996017000000e+00
%      7.570059737000000e+00     7.570059737000000e+00
%      4.230042431000000e-01     4.230042431000000e-01
%      2.415513437000000e+01     2.415513437000000e+01
%      2.942597645000000e+00     2.942597645000000e+00
%      1.543770655000000e+02     1.543770655000000e+02
%      1.591865960000000e+02     1.591865960000000e+02
%      2.808522723000000e+00     2.808522723000000e+00
%      6.375581199000000e+01     6.375581199000000e+01
%      2.674026066000000e+01     2.674026066000000e+01
%      4.638532432000000e+01     4.638532432000000e+01
%      2.464521543000000e-01     2.464521543000000e-01
%      1.520484404000000e+01     1.520484404000000e+01
%      1.852266172000000e+00     1.852266172000000e+00
%      5.244639459000000e+01     5.244639459000000e+01
%      4.120394008000000e+01     4.120394008000000e+01
%      5.699317760000000e-01     5.699317760000000e-01
%      4.306056376000000e-01     4.306056376000000e-01
%      7.990620078300001e-03     7.990620078300001e-03
%      9.056036089000000e-01     9.056036089000000e-01
%      1.605425821600000e-02     1.605425821600000e-02
%      7.509759687000001e-01     7.509759687000001e-01
%      8.858285595500000e-02     8.858285595500000e-02
%      4.827726193000000e+01     4.827726193000000e+01
%      3.938459028000000e+01     3.938459028000000e+01
%      3.755297257000000e-01     3.755297257000000e-01
%      1.077562698000000e+02     1.077562698000000e+02
%      2.977250546000000e+01     2.977250546000000e+01
%      8.832481135000000e+01     8.832481135000000e+01
%      2.303929507000000e+01     2.303929507000000e+01
%      6.285848794000000e+01     6.285848794000000e+01
%      5.546318688000000e+00     5.546318688000000e+00
%      1.192244772000000e+01     1.192244772000000e+01
%      5.555448243000000e+00     5.555448243000000e+00
%      9.218489761999999e-01     9.218489761999999e-01
%      9.459927549000000e+01     9.459927549000000e+01
%      7.729698353000001e+01     7.729698353000001e+01
%      6.305263039000000e+01     6.305263039000000e+01
%      5.397970677000000e+01     5.397970677000000e+01
%      2.464355755000000e+01     2.464355755000000e+01
%      6.130192144000000e+01     6.130192144000000e+01
%      2.221000000000000e+01     2.221000000000000e+01
%      4.006374673000000e+01     4.006374673000000e+01
%      3.810034370000000e+01     3.810034370000000e+01
%      4.653415582000000e+01     4.653415582000000e+01
%      4.744573456000000e+01     4.744573456000000e+01
%      4.110581288000000e+01     4.110581288000000e+01
%      1.811349055000000e+01     1.811349055000000e+01
%      5.000000000000000e+01     5.000000000000000e+01
%   YP:
%     -9.311351132055279e-04    -2.245521557142600e-06 <- Sig Dif
%     -3.680818849716161e-07    -3.680818849716200e-07
%     -9.313903218526320e-04    -1.341411575595000e-06 <- Sig Dif
%     -6.614342966599907e-04    -4.106221069832800e-07 <- Sig Dif
%     -2.689011108429895e-04    -1.116128657940900e-06 <- Sig Dif
%     -1.312917689233473e-06    -9.964246872051801e-08 <- Sig Dif
%      6.609202557683602e-04    -1.843536381329600e-07 <- Sig Dif
%      2.688889922808357e-04    -5.530856128643800e-08 <- Sig Dif
%      5.904527482059052e-05    -1.406638006074000e-08 <- Sig Dif
%     -3.216924339355387e-06    -3.216923774473900e-06
%     -1.320602298626739e-06    -1.320602072141200e-06
%     -2.292647105051060e-06    -2.292646652080100e-06
%     -1.172087313872083e-07    -1.172087100709300e-07
%     -1.564706110457337e-06    -1.564705769396800e-06
%     -2.046840421598972e-07    -2.046840066327600e-07
%     -3.064993734369637e-07    -3.064992597501300e-07
%     -1.538568028536247e-07    -1.538566607450800e-07
%     -3.970321582613678e-08    -3.970320694435300e-08
%     -2.569517931760856e-10    -2.569517931760900e-10
%     -2.359501483084614e-13    -2.359501483084600e-13
%     -1.614086642121038e-10    -1.614086642121000e-10
%     -1.656258463711424e-11    -1.656258463711400e-11
%     -1.189860210359939e-09    -1.189860210359900e-09
%     -1.897565438113702e-11    -1.897565438113700e-11
%     -4.671457531912893e-08    -4.671457531912900e-08
%     -1.934833449013240e-08    -1.934833449013200e-08
%     -2.352361638813250e-10    -2.352361638813200e-10
%      5.300687917042524e-06     5.300687462295200e-06
%      1.688940415078832e-06     1.688940187705200e-06
%      3.474454388197046e-06     3.474453933449700e-06
%      4.445469699021487e-07     4.445469699021500e-07
%      2.613836613818421e-06     2.613836272757900e-06
%      3.049074734917667e-07     3.049074308592000e-07
%      5.932505473538185e-07     5.932504336669800e-07
%      3.048364050073360e-07     3.048362486879300e-07
%      5.976254513484491e-08     5.976253802941801e-08
%     -4.380748794538104e-07    -4.380756709460800e-07
%      3.318385615567584e-07     3.318384779400800e-07
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0


% End of TEFUNC
%disp ('initialized')

x0  = YY;
YP0 = YP;
%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];



% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
end
function sys=mdlDerivatives(t,x,u)
global YP0 YY YP
TIME = t;
if t == 0
	sys = YP0;
else
	global XMEAS XMV  
	global NN
	IDV = u(1:20,1);
    XMV = u(21:32,1);
  
  
		  
%     TEFUNC(NN,TIME,YY,YP);
%     TEFUNCVAL = TEFUNC(NN,TIME,YY,YP)
%
% Substitution of TEFUNC for call statement. MWB
%
%                Tennessee Eastman Process Control Test Problem
% 
%                     James J. Downs and Ernest F. Vogel
% 
%                   Process and Control Systems Engineering
%                        Tennessee Eastman Company
%                               P.O. Box 511
%                           Kingsport,TN  37662
% 
% ************************************************************************
%
% 						Re-Written in Matlab 5.0 
%									by	
%								Martin Braun
%
%			Department of Chemical, Bio and Materials Engineering
%						Arizona State University
%
% ************************************************************************
%   Reference:
%     "A Plant-Wide Industrial Process Control Problem"
%     Presented at the AIChE 1990 Annual Meeting
%     Industrial Challenge Problems in Process Control,Paper #24a
%     Chicago,Illinois,November 14,1990
% 
%  Revised 4-4-91 to correct error in documentation of manipulated variables
% 
%  Subroutines:
% 
%     TEFUNC - Function evaluator to be called by integrator
%     TEINIT - Initialization
%     TESUBi - Utility subroutines, i=1,2,..,8
% 
% 
%   The process simulation has 50 states (NN=50).
%   Differences between the code and its description in the paper:
% 
%   1.  Subroutine TEINIT has TIME in the argument list.  TEINIT sets TIME
%       to zero.
% 
%   2.  There are 8 utility subroutines (TESUBi) rather than 5.
% 
%   3.  Process disturbances 14 through 20 do NOT need to be used in
%       conjunction with another disturbance as stated in the paper.  All
%       disturbances can be used alone or in any combination.
%  
%   Manipulated Variables
% 
%     XMV(1,1)     D Feed Flow (stream 2)            (Corrected Order)
%     XMV(1,2)     E Feed Flow (stream 3)            (Corrected Order)
%     XMV(1,3)     A Feed Flow (stream 1)            (Corrected Order)
%     XMV(1,4)     A and C Feed Flow (stream 4)
%     XMV(1,5)     Compressor Recycle Valve
%     XMV(1,6)     Purge Valve (stream 9)
%     XMV(1,7)     Separator Pot Liquid Flow (stream 10)
%     XMV(1,8)     Stripper Liquid Product Flow (stream 11)
%     XMV(1,9)     Stripper Steam Valve
%     XMV(1,10)    Reactor Cooling Water Flow
%     XMV(1,11)    Condenser Cooling Water Flow
%     XMV(1,12)    Agitator Speed
% 
%   Continuous Process Measurements
% 
%     XMEAS(1,1)   A Feed  (stream 1)                    kscmh
%     XMEAS(1,2)   D Feed  (stream 2)                    kg/hr
%     XMEAS(1,3)   E Feed  (stream 3)                    kg/hr
%     XMEAS(1,4)   A and C Feed  (stream 4)              kscmh
%     XMEAS(1,5)   Recycle Flow  (stream 8)              kscmh
%     XMEAS(1,6)   Reactor Feed Rate  (stream 6)         kscmh
%     XMEAS(1,7)   Reactor Pressure                      kPa gauge
%     XMEAS(1,8)   Reactor Level                         %
%     XMEAS(1,9)   Reactor Temperature                   Deg C
%     XMEAS(1,10)  Purge Rate (stream 9)                 kscmh
%     XMEAS(1,11)  Product Sep Temp                      Deg C
%     XMEAS(1,12)  Product Sep Level                     %
%     XMEAS(1,13)  Prod Sep Pressure                     kPa gauge
%     XMEAS(1,14)  Prod Sep Underflow (stream 10)        m3/hr
%     XMEAS(1,15)  Stripper Level                        %
%     XMEAS(1,16)  Stripper Pressure                     kPa gauge
%     XMEAS(1,17)  Stripper Underflow (stream 11)        m3/hr
%     XMEAS(1,18)  Stripper Temperature                  Deg C
%     XMEAS(1,19)  Stripper Steam Flow                   kg/hr
%     XMEAS(1,20)  Compressor Work                       kW
%     XMEAS(1,21)  Reactor Cooling Water Outlet Temp     Deg C
%     XMEAS(1,22)  Separator Cooling Water Outlet Temp   Deg C
% 
%   Sampled Process Measurements
% 
%     Reactor Feed Analysis (Stream 6)
%         Sampling Frequency = 0.1 hr
%         Dead Time = 0.1 hr
%         Mole %
%     XMEAS(1,23)   Component A
%     XMEAS(1,24)   Component B
%     XMEAS(1,25)   Component C
%     XMEAS(1,26)   Component D
%     XMEAS(1,27)   Component E
%     XMEAS(1,28)   Component F
% 
%     Purge Gas Analysis (Stream 9)
%         Sampling Frequency = 0.1 hr
%         Dead Time = 0.1 hr
%         Mole %
%     XMEAS(1,29)   Component A
%     XMEAS(1,30)   Component B
%     XMEAS(1,31)   Component C
%     XMEAS(1,32)   Component D
%     XMEAS(1,33)   Component E
%     XMEAS(1,34)   Component F
%     XMEAS(1,35)   Component G
%     XMEAS(1,36)   Component H
% 
%     Product Analysis (Stream 11)
%         Sampling Frequency = 0.25 hr
%         Dead Time = 0.25 hr
%         Mole %
%     XMEAS(1,37)   Component D
%     XMEAS(1,38)   Component E
%     XMEAS(1,39)   Component F
%     XMEAS(1,40)   Component G
%     XMEAS(1,41)   Component H
% 
%   Process Disturbances
% 
%     IDV(1,1)   A/C Feed Ratio, B Composition Constant (Stream 4)          Step
%     IDV(1,2)   B Composition, A/C Ratio Constant (Stream 4)               Step
%     IDV(1,3)   D Feed Temperature (Stream 2)                              Step
%     IDV(1,4)   Reactor Cooling Water Inlet Temperature                    Step
%     IDV(1,5)   Condenser Cooling Water Inlet Temperature                  Step
%     IDV(1,6)   A Feed Loss (Stream 1)                                     Step
%     IDV(1,7)   C Header Pressure Loss - Reduced Availability (Stream 4)   Step
%     IDV(1,8)   A, B, C Feed Composition (Stream 4)            Random Variation
%     IDV(1,9)   D Feed Temperature (Stream 2)                  Random Variation
%     IDV(1,10)  C Feed Temperature (Stream 4)                  Random Variation
%     IDV(1,11)  Reactor Cooling Water Inlet Temperature        Random Variation
%     IDV(1,12)  Condenser Cooling Water Inlet Temperature      Random Variation
%     IDV(1,13)  Reaction Kinetics                                    Slow Drift
%     IDV(1,14)  Reactor Cooling Water Valve                            Sticking
%     IDV(1,15)  Condenser Cooling Water Valve                          Sticking
%     IDV(1,16)  Unknown
%     IDV(1,17)  Unknown
%     IDV(1,18)  Unknown
%     IDV(1,19)  Unknown
%     IDV(1,20)  Unknown
% 
%
% =============================================================================
%        Function Evaluator
% 
%          Inputs:
% 
%            NN   = Number of differential equations
%            Time = Current time(hrs)
%            YY   = Current state values
% 
%          Outputs:
% 
%            YP   = Current derivative values
% 
%   MEASUREMENT AND VALVE COMMON BLOCK

global XMEAS XMV  

%    DISTURBANCE VECTOR COMMON BLOCK

global NN
	
XMNS = 0; % Initialization by MWB
% 	NOTE: I have included isd in the /PV/ common.  This is set
% 		non-zero when the process is shutting down.
     global  UCLR UCVR UTLR UTVR...
     XLR XVR ETR ESR...
     TCR TKR DLR ...
     VLR VVR VTR ...
     PTR PPR...
     CRXR RR RH ...
     FWR TWR QUR HWR UAR...
     UCLS UCVS UTLS UTVS...
     XLS XVS ETS ESS...
     TCS TKS DLS...
     VLS VVS VTS...
     PTS PPS...
     FWS TWS QUS HWS...
     UCLC UTLC XLC...
     ETC ESC TCC DLC...
     VLC VTC QUC...
     UCVV UTVV XVV...
     ETV ESV TCV TKV...
     VTV PTV...
     VCV VRNG VTAU...
     FTM...
     FCM XST XMWS...
     HST TST SFR...
     CPFLMX CPPRMX CPDH...
     TCWR TCWS...
     HTR AGSP...
     XDEL XNS...
     TGAS TPROD VST IVST;
	 global...
     ADIST...
     BDIST...
     CDIST...
     DDIST...
     TLAST...
     TNEXT...
     HSPAN...
     HZERO...
     SSPAN...
     SZERO...
     SPSPAN...
     IDVWLK;
     global...
     AVP BVP CVP...
     AH BH CH...
     AG BG CG...
     AV...
     AD BD CD...
     XMW;
	 
for I = 1:20
	if IDV(I,1) > 0
    	IDV(I,1) = 1;
	else
		IDV(I,1) = 0;
	end
end

IDVWLK(1,1)=IDV(8,1);
IDVWLK(2,1)=IDV(8,1);
IDVWLK(3,1)=IDV(9,1);
IDVWLK(4,1)=IDV(10,1);
IDVWLK(5,1)=IDV(11,1);
IDVWLK(6,1)=IDV(12,1);
IDVWLK(7,1)=IDV(13,1);
IDVWLK(8,1)=IDV(13,1);
IDVWLK(9,1)=IDV(16,1);
IDVWLK(10,1)=IDV(17,1);
IDVWLK(11,1)=IDV(18,1);
IDVWLK(12,1)=IDV(20,1);
for I = 1:9
	if TIME >= TNEXT(I,1);
	HWLK=TNEXT(I,1)-TLAST(I,1);
    SWLK=ADIST(I,1)+HWLK*(BDIST(I,1)+HWLK*(CDIST(I,1)+HWLK*DDIST(I,1)));
    SPWLK=BDIST(I,1)+HWLK*(2*CDIST(I,1)+3*HWLK*DDIST(I,1));
    TLAST(I,1)=TNEXT(I,1);
	% TESUB5(SWLK,SPWLK,ADIST(I,1),BDIST(I,1),CDIST(I,1),DDIST(I,1),...
	% TLAST(I,1),TNEXT(I,1),HSPAN(I,1),HZERO(I,1),SSPAN(I,1),SZERO(I,1),...
	% SPSPAN(I,1),IDVWLK(I,1));
	% TESUB5(S,SP,ADIST,BDIST,CDIST,DDIST,
	% TLAST,TNEXT,HSPAN,HZERO,SSPAN,SZERO,...
	% SPSPAN,IDVFLAG) "VAL" added to subroutine variables.  "I" changed to "It".
	% Substitution of TESUB5 for call statement. MWB
	S5 = SWLK;
	SP5 = SPWLK;
	ADISTVAL = ADIST(I,1);
	BDISTVAL = BDIST(I,1);
	CDISTVAL = CDIST(I,1);
	DDISTVAL = DDIST(I,1);
	TLASTVAL = TLAST(I,1);
	TNEXTVAL = TNEXT(I,1);
	HSPANVAL = HSPAN(I,1);
	HZEROVAL = HZERO(I,1);
	SSPANVAL = SSPAN(I,1);
	SZEROVAL = SZERO(I,1);
	SPSPANVAL = SPSPAN(I,1);
	IDVFLAGVAL = IDVWLK(I,1);
	It = -1;
    H5 = HSPANVAL * TESUB7(It) + HZEROVAL;
    S1 = SSPANVAL * TESUB7(It) * IDVFLAGVAL + SZEROVAL;
    S1P = SPSPANVAL * TESUB7(It) * IDVFLAGVAL;
    ADISTVAL = S5;
    BDISTVAL = SP5;
    CDISTVAL = (3 * (S1 - S5) - H5 * (S1P + 2 * SP5)) / H5^2;
    DDISTVAL = (2 * (S5 - S1) + H5 * (S1P + SP5)) / H5^3;
    TNEXTVAL = TLASTVAL + H5;
	ADIST(I,1) = ADISTVAL; 
	BDIST(I,1) = BDISTVAL;
	CDIST(I,1) = CDISTVAL;
	DDIST(I,1) = DDISTVAL;
	TNEXT(I,1) = TNEXTVAL;  
	%
	% End of TESUB5
	%
	end
end
for I = 10:12
    if TIME >= TNEXT(I,1)
    HWLK = TNEXT(I,1) - TLAST(I,1);
    SWLK = ADIST(I,1) + HWLK * (BDIST(I,1) + HWLK * (CDIST(I,1) + HWLK * DDIST(I,1)));
    SPWLK = BDIST(I,1) + HWLK * (2 * CDIST(I,1) + 3 * HWLK * DDIST(I,1));
    TLAST(I,1) = TNEXT(I,1);
    	if SWLK > 0.1
      	ADIST(I,1) = SWLK;
      	BDIST(I,1) = SPWLK;
      	CDIST(I,1) = -(3 * SWLK + 0.2 * SPWLK) / 0.01;
      	DDIST(I,1) = (2 * SWLK + 0.1 * SPWLK) / 0.001;
      	TNEXT(I,1) = TLAST(I,1) + 0.1;
      	else
      	ISD = -1;
      	HWLK = HSPAN(I,1) * TESUB7(ISD) + HZERO(I,1);
     	ADIST(I,1) = 0;
      	BDIST(I,1) = 0;
      	CDIST(I,1) = (IDVWLK(I,1)) / HWLK^2;
      	DDIST(I,1) = 0;
      	TNEXT(I,1) = TLAST(I,1) + HWLK;
  		end
	end
end
if TIME == 0
	for I = 1:12
    ADIST(I,1)=SZERO(I,1);
    BDIST(I,1)=0;
    CDIST(I,1)=0;
    DDIST(I,1)=0;
    TLAST(I,1)=0.0;
    TNEXT(I,1)=0.1;
  	end
end

XST(1,4) = TESUB8(1,TIME) - IDV(1,1) * 0.03 - IDV(2,1) * 2.43719 * 10 ^ (-3);
XST(2,4) = TESUB8(2,TIME) + IDV(2,1) * 0.005;
XST(3,4) = 1 - XST(1,4) - XST(2,4);
TST(1,1) = TESUB8(3,TIME) + IDV(3,1) * 5;
TST(4,1) = TESUB8(4,TIME);
TCWR = TESUB8(5,TIME) + IDV(4,1) * 5;
TCWS = TESUB8(6,TIME) + IDV(5,1) * 5;
R1F = TESUB8(7,TIME);
R2F = TESUB8(8,TIME);
for I = 1:3
      UCVR(I,1)=YY(I,1);
      UCVS(I,1)=YY(I+9,1);
      UCLR(I,1)=0.0;
      UCLS(I,1)=0.0;
end
for I = 4:8
      UCLR(I,1) = YY(I,1);
      UCLS(I,1) = YY(I+9,1);
end
  
for I = 1:8
      UCLC(I,1) = YY(I+18,1);
      UCVV(I,1) = YY(I+27,1);
end
  
      ETR = YY(9,1);
      ETS = YY(18,1);
      ETC = YY(27,1);
      ETV = YY(36,1);
      TWR = YY(37,1);
      TWS = YY(38,1);
	  
%	  TWS shows an error here.  For the initialization,
%     it's value is  7.729698353000001e+01, when it should be
%     77.296983530000
	  
for I = 1:12
      VPOS(I,1) = YY(I+38,1);
end
      UTLR = 0.0;
      UTLS = 0.0;
      UTLC = 0.0;
      UTVV = 0.0;
	  
for I = 1:8
      UTLR = UTLR + UCLR(I,1);
      UTLS = UTLS + UCLS(I,1);
      UTLC = UTLC + UCLC(I,1);
      UTVV = UTVV + UCVV(I,1);
end
for I = 1:8
      XLR(I,1) = UCLR(I,1)/UTLR;
      XLS(I,1) = UCLS(I,1)/UTLS;
      XLC(I,1) = UCLC(I,1)/UTLC;
      XVV(I,1) = UCVV(I,1)/UTVV;
end
  
      ESR = ETR/UTLR;
      ESS = ETS/UTLS;
      ESC = ETC/UTLC;
      ESV = ETV/UTVV;
% Additional precision errors show up in XLR XLS XLC XVV ESR ESS ESC ESV 

%     TESUB2(XLR,TCR,ESR,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLR;
T = TCR;
H = ESR;
ITY = 0;
	  TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
    	HTEST = 0;
		for I = 1:8
      		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
      	HTEST = 0;
		for I = 1:8 
      		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HI = HI + AV(I,1);
      		HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
      	R1 = 3.57696 / 1000000;
     	HTEST = HTEST - R1 * (T + 273.15);
  	end
	%
	% End of TESUB1 sub
	%
	
    ERR = HTEST - H;
	
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
      	DH = 0.0;
    	for I = 1:8
      		DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
      	DH=0.0;
    	for I = 1:8
      		DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
      	R3 = 3.57696/1000000;
     	DH = DH - R3;
 	end
	%
	% End of TESUB3 substitution.
	%
    DT = -ERR / DH;
    T = T + DT;
  	if abs(DT) < 1*10^(-12)
    	break
  	end
  	if J == 100
  		T = TIN;
  	end
end
TCR = T;
% End of TESUB2.

      TKR = TCR+273.15;

%     TESUB2(XLS,TCS,ESS,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLS;
T = TCS;
H = ESS;
ITY = 0;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%	
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
 	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
   		DH = 0.0;
   		for I = 1:8
   			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
   			DHI = 1.8 * DHI;
   			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
   		DH=0.0;
   		for I = 1:8
   			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
   			DHI = 1.8 * DHI;
   			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
    	R3 = 3.57696/1000000;
    	DH = DH - R3;
  	end
	%
	% End of TESUB3 substitution.
	%
    DT = -ERR / DH;
    T = T + DT;
	if abs(DT) < 1*10^(-12)
    	break
  	end
	if J == 100
  		T = TIN;
  	end
end
TCS = T;
% End of TESUB2.

      TKS = TCS+273.15;
      
%     TESUB2(XLC,TCC,ESC,0);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XLC;
T = TCC;
H = ESC;
ITY = 0;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
		DH = 0.0;
    	for I = 1:8
			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
		DH=0.0;
		for I = 1:8
			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
		R3 = 3.57696/1000000;
		DH = DH - R3;
	end
	%
	% End of TESUB3 substitution.
	%
	DT = -ERR / DH;
	T = T + DT;
	if abs(DT) < 1*10^(-12)
		break
	end
	if J == 100
		T = TIN;
	end
end
TCC = T;
% End of TESUB2.
      
%     TESUB2(XVV,TCV,ESV,2);
%	  TESUB2(Z,T,H,ITY)
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
Z = XVV;
T = TCV;
H = ESV;
ITY = 2;
TIN=T;
for J = 1:100
	%      TESUB1(Z,T,HTEST,ITY);
	%	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
		HTEST = 0;
		for I = 1:8
			HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	else
		HTEST = 0;
		for I = 1:8 
			HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
			HI = 1.8 * HI;
			HI = HI + AV(I,1);
			HTEST = HTEST + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
		R1 = 3.57696 / 1000000;
		HTEST = HTEST - R1 * (T + 273.15);
	end
	%
	% End of TESUB1 sub
	%
	ERR = HTEST - H;
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
		DH = 0.0;
    	for I = 1:8
			DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
		DH=0.0;
    	for I = 1:8
			DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
			DHI = 1.8 * DHI;
			DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
		R3 = 3.57696/1000000;
		DH = DH - R3;
	end
	%
	% End of TESUB3 substitution.
	%
	DT = -ERR / DH;
	T = T + DT;
	if abs(DT) < 1*10^(-12)
		break
	end
	if J == 100
		T = TIN;
	end
end
TCV = T;
% End of TESUB2.
	  
TKV = TCV+273.15;
      
%	  TESUB4(XLR,TCR,DLR);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLR;
T4 = TCR;
R4 = DLR;
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLR = R4;
% End of TESUB4.

      
%	  TESUB4(XLS,TCS,DLS);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLS;
T4 = TCS;
R4 = DLS;
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLS = R4;
% End of TESUB4.
      
%	  TESUB4(XLC,TCC,DLC);
%	  TESUB4(X,T,R)
% Substitution of TESUB4 for call statement. MWB
X = XLC;
T4 = TCC;
R4 = DLC;
V = 0.0;
for I = 1:8
      V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T4) * T4);
end
R4 = 1.0 / V;
DLC = R4;
% End of TESUB4.
VLR = UTLR/DLR;
VLS = UTLS/DLS;
VLC = UTLC/DLC;
VVR = VTR-VLR;
VVS = VTS-VLS;
RG = 998.9;
PTR = 0.0;
PTS = 0.0;
for I = 1:3
      PPR(I,1) = UCVR(I,1)*RG*TKR/VVR;
      PTR = PTR+PPR(I,1);
      PPS(I,1) = UCVS(I,1)*RG*TKS/VVS;
      PTS = PTS+PPS(I,1);
  end
% Some precision error with PTS
for I = 4:8
      VPR=exp(AVP(I,1)+BVP(I,1)/(TCR+CVP(I,1)));
      PPR(I,1)=VPR*XLR(I,1);
      PTR=PTR+PPR(I,1);
      VPR=exp(AVP(I,1)+BVP(I,1)/(TCS+CVP(I,1)));
      PPS(I,1)=VPR*XLS(I,1);
      PTS=PTS+PPS(I,1);
  end
      PTV=UTVV*RG*TKV/VTV;
for I=1:8
      XVR(I,1)=PPR(I,1)/PTR;
      XVS(I,1)=PPS(I,1)/PTS;
end
UTVR=PTR*VVR/RG/TKR;
UTVS=PTS*VVS/RG/TKS;
for I=4:8
      UCVR(I,1)=UTVR*XVR(I,1);
      UCVS(I,1)=UTVS*XVS(I,1);
  end
  
% This is where the Matlab RR's show different values than the FORTRAN 77
% RR's.  The code below has been modified with the chop command to 
% elliminate the stray numbers that are created by the matlab code.
% Matlab:				FORTRAN 77:
% R1F
% 1						1.0000000000000
% R2F
% 1						1.0000000000000
% TKR
% 3.935500000017000e+02	393.55000000169
% RR(1,1)
% 3.181229946057000e-09	3.1812215872809D-09
% RR(2,1)
% 1.569591352140000e-10	1.5695892900646D-10
% RR(3,1)
% 7.437635682791000e-11	7.4376432806282D-11
% RR(4,1)
% 5.708298619084000e-11	5.7083044503356D-11
%
% NOTE:  I DID A COMPARISON OF THE EXP FUNCTIONS OF MATLAB
%        AND FORTRAN 77 AND THERE IS A CONSISTENT DISCREPANCY AT
%        10^-16 BETWEEN THE OUTPUT OF THE TWO LANGUAGES
%

R1F = chop(R1F,13);
R2F = chop(R2F,13);
TKR = chop(TKR,13);
RR(1,1)=chop(exp(31.5859536-40000.0/1.987/TKR)*R1F,13);
RR(2,1)=chop(exp(3.00094014-20000.0/1.987/TKR)*R2F,13);
RR(3,1)=chop(exp(53.4060443-60000.0/1.987/TKR),13);
RR(4,1)=chop(RR(3,1)*0.767488334,13);

% This next section has the following output:
% Matlab:				FORTRAN 77:
% PPR(1,1)
% 5.717769731191162e+03	5717.7697311912     * good
% PPR(3,1)
% 4.159943934675613e+03 4159.9439346756		* good
% R1F
% 2.174415112221978e+04 21744.151122220		* good
% R2F
% 2.247652526817436e+01 22.476525268174		* good
% RR(1,1)
% 3.517133031511259e-01 0.35171237901398	
% RR(2,1)
% 2.861611337089543e-01 0.28616075776025

if PPR(1,1) > 0.0 & PPR(3,1) > 0.0
      R1F=PPR(1,1)^1.1544;
      R2F=PPR(3,1)^0.3735;
      RR(1,1)=RR(1,1)*R1F*R2F*PPR(4,1);
      RR(2,1)=RR(2,1)*R1F*R2F*PPR(5,1);
  else
	  
      RR(1,1)=0.0;
      RR(2,1)=0.0;
  end
%
% This next section has the following output:
% Matlab:				FORTRAN 77:
% RR(1,1)
% 2.516069042865577e+02 251.60624318195
% RR(2,1)
% 2.047125210635105e+02 204.71225211921
% RR(3,1)
% 1.134874248863408e+00 1.1348754081821
% RR(4,1)
% 5.281888235868223e-02 5.2818936315249D-02
%
RR(3,1)=RR(3,1)*PPR(1,1)*PPR(5,1);
RR(4,1)=RR(4,1)*PPR(1,1)*PPR(4,1);
for I=1:4
    RR(I,1)=RR(I,1)*VVR;
end
%
% This next section has the following output:
% Matlab:					FORTRAN 77:
% CRXR(1,1)
% -4.574542995989316e+02	-457.45337070934
% CRXR(3,1)
% -4.563194253500682e+02	-456.31849530116
% CRXR(4,1)
% -2.516861326100957e+02	-251.68547158642
% CRXR(5,1)
% -2.058473953123739e+02	-205.84712752739
% CRXR(6,1)
% 1.187693131222090e+00		1.1876943444973
% CRXR(7,1)
% 2.516069042865577e+02		251.60624318195
% CRXR(8,1)
% 2.047125210635105e+02		204.71225211921
% RH
% 2.759494513807820e+01		27.594886078737
CRXR(1,1)=-RR(1,1)-RR(2,1)-RR(3,1);
CRXR(3,1)=-RR(1,1)-RR(2,1);
CRXR(4,1)=-RR(1,1)-1.5*RR(4,1);
CRXR(5,1)=-RR(2,1)-RR(3,1);
CRXR(6,1)=RR(3,1)+RR(4,1);
CRXR(7,1)=RR(1,1);
CRXR(8,1)=RR(2,1);
RH=RR(1,1)*HTR(1,1)+RR(2,1)*HTR(2,1);
XMWS(1,1)=0.0;
XMWS(2,1)=0.0;
XMWS(6,1)=0.0;
XMWS(8,1)=0.0;
XMWS(9,1)=0.0;
XMWS(10,1)=0.0;
%
% XST & XMWS seem to be calculated correcly in the next 
% section with little error.
%
for I=1:8
	  XST(I,6)=XVV(I,1);
	  XST(I,8)=XVR(I,1);
	  XST(I,9)=XVS(I,1);
      XST(I,10)=XVS(I,1);
      XST(I,11)=XLS(I,1);
      XST(I,13)=XLC(I,1);
      XMWS(1,1)=XMWS(1,1)+XST(I,1)*XMW(I,1);
      XMWS(2,1)=XMWS(2,1)+XST(I,2)*XMW(I,1);
      XMWS(6,1)=XMWS(6,1)+XST(I,6)*XMW(I,1);
      XMWS(8,1)=XMWS(8,1)+XST(I,8)*XMW(I,1);
      XMWS(9,1)=XMWS(9,1)+XST(I,9)*XMW(I,1);
      XMWS(10,1)=XMWS(10,1)+XST(I,10)*XMW(I,1);
  end
TST(6,1)=TCV;
TST(8,1)=TCR;
TST(9,1)=TCS;
TST(10,1)=TCS;
TST(11,1)=TCS;
TST(13,1)=TCC;

% The HST's from the following substitutions for TESUB1 are 
% computed correctly.

%
%      TESUB1(XST(1,1),TST(1,1),HST(1,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,1);
T=TST(1,1);
H=HST(1,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
	R1 = 3.57696 / 1000000;
	H = H - R1 * (T + 273.15);
end
HST(1,1) = H;
% end of TESUB1


%      TESUB1(XST(1,2),TST(2,1),HST(2,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,2);
T=TST(2,1);
H=HST(2,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(2,1) = H;
% end of TESUB1

%      TESUB1(XST(1,3),TST(3,1),HST(3,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,3);
T=TST(3,1);
H=HST(3,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(3,1) = H;
% end of TESUB1

%      TESUB1(XST(1,4),TST(4,1),HST(4,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,4);
T=TST(4,1);
H=HST(4,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(4,1) = H;
% end of TESUB1

%      TESUB1(XST(1,6),TST(6,1),HST(6,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,6);
T=TST(6,1);
H=HST(6,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(6,1) = H;
% end of TESUB1

%      TESUB1(XST(1,8),TST(8,1),HST(8,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,8);
T=TST(8,1);
H=HST(8,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(8,1) = H;
% end of TESUB1

%      TESUB1(XST(1,9),TST(9,1),HST(9,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,9);
T=TST(9,1);
H=HST(9,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(9,1) = H;
% end of TESUB1

      HST(10,1)=HST(9,1);
	  
%      TESUB1(XST(1,11),TST(11,1),HST(11,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,11);
T=TST(11,1);
H=HST(11,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
 		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(11,1) = H;
% end of TESUB1

%      TESUB1(XST(1,13),TST(13,1),HST(13,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,13);
T=TST(13,1);
H=HST(13,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(13,1) = H;
% end of TESUB1

% This next section is good.
FTM(1,1)=VPOS(1,1)*VRNG(1,1)/100.0;
FTM(2,1)=VPOS(2,1)*VRNG(2,1)/100.0;
FTM(3,1)=VPOS(3,1)*(1-IDV(6,1))*VRNG(3,1)/100.0;
FTM(4,1)=VPOS(4,1)*(1-IDV(7,1)*0.2)*VRNG(4,1)/100.0+1.E-10;
FTM(11,1)=VPOS(7,1)*VRNG(7,1)/100.0;
FTM(13,1)=VPOS(8,1)*VRNG(8,1)/100.0;
UAC=VPOS(9,1)*VRNG(9,1)*(1+TESUB8(9,TIME))/100.0;
FWR=VPOS(10,1)*VRNG(10,1)/100.0;
FWS=VPOS(11,1)*VRNG(11,1)/100.0;
AGSP=(VPOS(12,1)+150.0)/100.0;
DLP=PTV-PTR;

if DLP<0 
	DLP=0.0;
end
FLMS=1937.6*sqrt(DLP);
FTM(6,1)=FLMS/XMWS(6,1);
DLP=PTR-PTS;
if DLP<0 
	DLP=0.0;
end
FLMS=4574.21*sqrt(DLP)*(1-0.25*TESUB8(12,TIME));
FTM(8,1)=FLMS/XMWS(8,1);
DLP=PTS-760.0;
if DLP < 0 
	DLP=0.0;
end
FLMS=VPOS(6,1)*0.151169*sqrt(DLP);
FTM(10,1)=FLMS/XMWS(10,1);
PR=PTV/PTS;
if PR < 1
	PR=1.0;
end
if PR > CPPRMX
	PR=CPPRMX;
end
FLCOEF=CPFLMX/1.197;
FLMS=CPFLMX+FLCOEF*(1.0-PR^3);
CPDH=FLMS*(TCS+273.15)*1.8E-6*1.9872*(PTV-PTS)/(XMWS(9,1)*PTS);
DLP=PTV-PTS;
if DLP < 0.0
	DLP=0.0;
end
FLMS=FLMS-VPOS(5,1)*53.349*sqrt(DLP);
if FLMS < 1.E-3
	FLMS=1.E-3;
end
FTM(9,1)=FLMS/XMWS(9,1);
HST(9,1)=HST(9,1)+CPDH/FTM(9,1);
for I=1:8
      FCM(I,1)=XST(I,1)*FTM(1,1);
      FCM(I,2)=XST(I,2)*FTM(2,1);
      FCM(I,3)=XST(I,3)*FTM(3,1);
      FCM(I,4)=XST(I,4)*FTM(4,1);
      FCM(I,6)=XST(I,6)*FTM(6,1);
      FCM(I,8)=XST(I,8)*FTM(8,1);
      FCM(I,9)=XST(I,9)*FTM(9,1);
      FCM(I,10)=XST(I,10)*FTM(10,1);
      FCM(I,11)=XST(I,11)*FTM(11,1);
      FCM(I,13)=XST(I,13)*FTM(13,1);
  end

if FTM(11,1) > 0.1
	if TCC > 170
		TMPFAC=TCC-120.262;
	elseif TCC < 5.292
		TMPFAC=0.1;
	else
		TMPFAC=363.744/(177.-TCC)-2.22579488;
	end
	VOVRL=FTM(4,1)/FTM(11,1)*TMPFAC;
	SFR(4,1)=8.5010*VOVRL/(1.0+8.5010*VOVRL);
	SFR(5,1)=11.402*VOVRL/(1.0+11.402*VOVRL);
	SFR(6,1)=11.795*VOVRL/(1.0+11.795*VOVRL);
	SFR(7,1)=0.0480*VOVRL/(1.0+0.0480*VOVRL);
	SFR(8,1)=0.0242*VOVRL/(1.0+0.0242*VOVRL);
else
	SFR(4,1)=0.9999;
	SFR(5,1)=0.999;
	SFR(6,1)=0.999;
	SFR(7,1)=0.99;
	SFR(8,1)=0.98;
end
for I=1:8
      FIN(I,1)=0.0;
      FIN(I,1)=FIN(I,1)+FCM(I,4);
      FIN(I,1)=FIN(I,1)+FCM(I,11);
  end

FTM(5,1)=0.0;
FTM(12,1)=0.0;
for I=1:8
      FCM(I,5)=SFR(I,1)*FIN(I,1);
      FCM(I,12)=FIN(I,1)-FCM(I,5);
      FTM(5,1)=FTM(5,1)+FCM(I,5);
      FTM(12,1)=FTM(12,1)+FCM(I,12);
end
for I=1:8
      XST(I,5)=FCM(I,5)/FTM(5,1);
      XST(I,12)=FCM(I,12)/FTM(12,1);
end
TST(5,1)=TCC;
TST(12,1)=TCC;
%      TESUB1(XST(1,5),TST(5,1),HST(5,1),1);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,5);
T=TST(5,1);
H=HST(5,1);
ITY=1;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
      R1 = 3.57696 / 1000000;
      H = H - R1 * (T + 273.15);
end
HST(5,1) = H;
% end of TESUB1

%      TESUB1(XST(1,12),TST(12,1),HST(12,1),0);
%	   TESUB1(Z,T,H,ITY)
% Substitution of TESUB1 for call statement. MWB
Z(1:8,1)=XST(1:8,12);
T=TST(12,1);
H=HST(12,1);
ITY=0;
if ITY == 0
	H = 0;
	for I = 1:8
		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
else
	H = 0;
	for I = 1:8 
		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
		HI = 1.8 * HI;
		HI = HI + AV(I,1);
		H = H + Z(I,1) * XMW(I,1) * HI;
	end
end
if ITY == 2
	R1 = 3.57696 / 1000000;
	H = H - R1 * (T + 273.15);
end
HST(12,1) = H;
% end of TESUB1

FTM(7,1)=FTM(6,1);
HST(7,1)=HST(6,1);
TST(7,1)=TST(6,1);

for I=1:8
	
      XST(I,7)=XST(I,6);
      FCM(I,7)=FCM(I,6);
end

if VLR/7.8 > 50.0
	UARLEV=1.0;
elseif VLR/7.8 < 10.0
    UARLEV=0.0;
else
      UARLEV=0.025*VLR/7.8-0.25;
  end
  
UAR=UARLEV*(-0.5*AGSP^2+2.75*AGSP-2.5)*855490.E-6;
QUR=UAR*(TWR-TCR)*(1-0.35*TESUB8(10,TIME));
UAS=0.404655*(1.0-1.0/(1.0+(FTM(8,1)/3528.73)^4));
QUS=UAS*(TWS-TST(8,1))*(1-0.25*TESUB8(11,TIME));
QUC=0;

if TCC < 100
	QUC=UAC*(100.0-TCC);
end
      XMEAS(1,1)=FTM(3,1)*0.359/35.3145;
      XMEAS(2,1)=FTM(1,1)*XMWS(1,1)*0.454;
      XMEAS(3,1)=FTM(2,1)*XMWS(2,1)*0.454;
      XMEAS(4,1)=FTM(4,1)*0.359/35.3145;
      XMEAS(5,1)=FTM(9,1)*0.359/35.3145;
      XMEAS(6,1)=FTM(6,1)*0.359/35.3145;
      XMEAS(7,1)=(PTR-760.0)/760.0*101.325;
      XMEAS(8,1)=(VLR-84.6)/666.7*100.0;
      XMEAS(9,1)=TCR;
      XMEAS(10,1)=FTM(10,1)*0.359/35.3145;
      XMEAS(11,1)=TCS;
      XMEAS(12,1)=(VLS-27.5)/290.0*100.0;
      XMEAS(13,1)=(PTS-760.0)/760.0*101.325;
      XMEAS(14,1)=FTM(11,1)/DLS/35.3145;
      XMEAS(15,1)=(VLC-78.25)/VTC*100.0;
      XMEAS(16,1)=(PTV-760.0)/760.0*101.325;
      XMEAS(17,1)=FTM(13,1)/DLC/35.3145;
      XMEAS(18,1)=TCC;
      XMEAS(19,1)=QUC*1.04E3*0.454;
      XMEAS(20,1)=CPDH*0.0003927E6;
      XMEAS(20,1)=CPDH*0.29307E3;
      XMEAS(21,1)=TWR;
      XMEAS(22,1)=TWS;
	 ISD=0;
if XMEAS(7,1) > 3000.0
	ISD=1;
	end
if VLR/35.3145 > 24.0
	ISD=1;
	end
if VLR/35.3145 < 2.0
	ISD=1;
	end
if XMEAS(9,1) > 175.0
	ISD=1;
	end
if VLS/35.3145 > 12.0
	ISD=1;
	end
if VLS/35.3145 < 1.0
	ISD=1;
	end
if VLC/35.3145 > 8.0
	ISD=1;
	end
if VLC/35.3145 < 1.0
	ISD=1;
	end
if TIME > 0.0 & ISD == 0
	for I=1:22
		%      TESUB6(XNS(I,1),XMNS)
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter =1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6.

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
	end
end
      XCMP(23,1)=XST(1,7)*100.0;
      XCMP(24,1)=XST(2,7)*100.0;
      XCMP(25,1)=XST(3,7)*100.0;
      XCMP(26,1)=XST(4,7)*100.0;
      XCMP(27,1)=XST(5,7)*100.0;
      XCMP(28,1)=XST(6,7)*100.0;
      XCMP(29,1)=XST(1,10)*100.0;
      XCMP(30,1)=XST(2,10)*100.0;
      XCMP(31,1)=XST(3,10)*100.0;
      XCMP(32,1)=XST(4,10)*100.0;
      XCMP(33,1)=XST(5,10)*100.0;
      XCMP(34,1)=XST(6,10)*100.0;
      XCMP(35,1)=XST(7,10)*100.0;
      XCMP(36,1)=XST(8,10)*100.0;
      XCMP(37,1)=XST(4,13)*100.0;
      XCMP(38,1)=XST(5,13)*100.0;
      XCMP(39,1)=XST(6,13)*100.0;
      XCMP(40,1)=XST(7,13)*100.0;
      XCMP(41,1)=XST(8,13)*100.0;
	  
if TIME == 0
	for I=23:41
		XDEL(I,1)=XCMP(I,1);
		XMEAS(I,1)=XCMP(I,1);
	end

	TGAS=0.1;
	TPROD=0.25;
end
if TIME >= TGAS
	for I=23:36
		XMEAS(I,1)=XDEL(I,1);
		%      TESUB6(XNS(I,1),XMNS);
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter=1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
		XDEL(I,1)=XCMP(I,1);
	end
	TGAS=TGAS+0.1;
end
 
if TIME >= TPROD
	for I=37:41
		XMEAS(I,1)=XDEL(I,1);
      
		%      TESUB6(XNS(I,1),XMNS)
		%      TESUB6(STD,X)
		% Substitution of TESUB6 for call statement. MWB
		STD = XNS(I,1);
		X = XMNS;
		X = 0;
		for Iter=1:12
			X = X + TESUB7(Iter);
		end
		X = (X - 6) * STD;
		XMNS = X;
		% End of TESUB6

		XMEAS(I,1)=XMEAS(I,1)+XMNS;
		XDEL(I,1)=XCMP(I,1);
	end
	TPROD=TPROD+0.25;
end
% 
for iter = 1:8
      YP(iter,1) = FCM(iter,7) - FCM(iter,8) + CRXR(iter,1);
      YP(iter+9,1) = FCM(iter,8) - FCM(iter,9) - FCM(iter,10) - FCM(iter,11);
      YP(iter+18,1) = FCM(iter,12) - FCM(iter,13);
      YP(iter+27,1) = FCM(iter,1) + FCM(iter,2) + FCM(iter,3) + FCM(iter,5) + FCM(iter,9) - FCM(iter,6);
  end
  
% 		Here is the "correct" version of the separator energy balance:
% 
% 	YP(18)=HST(8)*FTM(8)-(HST(9)*FTM(9)-cpdh)-HST(10)*FTM(10)-HST(11)*FTM(11)+QUS
% 
%   	Here is the original version
	  YP(9,1)=HST(7,1) * FTM(7,1) - HST(8) * FTM(8) + RH + QUR;
      YP(18,1)=HST(8,1)*FTM(8,1)-HST(9,1)*FTM(9,1)-HST(10,1)*FTM(10,1)-HST(11,1)*FTM(11,1)+QUS;
      YP(27,1)=HST(4,1)*FTM(4,1)+HST(11,1)*FTM(11,1)-HST(5,1)*FTM(5,1)-HST(13,1)*FTM(13,1)+QUC;
      YP(36,1)=HST(1,1)*FTM(1,1)+HST(2,1)*FTM(2,1)+HST(3,1)*FTM(3,1)+HST(5,1)*FTM(5,1)+HST(9,1)*FTM(9,1)-HST(6,1)*FTM(6,1);
      YP(37,1)=(FWR*500.53*(TCWR-TWR)-QUR*1000000/1.8)/HWR;
      YP(38,1)=(FWS*500.53*(TCWS-TWS)-QUS*1000000/1.8)/HWS;
      IVST(10,1)=IDV(14,1);
      IVST(11,1)=IDV(15,1);
      IVST(5,1)=IDV(19,1);
      IVST(7,1)=IDV(19,1);
      IVST(8,1)=IDV(19,1);
      IVST(9,1)=IDV(19,1);
for I=1:12
	if TIME == 0 | abs(VCV(I,1)-XMV(I,1)) > VST(I,1)*IVST(I,1)
		VCV(I,1)=XMV(I,1);
	end
	if VCV(I,1) < 0.0
		VCV(I,1)=0.0;
	end
	if VCV(I,1) > 100.0
		VCV(I,1)=100.0;
	end
	YP(I+38,1)=(VCV(I,1)-VPOS(I,1))/VTAU(I,1);
end
if TIME > 0.0 & ISD ~= 0
	for I=1:NN
		YP(I,1)=0.0;
	end
end
% This is the final output of the subroutine:
% Everything up to this point (except what has been
% documented in the code) runs very similar to the FORTRAN 77
% version. MWB 
%  7/12/98
%  Matlab:						FORTRAN77:
%  YY
% 	   1.040491389000000e+01     1.040491389000000e+01
%      4.363996017000000e+00     4.363996017000000e+00
%      7.570059737000000e+00     7.570059737000000e+00
%      4.230042431000000e-01     4.230042431000000e-01
%      2.415513437000000e+01     2.415513437000000e+01
%      2.942597645000000e+00     2.942597645000000e+00
%      1.543770655000000e+02     1.543770655000000e+02
%      1.591865960000000e+02     1.591865960000000e+02
%      2.808522723000000e+00     2.808522723000000e+00
%      6.375581199000000e+01     6.375581199000000e+01
%      2.674026066000000e+01     2.674026066000000e+01
%      4.638532432000000e+01     4.638532432000000e+01
%      2.464521543000000e-01     2.464521543000000e-01
%      1.520484404000000e+01     1.520484404000000e+01
%      1.852266172000000e+00     1.852266172000000e+00
%      5.244639459000000e+01     5.244639459000000e+01
%      4.120394008000000e+01     4.120394008000000e+01
%      5.699317760000000e-01     5.699317760000000e-01
%      4.306056376000000e-01     4.306056376000000e-01
%      7.990620078300001e-03     7.990620078300001e-03
%      9.056036089000000e-01     9.056036089000000e-01
%      1.605425821600000e-02     1.605425821600000e-02
%      7.509759687000001e-01     7.509759687000001e-01
%      8.858285595500000e-02     8.858285595500000e-02
%      4.827726193000000e+01     4.827726193000000e+01
%      3.938459028000000e+01     3.938459028000000e+01
%      3.755297257000000e-01     3.755297257000000e-01
%      1.077562698000000e+02     1.077562698000000e+02
%      2.977250546000000e+01     2.977250546000000e+01
%      8.832481135000000e+01     8.832481135000000e+01
%      2.303929507000000e+01     2.303929507000000e+01
%      6.285848794000000e+01     6.285848794000000e+01
%      5.546318688000000e+00     5.546318688000000e+00
%      1.192244772000000e+01     1.192244772000000e+01
%      5.555448243000000e+00     5.555448243000000e+00
%      9.218489761999999e-01     9.218489761999999e-01
%      9.459927549000000e+01     9.459927549000000e+01
%      7.729698353000001e+01     7.729698353000001e+01
%      6.305263039000000e+01     6.305263039000000e+01
%      5.397970677000000e+01     5.397970677000000e+01
%      2.464355755000000e+01     2.464355755000000e+01
%      6.130192144000000e+01     6.130192144000000e+01
%      2.221000000000000e+01     2.221000000000000e+01
%      4.006374673000000e+01     4.006374673000000e+01
%      3.810034370000000e+01     3.810034370000000e+01
%      4.653415582000000e+01     4.653415582000000e+01
%      4.744573456000000e+01     4.744573456000000e+01
%      4.110581288000000e+01     4.110581288000000e+01
%      1.811349055000000e+01     1.811349055000000e+01
%      5.000000000000000e+01     5.000000000000000e+01
%   YP:
%     -9.311351132055279e-04    -2.245521557142600e-06 <- Sig Dif
%     -3.680818849716161e-07    -3.680818849716200e-07
%     -9.313903218526320e-04    -1.341411575595000e-06 <- Sig Dif
%     -6.614342966599907e-04    -4.106221069832800e-07 <- Sig Dif
%     -2.689011108429895e-04    -1.116128657940900e-06 <- Sig Dif
%     -1.312917689233473e-06    -9.964246872051801e-08 <- Sig Dif
%      6.609202557683602e-04    -1.843536381329600e-07 <- Sig Dif
%      2.688889922808357e-04    -5.530856128643800e-08 <- Sig Dif
%      5.904527482059052e-05    -1.406638006074000e-08 <- Sig Dif
%     -3.216924339355387e-06    -3.216923774473900e-06
%     -1.320602298626739e-06    -1.320602072141200e-06
%     -2.292647105051060e-06    -2.292646652080100e-06
%     -1.172087313872083e-07    -1.172087100709300e-07
%     -1.564706110457337e-06    -1.564705769396800e-06
%     -2.046840421598972e-07    -2.046840066327600e-07
%     -3.064993734369637e-07    -3.064992597501300e-07
%     -1.538568028536247e-07    -1.538566607450800e-07
%     -3.970321582613678e-08    -3.970320694435300e-08
%     -2.569517931760856e-10    -2.569517931760900e-10
%     -2.359501483084614e-13    -2.359501483084600e-13
%     -1.614086642121038e-10    -1.614086642121000e-10
%     -1.656258463711424e-11    -1.656258463711400e-11
%     -1.189860210359939e-09    -1.189860210359900e-09
%     -1.897565438113702e-11    -1.897565438113700e-11
%     -4.671457531912893e-08    -4.671457531912900e-08
%     -1.934833449013240e-08    -1.934833449013200e-08
%     -2.352361638813250e-10    -2.352361638813200e-10
%      5.300687917042524e-06     5.300687462295200e-06
%      1.688940415078832e-06     1.688940187705200e-06
%      3.474454388197046e-06     3.474453933449700e-06
%      4.445469699021487e-07     4.445469699021500e-07
%      2.613836613818421e-06     2.613836272757900e-06
%      3.049074734917667e-07     3.049074308592000e-07
%      5.932505473538185e-07     5.932504336669800e-07
%      3.048364050073360e-07     3.048362486879300e-07
%      5.976254513484491e-08     5.976253802941801e-08
%     -4.380748794538104e-07    -4.380756709460800e-07
%      3.318385615567584e-07     3.318384779400800e-07
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0
%                          0                         0

% End of TEFUNC

sys = YP;
end

% end mdlDerivatives


%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
end
function sys = mdlOutputs(t,x,u)
global XMEAS YY
YY = x;
sys = XMEAS;
end
% end mdlOutputs

function TESUB8VAL = TESUB8(I,T)
%       DOUBLE PRECISION  H,T
%       DOUBLE PRECISION
%      .ADIST,
%      .BDIST,
%      .CDIST,
%      .DDIST,
%      .TLAST,
%      .TNEXT,
%      .HSPAN,
%      .HZERO,
%      .SSPAN,
%      .SZERO,
%      .SPSPAN
      global ADIST BDIST CDIST DDIST TLAST TNEXT...
      HSPAN HZERO SSPAN SZERO SPSPAN IDVWLK;
	  H = T - TLAST(I,1);
      TESUB8VAL = ADIST(I,1) + H * (BDIST(I,1) + H * (CDIST(I,1) + H * DDIST(I,1)));
      return
end


function [y] = chop ( x , t )
        y = x - mod ( x * 10^(t-1), 1 ) * 10^( -(t-1) );
        return 
end

function TESUB7VAL = TESUB7(I);
      global G;
      G = rem(G * 9228907,4294967296);
	  if I >= 0;
      TESUB7VAL = G / 4294967296;
	  else
	  TESUB7VAL = 2 * G / 4294967296 - 1;
      return
      end
end

      %	  TESUB4(XLR,TCR,DLR);
function R = TESUB4(X,T,R,AD,BD,CD,XMW);
% Substitution of TESUB4 for call statement. MWB
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T) * T);
end
R = 1.0 / V;
% End of TESUB4.
end

function DH = TESUB3(Z,T,DH,ITY,AH,BH,CH,AG,BG,CG,XMW);
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
      	DH = 0.0;
    	for I = 1:8
      		DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
      	DH=0.0;
    	for I = 1:8
      		DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
      	R3 = 3.57696/1000000;
     	DH = DH - R3;
 	end
	%
	% End of TESUB3 substitution.
	%
end

%     TESUB2(XLR,TCR,ESR,0);
function T = TESUB2(Z,T,H,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
	  TIN=T;
for J = 1:100
	HTEST = TESUB1(Z,T,HTEST,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
   ERR = HTEST - H;
	
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
   %		TESUB3VAL = TESUB3(Z,T,DH,ITY)
   DH = TESUB3(Z,T,DH,ITY,AH,BH,CH,AG,BG,CG,XMW);
	    DT = -ERR / DH;
    T = T + DT;
  	if abs(DT) < 1*10^(-12)
    	break
  	end
  	if J == 100
  		T = TIN;
  	end
end
% End of TESUB2.
end

function      H = TESUB1(Z,T,H,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
   %	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
    	H = 0;
		for I = 1:8
      		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		H = H + Z(I,1) * XMW(I,1) * HI;
		end
	else
      	H = 0;
		for I = 1:8 
      		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HI = HI + AV(I,1);
      		H = H + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
      	R1 = 3.57696 / 1000000;
     	H = H - R1 * (T + 273.15);
  	end
	%
	% End of TESUB1 sub
	%
end

