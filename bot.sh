#!/bin/bash

. bot.properties

input=".bot.cfg"
echo "Starting session: $(date "+[%y:%m:%d %T]")">$log 
echo "NICK $nick" > $input 
echo "USER $user" >> $input
echo "JOIN #$channel" >> $input

tail -f $input | telnet $server $port | while read res
do
  # log the session
  res=$(echo $res | iconv -f CP1251 -t UTF-8)
  echo "RES: $res"
#   echo "$(date "+[%y:%m:%d %T]")$res" >> $log
# 
#   # do things when you see output
  case "$res" in
    # respond to ping requests from the server
    PING*)
      echo "PING>>: $res"
      echo "$res" | sed "s/I/O/" >> $input 
    ;;
    # for pings on nick/user
#     *"You have not"*)
#       echo "JOIN #$channel" >> $input
#     ;;
    # run when someone joins
#     *JOIN*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#       if [ "$who" = "$nick" ]
#       then
#        continue 
#       fi
#       echo "MODE #$channel +o $who" >> $input
#     ;;
    # run when a message is seen
#     *PRIVMSG*)
#       echo "$res"
#       who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#       from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#       # "$portould mean it's a channel
#       if [ "$(echo "$from" | grep '#')" ]
#       then
#         test "$(echo "$res" | grep ":$nick:")" || continue
#         will=$(echo "$res" | perl -pe "s/.*:$nick:(.*)/\1/")
#       else
#         will=$(echo "$res" | perl -pe "s/.*$nick :(.*)/\1/")
#         from=$who
#       fi
#       will=$(echo "$will" | perl -pe "s/^ //")
#       com=$(echo "$will" | cut -d " " -f1)
#       if [ -z "$(ls modules/ | grep -i -- "$com")" ] || [ -z "$com" ]
#       then
#         ./modules/help/help.sh $who $from >> $input
#         continue
#       fi
#       ./modules/$com/$com.sh $who $from $(echo "$will" | cut -d " " -f2-99) >> $input
#     ;;
#     *)
#       echo "$res"
#     ;;
  esac
done
