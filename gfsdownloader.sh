
anoi=`date  +%Y`
anof=$anoi
#mesi=`date "-d -6 month" +%m` 
mesi=04 
mesf=$mesi
diai=11
diaf=11
utci=00
fc=000
fcf=003

i=0
j=0
k=0
m=0	
s=0
int=0600

cd $HOME
source .bashrc

cd $HOME/WRF/DATA

if [ ! -e $HOME/WRF/DATA/$anoi$mesi$diai$fcf ]
then 

mkdir $HOME/WRF/DATA/$anoi$mesi$diai$fcf

fi

cd $HOME/WRF/DATA/$anoi$mesi$diai$fcf

eval ' 

for j in {'"`date +%Y`"'..'"`date +%Y`"'..1}

do
       for i in {'"`date +%m`"'..'"`date +%m`"'..1}
 	do
		for k in {'"`date "-d -24 hours" +%d`"'..'"`date "-d -24 hours" +%d`"'..1}
		do       
      
          		for s in {'"$fc"'..'"$fcf"'..003}
                        do 
 

 		curl -v -O ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${anoi}${mesi}${diai}${utci}/gfs.t${utci}z.pgrb2.0p50.f${s}


                    done                  	       
		        done       
	        done
        done
'
