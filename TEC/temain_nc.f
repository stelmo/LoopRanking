C               Tennessee Eastman Process Control Test Problem
C
C                    James J. Downs and Ernest F. Vogel
C
C                  Process and Control Systems Engineering
C                        Tennessee Eastman Company
C                              P.O. Box 511
C                          Kingsport, TN  37662
C
C
C  Reference:
C    "A Plant-Wide Industrial Process Control Problem"
C    Presented at the AIChE 1990 Annual Meeting
C    Industrial Challenge Problems in Process Control, Paper #24a
C    Chicago, Illinois, November 14, 1990
C
C    "A Plant-Wide Industrial Process Control Problem"
C    Computers and Chemical Engineering, Vol. 17, No. 3, pp. 245-255
C    (1993).
C    
C
C  Main program for demonstrating application of the Tennessee Eastman
C  Process Control Test Problem
C
C
C=============================================================================
C
C
C  MEASUREMENT AND VALVE COMMON BLOCK
C
      DOUBLE PRECISION XMEAS, XMV
      COMMON/PV/ XMEAS(41), XMV(12)
C
C   DISTURBANCE VECTOR COMMON BLOCK
C
      INTEGER IDV
      COMMON/DVEC/ IDV(20)
C
C
C  Local Variables
C
      INTEGER I, NN, NPTS
C
      DOUBLE PRECISION TIME, YY(50), YP(50)
C
C  Set the number of differential equations (states).  The process has 50
C  states.  If the user wishes to integrate additional states, NN must be
C  increased by the number of additional differential equations.
C
      NN = 50
C
C  Set the number of points to simulate
C
      NPTS = 17280
C
C  Integrator Step Size:  1 Second Converted to Hours
C
      DELTAT = 1. / 3600.
C
C  Initialize Process
C  (Sets TIME to zero)
C
      CALL TEINIT(NN,TIME,YY,YP)
C

C Is this okay for specifying the input vector?
 	XMV(1) = 63.053 + 0.
	XMV(2) = 53.980 + 0.
	XMV(3) = 24.644 + 0.    
	XMV(4) = 61.302 + 0.
	XMV(5) = 22.210 + 0.
	XMV(6) = 40.064 + 0.
	XMV(7) = 38.100 + 0.
	XMV(8) = 46.534 + 0.
	XMV(9) = 47.446 + 0.
	XMV(10)= 41.106 + 0.
	XMV(11)= 50.0 + 0.
	
C Open the write files

	OPEN(UNIT=111,FILE='output/TE_data_inc.dat',STATUS='new')
	OPEN(UNIT=1111,FILE='output/TE_data_mv1.dat',STATUS='new')
	OPEN(UNIT=1112,FILE='output/TE_data_mv2.dat',STATUS='new')
	OPEN(UNIT=1113,FILE='output/TE_data_mv3.dat',STATUS='new')
	OPEN(UNIT=2111,FILE='output/TE_data_me01.dat',STATUS='new')
	OPEN(UNIT=2112,FILE='output/TE_data_me02.dat',STATUS='new')
	OPEN(UNIT=2113,FILE='output/TE_data_me03.dat',STATUS='new')
	OPEN(UNIT=2114,FILE='output/TE_data_me04.dat',STATUS='new')
	OPEN(UNIT=2115,FILE='output/TE_data_me05.dat',STATUS='new')
	OPEN(UNIT=2116,FILE='output/TE_data_me06.dat',STATUS='new')
	OPEN(UNIT=2117,FILE='output/TE_data_me07.dat',STATUS='new')
	OPEN(UNIT=2118,FILE='output/TE_data_me08.dat',STATUS='new')
	OPEN(UNIT=2119,FILE='output/TE_data_me09.dat',STATUS='new')
	OPEN(UNIT=2120,FILE='output/TE_data_me10.dat',STATUS='new')
	OPEN(UNIT=2121,FILE='output/TE_data_me11.dat',STATUS='new')

C
C  Set all Disturbance Flags to OFF
C
      DO 100 I = 1, 20
          IDV(I) = 0
 100  CONTINUE
C
C  Simulation Loop: what is that 1000 doing there?
C
      DO 1000 I = 1, NPTS
C
C
          CALL OUTPUT
C
          CALL INTGTR(NN,TIME,DELTAT,YY,YP)
C
 1000 CONTINUE
C
 	CLOSE(UNIT=111)
	CLOSE(UNIT=1111)
	CLOSE(UNIT=1112)
	CLOSE(UNIT=1113)
	CLOSE(UNIT=2111)
	CLOSE(UNIT=2112)
	CLOSE(UNIT=2113)
	CLOSE(UNIT=2114)
	CLOSE(UNIT=2115)
	CLOSE(UNIT=2116)
	CLOSE(UNIT=2117)
	CLOSE(UNIT=2118)
	CLOSE(UNIT=2119)
	CLOSE(UNIT=2120)
  	CLOSE(UNIT=2121)

      STOP
      END
C
C=============================================================================
C No control

C
C=============================================================================
C
      SUBROUTINE OUTPUT
C
C
C   MEASUREMENT AND VALVE COMMON BLOCK
C
      DOUBLE PRECISION XMEAS, XMV
      COMMON/PV/ XMEAS(41), XMV(12)
C
        WRITE(1111,*) XMV(1), XMV(2), XMV(3), XMV(4)
      	WRITE(1112,*) XMV(5), XMV(6), XMV(7), XMV(8)
      	WRITE(1113,*) XMV(9), XMV(10), XMV(11), XMV(12)
      	WRITE(2111,*) XMEAS(1), XMEAS(2), XMEAS(3), XMEAS(4)
      	WRITE(2112,*) XMEAS(5), XMEAS(6), XMEAS(7), XMEAS(8)
      	WRITE(2113,*) XMEAS(9), XMEAS(10), XMEAS(11), XMEAS(12)
     	WRITE(2114,*) XMEAS(13), XMEAS(14), XMEAS(15), XMEAS(16)
      	WRITE(2115,*) XMEAS(17), XMEAS(18), XMEAS(19), XMEAS(20)
      	WRITE(2116,*) XMEAS(21), XMEAS(22), XMEAS(23), XMEAS(24)
      	WRITE(2117,*) XMEAS(25), XMEAS(26), XMEAS(27), XMEAS(28)
      	WRITE(2118,*) XMEAS(29), XMEAS(30), XMEAS(31), XMEAS(32)
      	WRITE(2119,*) XMEAS(33), XMEAS(34), XMEAS(35), XMEAS(36)
      	WRITE(2120,*) XMEAS(37), XMEAS(38), XMEAS(39), XMEAS(40)
      	WRITE(2121,*) XMEAS(41)
 100  FORMAT(1X,E13.5,2X,E13.5,2X,E13.5,2X,E13.5)
 200  FORMAT(1X,E13.5,2X,E13.5,2X,E13.5)
 300  FORMAT(1X,E13.5)
 
C
      RETURN
      END
C
C=============================================================================
C
      SUBROUTINE INTGTR(NN,TIME,DELTAT,YY,YP)
C
C  Euler Integration Algorithm
C
C
      INTEGER I, NN
C
      DOUBLE PRECISION TIME, DELTAT, YY(NN), YP(NN)
C
      CALL TEFUNC(NN,TIME,YY,YP)
C
      TIME = TIME + DELTAT
C
      DO 100 I = 1, NN
C
          YY(I) = YY(I) + YP(I) * DELTAT
C
 100  CONTINUE
C
      RETURN
      END
