SHELL=/bin/bash
download ?= aria2c -x 16 -s 16

all: get_external kernel
	@echo Finished Compiling Ventoy

clean:
	rm -rfv DOC/dietlibc-0.34.tar.xz DOC/musl-1.2.1.tar.gz GRUB2/grub-2.04.tar.xz EDK2/edk2-edk2-stable201911.zip ExFAT/exfat-1.3.0.zip ExFAT/libfuse-fuse-2.9.9.zip builddeps/kernel/*

kernel: kernel_extract
	cp builddeps/kernel/config builddeps/kernel/linux-5.4.3/.config
	cd builddeps/kernel/linux-5.4.3 && sed "s/HOSTCC       = gcc/HOSTCC       = gcc -Wno-error=redundant-decls -Wno-error=use-after-free/" -i Makefile && $(MAKE)

kernel_extract: kernel_src
	cd builddeps/kernel && [ ! -f linux-5.4.3/make_kernel_extracted ] && tar xvf src.txz || true
	echo "true" > builddeps/kernel/linux-5.4.3/make_kernel_extracted

kernel_src: builddeps/kernel/config builddeps/kernel/src.txz

get_external: kernel_src DOC/dietlibc-0.34.tar.xz DOC/musl-1.2.1.tar.gz GRUB2/grub-2.04.tar.xz EDK2/edk2-edk2-stable201911.zip ExFAT/exfat-1.3.0.zip ExFAT/libfuse-fuse-2.9.9.zip
	@echo "finished downloading external deps"

DOC/dietlibc-0.34.tar.xz:
	$(download) "https://www.fefe.de/dietlibc/dietlibc-0.34.tar.xz"                -o DOC/dietlibc-0.34.tar.xz
DOC/musl-1.2.1.tar.gz:
	$(download) "https://musl.libc.org/releases/musl-1.2.1.tar.gz"                 -o DOC/musl-1.2.1.tar.gz
GRUB2/grub-2.04.tar.xz:
	$(download) "https://ftp.gnu.org/gnu/grub/grub-2.04.tar.xz"                    -o GRUB2/grub-2.04.tar.xz
EDK2/edk2-edk2-stable201911.zip:
	$(download) "https://codeload.github.com/tianocore/edk2/zip/edk2-stable201911" -o EDK2/edk2-edk2-stable201911.zip
ExFAT/exfat-1.3.0.zip:
	$(download) "https://codeload.github.com/relan/exfat/zip/v1.3.0"               -o ExFAT/exfat-1.3.0.zip
ExFAT/libfuse-fuse-2.9.9.zip:
	$(download) "https://codeload.github.com/libfuse/libfuse/zip/fuse-2.9.9"       -o ExFAT/libfuse-fuse-2.9.9.zip
        
builddeps/kernel/src.txz:
	$(download) "http://www.tinycorelinux.net/11.x/x86_64/release/src/kernel/linux-5.4.3-patched.txz" -o builddeps/kernel/src.txz
builddeps/kernel/config:
	$(download) "http://www.tinycorelinux.net/11.x/x86_64/release/src/kernel/config-5.4.3-tinycore64" -o builddeps/kernel/config	
