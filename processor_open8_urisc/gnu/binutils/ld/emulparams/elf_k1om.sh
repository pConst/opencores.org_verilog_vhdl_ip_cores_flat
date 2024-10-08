. ${srcdir}/emulparams/plt_unwind.sh
SCRIPT_NAME=elf
ELFSIZE=64
OUTPUT_FORMAT="elf64-k1om"
NO_REL_RELOCS=yes
TEXT_START_ADDR=0x400000
MAXPAGESIZE="CONSTANT (MAXPAGESIZE)"
COMMONPAGESIZE="CONSTANT (COMMONPAGESIZE)"
ARCH="k1om"
MACHINE=
COMPILE_IN=yes
TEMPLATE_NAME=elf32
GENERATE_SHLIB_SCRIPT=yes
GENERATE_PIE_SCRIPT=yes
NO_SMALL_DATA=yes
LARGE_SECTIONS=yes
SEPARATE_GOTPLT=24

if [ "x${host}" = "x${target}" ]; then
  case " $EMULATION_LIBPATH " in
    *" ${EMULATION_NAME} "*)
      NATIVE=yes
  esac
fi

# Linux modifies the default library search path to first include
# a 64-bit specific directory.
case "$target" in
  *k1om*-linux*)
    case "$EMULATION_NAME" in
      *k1om*) LIBPATH_SUFFIX=64 ;;
    esac
    ;;
esac
