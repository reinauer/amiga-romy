# Builds the ROMY GAL logic with lincupl's native cupl and csim; set LINCUPL
# and CSIM if they are not on the PATH.
#
#   source/romst.pld  Revisions 10 and 11, the original parts:
#                     jedec/romst_rev1{0,1}_{1,4}mb.jed
#   source/romy.pld   Revision 12: jedec/romy_rev12_{1,4}mb.jed
#
# make sim builds Revision 12 and runs csim on it against the vectors in
# source/simulation/; the listings end up in sim/romy_rev12_*.so.

LINCUPL ?= cupl
CSIM    ?= csim

ROMST := rev10_1mb rev11_1mb rev10_4mb rev11_4mb
ROMY  := rev12_1mb rev12_4mb

# rev10_1mb -> ROMY_REV10 and ROMY_1MB
upper = $(shell echo $(1) | tr a-z A-Z)
rev   = ROMY_$(call upper,$(word 1,$(subst _, ,$(1))))
size  = ROMY_$(call upper,$(word 2,$(subst _, ,$(1))))

.PHONY: all sim clean
.SECONDARY:

all: $(ROMST:%=jedec/romst_%.jed) jedec/romst.jed $(ROMY:%=jedec/romy_%.jed)

sim: $(ROMY:%=sim/romy_%.so)

# Each variant compiles in a directory of its own: cupl names its output
# after the Name field, which is "romst" in both sources.
build/romst_%/romst.jed: source/romst.pld Makefile
	mkdir -p $(@D)
	sed -e 's/DEFINE ROMY_REVISION/DEFINE $(call rev,$*)/' \
	    -e 's/DEFINE ROMY_SIZE/DEFINE $(call size,$*)/' $< > $(@D)/romst.pld
	cd $(@D) && $(LINCUPL) -jm1 romst.pld

build/romy_%/romst.jed: source/romy.pld Makefile
	mkdir -p $(@D)
	sed -e 's/DEFINE ROMY_SIZE/DEFINE $(call size,$*)/' $< > $(@D)/romst.pld
	cd $(@D) && $(LINCUPL) -jam1 romst.pld

jedec/%.jed: build/%/romst.jed
	cp $< $@

jedec/romst.jed:
	ln -sf romst_rev10_1mb.jed $@

sim/romy_%.so: build/romy_%/romst.jed source/simulation/romy_%.si
	mkdir -p sim
	sed -e 's/DEFINE ROMY_SIZE/DEFINE $(call size,$*)/' source/romy.pld > sim/romy_$*.pld
	cp build/romy_$*/romst.abs sim/romy_$*.abs
	cp build/romy_$*/romst.jed sim/romy_$*.jed
	cp source/simulation/romy_$*.si sim/
	cd sim && $(CSIM) -l romy_$*

clean:
	rm -rf build sim
