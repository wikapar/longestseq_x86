EXEFILE = longestseq64
OBJECTS = longestseq64.o main.o
CCFMT = -m64
NASMFMT = -f elf64
CCOPT = -g
NASMOPT = -g -w+all

.c.o:
	cc $(CCFMT) $(CCOPT) -c $<

.s.o:
	nasm $(NASMFMT) $(NASMOPT) -l $*.lst $<

$(EXEFILE): $(OBJECTS)
	cc $(CCFMT) $(CCOPT) -o $@ $^

clean:
	rm -f *.o *.lst $(EXEFILE)