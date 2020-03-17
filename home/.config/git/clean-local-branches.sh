OPTION="-d";
if [[ "$1" == "-f" ]]; then
  echo "WARNING! Removing with force";
  OPTION="-D";
fi;

TO_REMOVE=`git branch -r | awk "{print \\$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \\$1}"`;
if [[ -n "$TO_REMOVE" ]]; then
  echo "Removing branches...";
  echo "";
  printf "\n$TO_REMOVE\n\n";
  echo "Proceed?";

  select result in Yes No; do
    if [[ "$result" == "Yes" ]]; then
      echo "Removing in progress...";
      echo "$TO_REMOVE" | xargs git branch "$OPTION";
      if [[ "$?" -ne "0" ]]; then
        echo ""
        echo "Some branches was not removed, you have to do it manually!";
      else
        echo "All branches removed!";
      fi
    fi

    break;
  done;
else
  echo "You have nothing to clean";
fi
