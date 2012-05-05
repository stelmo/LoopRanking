executables=$(addsuffix .exe,temain temain_mod temain_nc temain_out)

all: $(executables)

run: temain.exe
		temain.exe

%.exe: %.f tecommon.inc teprob.o
	gfortran $< teprob.o -o $@

teprob.o: teprob.f
	gfortran -c $<

clean:
	-del $(executables) teprob.o

.PHONY: clean run
