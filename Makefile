EXEFILE = longestseq
OBJECTS = longestseq.o main.o
CCFMT = -m32
NASMFMT = -f elf32
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