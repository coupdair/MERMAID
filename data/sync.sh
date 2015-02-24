#sync data to GitHub
date=`date +%Y_%m_%d_%Hh%Mmin`
cd /tmp/MERMAID/data
for i in 101 115 175 130 126 110 128; do rsync -var pi@172.16.0.$i:~/data.Xsensor/2015 . --progress; done
git add *
git commit -a -m $date
git push
