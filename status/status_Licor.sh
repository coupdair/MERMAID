#!/bin/bash

#Licor status
#usage: ./status_Licor.sh 20140426
#    or ./status_Licor.sh #now

#ftp='trickle -s -d 512 ncftpget -R -u licor -p pass 192.168.0.1 . /dataLicor/'
ftp='ncftpget -R -u licor -p pass 192.168.0.1 . /dataLicor/'
if [ -n "$1" ]
then
  day=$1
else
  day=`date +%Y%m%d`
fi
fi=$day'.ftp'
fo=$day'.ftpR'
tee=' 2>&1 | tee '$fi

date

##remove FTP folder
##rm -fr $day

#remove part FTP folder (i.e. fast FTP)
ft=tmpLicorRmPart.txt
ls $day/* | tail -n 20 > $ft
for f in `cat $ft`; do rm $f; done
rm $ft

#ftp transfert and list
/bin/echo -e -n 'start FTP transfer ...\r'
cmd=$ftp$day$tee
ft=tmpLicor.sh; echo $cmd > $ft; chmod u+x $ft; ./$ft; rm $ft
#get tail of list
ft=$day'.tmp'
##cat $fi | sed 'n;d;' | tail -n 12 | head -n 10 > $ft
cat $fi | sed 'n;d;' | tail -n +2 | head -n -2 > $ft
#set size as integer in Byte and get 2 columns only
cat $ft | sed 's/://g;s/...\ kB/000/g' | sed 's/\// /g;s/  */ /g' | cut -d' ' -f2,8 > $fo

rm $ft

echo $fo':'
head -n 2 $fo
echo ...
tail -n 2 $fo

#create check report
ft=$fo'.check'
tail -n 20 $fo > $ft
./check_Licor_now.Rsh $ft
##show
cp -p $ft.pdf check.pdf
evince check.pdf &
convert check.pdf check.png

#create day report (warning: may be too short now due to fast FTP, see above)
./check_Licor.Rsh $fo
##show
cp -p $fo.pdf day.pdf
evince day.pdf &
convert day.pdf day.png

#publish report on GitHub
cd ..
git commit -a -m `date +%y%m%d_%H%M%S`
git push origin master
cd status

/bin/echo -e -n '\033[1;34m Licor status \033[0m'


