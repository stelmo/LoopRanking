all: temain.exe temain_mod.exe

run: temain.exe
		temain.exe

%.exe: %.f tecommon.inc teprob.o
	gfortran $< teprob.o -o $@

teprob.o: teprob.f
	gfortran -c $<

clean:
	-del temain.exe teprob.o
	
.PHONY: clean run
