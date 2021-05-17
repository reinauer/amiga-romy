all:
	@echo "ROMY 1MB Kickstart patcher"
	@echo
	@echo "Fasten your seatbelts and hold your breath"
	@echo
	@scripts/download.sh
	@scripts/unpack.sh
	@scripts/compile.sh
	@scripts/build.sh A4000 46.143

all-roms-3.1.4:
	rm -rf build/46.143_Hyperion\(A*
	@scripts/build.sh A500 46.143
	@scripts/build.sh A1200 46.143
	@scripts/build.sh A3000 46.143
	@scripts/build.sh A4000 46.143
	@scripts/build.sh A4000T 46.143

all-roms-3.1.4.1:
	@scripts/build.sh A500 46.160
	@scripts/build.sh A1200 46.160
	@scripts/build.sh A3000 46.160
	@scripts/build.sh A4000 46.160
	@scripts/build.sh A4000T 46.160

all-roms-3.2:
	@scripts/build.sh A500 47.96
	@scripts/build.sh A1200 47.96
	@scripts/build.sh A3000 47.96
	@scripts/build.sh A4000 47.96
	@scripts/build.sh A4000T 47.96

all-roms: all-roms-3.1.4 all-roms-3.1.4.1 all-roms-3.2

clean:
	rm -rf build archives
