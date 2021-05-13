all:
	@echo "ROMY 1MB Kickstart patcher"
	@echo
	@echo "Fasten your seatbelts and hold your breath"
	@echo
	@scripts/download.sh
	@scripts/unpack.sh
	@scripts/compile.sh
	@scripts/build.sh

all-roms:
	rm -rf build/46.143_Hyperion\(A* build/kick.a*
	@scripts/build.sh A500
	@scripts/build.sh A1200
	@scripts/build.sh A3000
	@scripts/build.sh A4000
	@scripts/build.sh A4000T

clean:
	rm -rf build archives
