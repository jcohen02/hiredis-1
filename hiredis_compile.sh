#!/bin/sh
# Follows from here:
# http://lists.r-forge.r-project.org/pipermail/rcpp-devel/2014-May/007584.html
# Oct 2020: This has been updated to use hiredis v1.0.0 from the hiredis github repo
#           v1.0.0 introduces breaking changes - if you still require the original 
#           v0.9.2 version of hiredis that rwinlibs provided, please
#           checkout commit 8f88323 and use the libs provided there
set -x
set -e

DEST=${PWD}
mkdir -p ${DEST}/include/hiredis ${DEST}/lib/i386 ${DEST}/lib/x64

git clone https://github.com/redis/hiredis.git
cd hiredis
git checkout v1.0.0

rm -f *.o
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  alloc.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  net.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  hiredis.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  sds.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  async.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  read.c
gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  sockcompat.c
ar rcs ${DEST}/lib/x64/libhiredis.a alloc.o net.o hiredis.o sds.o async.o read.o sockcompat.o

rm -f *.o
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  alloc.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  net.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  hiredis.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  sds.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  async.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  read.c
gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  sockcompat.c
ar rcs ${DEST}/lib/i386/libhiredis.a alloc.o net.o hiredis.o sds.o async.o read.o sockcompat.o

cp hiredis.h $DEST/include/hiredis

# Check if SSL support was requested and build if necessary
if [ $# -eq 1 ]
  then
    if [ "$1" == "--with-ssl" ]
      then
        echo "Building hiredis SSL support"
        rm -f ssl.o
        gcc -m64 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  ssl.c
        ar rcs ${DEST}/lib/x64/libhiredis_ssl.a ssl.o
        
        rm -f ssl.o
        gcc -m32 -c -std=gnu99 -pedantic -O3 -Wall -W -D_ISOC99_SOURCE -D__USE_MINGW_ANSI_STDIO=1 -Wwrite-strings -g -ggdb  ssl.c
        ar rcs ${DEST}/lib/i386/libhiredis_ssl.a ssl.o
        
        cp hiredis_ssl.h $DEST/include/hiredis
    fi
fi
