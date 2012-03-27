function [outvec] = octavedriver(inputchangeid,numberofhours)

% Call with flag=0 to initialise

flag.initialise = 0;
flag.derivatives = 1;
flag.outputs = 3;

[sizes,x0,str,ts] = TESFUNCo(0, 0, 0, 0);

x = x0;
dt = 1/3600;
N = 60*60*numberofhours; %takes from method parameters

% Inputs.  These should be real values - check the Fortran source or
% the document
% u = ones(sizes.NumInputs, 1);

u = [0;%     IDV(1,1)   A/C Feed Ratio, B Composition Constant (Stream 4)          Step
	0;%     IDV(1,2)   B Composition, A/C Ratio Constant (Stream 4)               Step
	0;%     IDV(1,3)   D Feed Temperature (Stream 2)                              Step
	0;%     IDV(1,4)   Reactor Cooling Water Inlet Temperature                    Step
	0;%     IDV(1,5)   Condenser Cooling Water Inlet Temperature                  Step
	0;%     IDV(1,6)   A Feed Loss (Stream 1)                                     Step
	0;%     IDV(1,7)   C Header Pressure Loss - Reduced Availability (Stream 4)   Step
	0;%     IDV(1,8)   A, B, C Feed Composition (Stream 4)            Random Variation
	0;%     IDV(1,9)   D Feed Temperature (Stream 2)                  Random Variation
	0;%     IDV(1,10)  C Feed Temperature (Stream 4)                  Random Variation
	0;%     IDV(1,11)  Reactor Cooling Water Inlet Temperature        Random Variation
	0;%     IDV(1,12)  Condenser Cooling Water Inlet Temperature      Random Variation
	0;%     IDV(1,13)  Reaction Kinetics                                    Slow Drift
	0;%     IDV(1,14)  Reactor Cooling Water Valve                            Sticking
	0;%     IDV(1,15)  Condenser Cooling Water Valve                          Sticking
	0;%     IDV(1,16)  Unknown
	0;%     IDV(1,17)  Unknown
	0;%     IDV(1,18)  Unknown
	0;%     IDV(1,19)  Unknown
	0;%     IDV(1,20)  Unknown
	63.053; %      XMV(1,1)     D Feed Flow (stream 2)            (Corrected Order)
	53.98; %         XMV(1,2)     E Feed Flow (stream 3)            (Corrected Order)
	24.644; %       XMV(1,3)     A Feed Flow (stream 1)            (Corrected Order)
	61.302; %      XMV(1,4)     A and C Feed Flow (stream 4)
	22.21; %     XMV(1,5)     Compressor Recycle Valve (stream 8)
	40.046; %       XMV(1,6)     Purge Valve (stream 9)
	38.1; %      XMV(1,7)     Separator Pot Liquid Flow (stream 10)
	46.534; %      XMV(1,8)     Stripper Liquid Product Flow (stream 11)
	47.446; %      XMV(1,9)     Stripper Steam Valve
	41.106; %       XMV(1,10)    Reactor Cooling Water Flow
	18.114; %       XMV(1,11)    Condenser Cooling Water Flow
	50]; %      XMV(1,12)    Agitator Speed
	
%now change u according to method parameters
%this switch looks like this in case I want to change the "steps" to something other than 100...
switch (inputchangeid)
	case 1
		u(21) = 100;
	case 2
		u(22) = 100;
	case 3
		u(23) = 100;
	case 4
		u(24) = 100;
	case 5
		u(25) = 100;
	case 6
		u(26) = 100;
	case 7
		u(27) = 100;
	case 8
		u(28) = 100;
	case 9
		u(29) = 100;
	case 10
		u(30) = 100;
	case 11
		u(31) = 100;
	case 12
		u(32) = 100;
endswitch
	
%          
%  u   +---------------------+  y
% ---->| x (internal states) |------>
%      +---------------------+
starttime = time;
% Euler integration
t = 0;
yplot = [];
for i = 1:N
    % Calculate derivatives
    dx = TESFUNCo(t, x, u, flag.derivatives);
    % Calculate outputs
    y = TESFUNCo(t, x, u, flag.outputs);
    yplot = [yplot y]; % store outputs
    % Integrate
    x = x + dt*dx;
    t = t + dt;
end
endtime = time;
% plot(0:dt:(t-dt), yplot')
% plot(yplot')
% pause(10)
% timetaken = endtime- starttime
arr = yplot';
outvec = arr(end,:)';

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
endfunction
