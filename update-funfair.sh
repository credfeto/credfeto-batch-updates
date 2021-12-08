#! /bin/bash

echo $PATH

cd /home/templateupdate/auto-update/template-update
pwd

mkdir funfair
cd funfair

rm /home/templateupdate/auto-update/logs/template.funfair.last.log
mv /home/templateupdate/auto-update/logs/template.funfair.log /home/templateupdate/auto-update/logs/template.funfair.last.log


pwsh -file /home/templateupdate/auto-update/scripts/powershell/UpdateFromTemplate.ps1 \
     -repos /home/templateupdate/auto-update/auto-update-config/funfair/repos.lst \
     -templateRepo git@github.com:funfair-tech/funfair-server-template.git \
              > /home/templateupdate/auto-update/logs/template.funfair.log 2>&1


