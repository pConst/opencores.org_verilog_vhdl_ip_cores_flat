GRLIB=../..
TOP=leon3mp
BOARD=altera-ep1c20
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=std
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd ahbrom.vhd smc_mctrl.vhd clkgen_ep1c20board.vhd leon3mp.vhd 
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = altera altera_mf
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip ihp gleichmann eth hynix cypress
DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan pci leon3ft ambatest can \
	ddr usbhc greth usb spacewire net haps spi ac97 grusbhc \
	slink ascs coremp7
FILESKIP = grcan.vhd

include $(GRLIB)/software/leon3/Makefile
include $(GRLIB)/bin/Makefile


##################  project specific targets ##########################

