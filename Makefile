CC = cl

#### CUDA
OPENCL_INCLUDE = .\opencl_hfiles
OPENCL_LIBS = OpenCL.lib

#### OpenSSL
OPENSSL_INCLUDE = .\third_party\windows\openssl-1.1\x64\include
OPENSSL_LIBS = .\third_party\windows\openssl-1.1\x64\lib\libcrypto.lib .\third_party\windows\openssl-1.1\x64\lib\libssl.lib

#### Pthread
PTHREADS_INCLUDE = .\pthread\include
PTHREADS_LIBS = pthreadVC16x64MD.lib

#### PCRE
#### From: http://gnuwin32.sourceforge.net/packages/pcre.htm
PCRE_LIBS = pcreVC16x64MD.lib

CFLAGS_BASE = /D_WIN32 /DPTW32_STATIC_LIB /DHAVE_STRUCT_TIMESPEC /I$(PTHREADS_INCLUDE) /I$(OPENSSL_INCLUDE) /I$(OPENCL_INCLUDE) /Ox /Zi
CFLAGS = $(CFLAGS_BASE) /GL
LIBS = $(OPENSSL_LIBS) $(PTHREADS_LIBS) $(PCRE_LIBS) ws2_32.lib user32.lib advapi32.lib gdi32.lib /LTCG
OBJS = vanitygen.obj oclvanitygen.obj oclengine.obj oclvanityminer.obj keyconv.obj pattern.obj util.obj winglue.obj groestl.obj sha3.obj ed25519.obj stellar.o base32.o crc16.o

all: vanitygen++.exe oclvanitygen++.exe

vanitygen++.exe: vanitygen.obj pattern.obj util.obj winglue.obj groestl.obj sha3.obj ed25519.obj stellar.obj base32.obj crc16.obj
	link /nologo /out:$@ $** $(LIBS)

oclvanitygen++.exe: oclvanitygen.obj oclengine.obj pattern.obj util.obj winglue.obj groestl.obj sha3.obj
	link /nologo /out:$@ $** $(LIBS) $(OPENCL_LIBS)

keyconv.exe: keyconv.obj util.obj winglue.obj groestl.obj sha3.obj
	link /nologo /out:$@ $** $(LIBS)

.c.obj:
	@$(CC) /nologo $(CFLAGS) /c /Tp$< /Fo$@

oclengine.obj: oclengine.c
	@$(CC) /nologo $(CFLAGS_BASE) /c /Tpoclengine.c /Fo$@

oclvanitygen.obj: oclvanitygen.c
	@$(CC) /nologo $(CFLAGS_BASE) /c /Tpoclvanitygen.c /Fo$@

clean:
	del vanitygen++.exe oclvanitygen++.exe keyconv.exe $(OBJS)
