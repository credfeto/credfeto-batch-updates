#! /bin/bash

PROG=$0
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function error_exit {
    echo
    echo "$@"
    exit 1
}
#Trap the killer signals so that we can exit with a good message.
trap "error_exit 'Received signal SIGHUP'" SIGHUP
trap "error_exit 'Received signal SIGINT'" SIGINT
trap "error_exit 'Received signal SIGTERM'" SIGTERM

shopt -s expand_aliases
alias die='error_exit "Error $PROG (@`echo $(( $LINENO - 1 ))`):"'

REPOS=

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -r|--repositories)
      REPOS="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      die "unknown argument $1"
      ;;
  esac
done

[ -z "$REPOS" ] && die "--repositories not specified"

WORK=${SCRIPT_DIR}/../work/${REPOS}/
LOGS=${SCRIPT_DIR}/../logs/${REPOS}/
REPOS_LIST=${SCRIPT_DIR}/${REPOS}/repos.lst

echo "Work: ${WORK}"
echo "Logs: ${LOGS}"
echo "Repos.lst : ${REPOS_LIST}"

die "Not ready"

echo $PATH

mkdir 

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


