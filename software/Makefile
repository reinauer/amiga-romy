TARGETS ?= A500 A1200 A3000 A4000 A4000T
VERSION ?= 47.102
SIZES ?= 1mb 2mb 4mb

OUT:=$(PWD)/build

help:
	@echo "ROMY 1MB/2MB/4MB Kickstart patcher\n"
	@echo "Usage:\n"
	@echo " $$ make kickstart TARGETS=\"A500 A4000\" VERSION=47.96 SIZES=\"1mb 4mb\"\n"
	@echo " TARGETS\n  - A500\n  - A1200\n  - A3000\n  - A4000\n  - A4000T\n"
	@echo " SIZES\n  - 1mb (*)\n  - 2mb (**)\n  - 4mb (**)\n"
	@echo "  (*) 0xe00000 base    (**) 0x1000000 base\n"
	@echo " VERSION\n  - 46.143\n  - 46.160\n  - 47.96\n"
	@echo " For CDTV, A500, A600, A1000, A2000 use the A500 image"
	@echo " For CD32, please talk to me\n"
	@echo " Defaults"
	@echo "  TARGETS=\"$(TARGETS)\""
	@echo "  VERSION=\"$(VERSION)\""
	@echo "  SIZES=\"$(SIZES)\""
	@echo

all: kickstart

require:
	@echo "Checking the programs required for the build are installed..."
	@which -s xdftool || (echo "ERROR: xdftool is required."; exit 1)
	@srec_cat --version >/dev/null 2>&1 || (echo "ERROR: srecord is required."; exit 1)

kickstart: prep
	@for TARGET in $(TARGETS) ; do \
		for SIZE in $(SIZES); do \
			echo "Processing Kickstart $(VERSION) for $$TARGET ($$SIZE)" ; \
			scripts/build.sh $$TARGET $(VERSION) $$SIZE ; \
		done ; \
	done

test: prep
	@scripts/build.sh A4000 46.143

pre: require
	@echo "ROMY 1MB/2MB/4MB Kickstart patcher\n"
	@echo "Fasten your seatbelts and hold your breath (no, better don't!)\n"

prep: pre $(OUT)/.compile

$(OUT)/.download: scripts/download.sh
	@scripts/download.sh
	@mkdir -p $(OUT)
	@touch $@

$(OUT)/.unpack: scripts/unpack.sh $(OUT)/.download
	@scripts/unpack.sh
	@touch $@

$(OUT)/.compile: scripts/compile.sh $(OUT)/.unpack
	@scripts/compile.sh
	@touch $@

all-roms-3.1.4: prep
	rm -rf build/46.143_Hyperion\(A*
	$(MAKE) kickstart VERSION=46.143 TARGETS="A500 A1200 A3000 A4000 A4000T" SIZES="1mb 2mb 4mb"

all-roms-3.1.4.1:
	$(MAKE) kickstart VERSION=46.160 TARGETS="A500 A1200 A3000 A4000 A4000T" SIZES="1mb 2mb 4mb"

all-roms-3.2:
	$(MAKE) kickstart VERSION=47.96 TARGETS="A500 A1200 A3000 A4000 A4000T" SIZES="1mb 2mb 4mb"

all-roms-3.2.1:
	$(MAKE) kickstart VERSION=47.102 TARGETS="A500 A1200 A3000 A4000 A4000T" SIZES="1mb 2mb 4mb"

all-roms: all-roms-3.1.4 all-roms-3.1.4.1 all-roms-3.2 all-roms-3.2.1

clean:
	rm -rf build archives
