
SOURCES:= romst.pld


SRC := $(SOURCES:%.pld=source/%.pld)
JED := $(SOURCES:%.pld=jedec/%.jed)
CUPL = LIBCUPL=C:\\Wincupl\\Shared\\cupl.dl WINEDEBUG=-all wine c:Wincupl/Shared/cupl.exe
OPT  = 1

all: $(JED)

jedec/%.jed: source/%.pld Makefile
	sed -e s/DEFINE\ ROMY_REVISION/DEFINE\ ROMY_REV10/ -e s/DEFINE\ ROMY_SIZE/DEFINE\ ROMY_1MB/ $< > jedec/romst_rev10_1mb.pld
	$(CUPL) -jm$(OPT) $(LIBCUPL) jedec/romst_rev10_1mb.pld
	mv jedec/romst.jed jedec/romst_rev10_1mb.jed
	sed -e s/DEFINE\ ROMY_REVISION/DEFINE\ ROMY_REV11/ -e s/DEFINE\ ROMY_SIZE/DEFINE\ ROMY_1MB/ $< > jedec/romst_rev11_1mb.pld
	$(CUPL) -jm$(OPT) $(LIBCUPL) jedec/romst_rev11_1mb.pld
	mv jedec/romst.jed jedec/romst_rev11_1mb.jed
	sed -e s/DEFINE\ ROMY_REVISION/DEFINE\ ROMY_REV10/ -e s/DEFINE\ ROMY_SIZE/DEFINE\ ROMY_4MB/ $< > jedec/romst_rev10_4mb.pld
	$(CUPL) -jm$(OPT) $(LIBCUPL) jedec/romst_rev10_4mb.pld
	mv jedec/romst.jed jedec/romst_rev10_4mb.jed
	sed -e s/DEFINE\ ROMY_REVISION/DEFINE\ ROMY_REV11/ -e s/DEFINE\ ROMY_SIZE/DEFINE\ ROMY_4MB/ $< > jedec/romst_rev11_4mb.pld
	$(CUPL) -jm$(OPT) $(LIBCUPL) jedec/romst_rev11_4mb.pld
	mv jedec/romst.jed jedec/romst_rev11_4mb.jed
	ln -s romst_rev10_1mb.jed jedec/romst.jed
	rm jedec/romst_rev1?_?mb.pld


clean:
	rm jedec/romst.jed
	rm jedec/romst_rev1?_?mb.jed
