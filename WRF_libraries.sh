#############################################################
#														   ##
#														   ##
#					SCRIPT PARA COMPILAR 				   ##
#				   DE FORMA MAIS RÁPIDA					   ##	
#				   TODAS AS DEPENDENCIAS DO MODELO WRF     ##
#														   ##
#														   ##
#														   ##
#														   ##	
#														   ##
#############################################################

### NETCDF
### COMPILANDO A BIBLIOTECA NETCDF-C

netcdf4=`ls | grep netcdf-4.*.tar.gz`
tar zxvf $netcdf4
netcdf4=`ls | grep netcdf-4.*.tar.gz | cut -b 1-12`
cd $netcdf4

./configure --prefix=$HOME/WRF/netcdf --disable-netcdf-4 \
 && make && make check && make install

cd $HOME/WRF
############################################################

### NETCDF-Fortran
## COMPILANDO A BIBLIOTECA NETCDF-FORTRAN
netcdf95=`ls | grep netcdf-f*.tar.gz`
tar zxvf $netcdf95

netcdf95=`ls | grep netcdf-f*.tar.gz | cut -b 1-20`
echo $netcdf95
cd $netcdf95

LDFLAGS=-L$HOME/WRF/netcdf/lib \
CPPFLAGS=-I$HOME/WRF/netcdf/include \
./configure --prefix=$HOME/WRF/netcdf \
 && make && make check && make install

cd $HOME/WRF
###################################################

zlib=`ls | grep zlib-*.tar.gz`
tar zxvf $zlib
zlib=`ls | grep zlib-*.tar.gz | cut -b 1-11 `

cd $zlib

LDFLAGS=-L$HOME/WRF/grib2/lib \
CPPFLAGS=-I$HOME/WRF/grib2/include \
./configure --prefix=$HOME/WRF/grib2 \
 && make && make check && make install

cd $HOME/WRF
####################################################

libpng=`ls | grep libpng-*.tar.gz`
tar zxvf $libpng
libpng=`ls | grep libpng-*.tar.gz | cut -b 1-13`
cd $libpng

LDFLAGS=-L$HOME/WRF/grib2/lib \
CPPFLAGS=-I$HOME/WRF/grib2/include \
./configure --prefix=$HOME/WRF/grib2 \
 && make && make check && make install

cd $HOME/WRF
######################################################
jasper=`ls | grep jasper-*.zip`
unzip $jasper
jasper=`ls | grep jasper-*.zip | cut -b 1-14`
cd $jasper

LDFLAGS=-L$HOME/WRF/grib2/lib \
CPPFLAGS=-I$HOME/WRF/grib2/include \
./configure --prefix=$HOME/WRF/grib2 \
 && make && make check && make install

cd $HOME/WRF