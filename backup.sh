function add () {
	if [ ! -f .backup.lst ]; then
		touch .backup.lst
	fi
FILEPATH=$(cd $(dirname "$1") && pwd -P)/$(basename "$1")
   if [ -d $FILEPATH ] || [ -f $FILEPATH ]; then 
	if grep -Fxq "$FILEPATH" .backup.lst; then
		echo "$FILEPATH is currently in your backup list"		
	else
		echo "$FILEPATH" >> .backup.lst
		echo "$FILEPATH has been added to your backup list"
	fi
   else
	echo "$FILEPATH doesn't exist"
  fi
}
function remove() {
FILEPATH=$(cd $(dirname "$1") && pwd -P)/$(basename "$1")
	if grep -Fxq "$FILEPATH" .backup.lst; then
		sed -i "\|$FILEPATH|d" .backup.lst
		echo "$FILEPATH has been deleted from your backup list"
	else
		echo "$FILEPATH is not on your backup list!"
	fi
	if [ ! -s .backup.lst ]; then 
		echo ".backup.lst is empty now"		
	fi
}
function backup() {
rsync -a --files-from=.backup.lst --rsync-path="mkdir -p $(date +%Y-%d-%d-%H-%M-%S) && rsync" / $1:$(date +%Y-%d-%d-%H-%M-%S)
}
while getopts "a:r:b:hu" opt; do
  case $opt in
    a)
     add "$OPTARG"
      ;;
    r)
	remove "$OPTARG"
	;;

    b)	backup "$OPTARG"

	;;
    h)
	;;
    u)
	;;
	
    \?)
	ERROR=true
      ;;
  esac
done