#!/bin/bash
#set -x #Logging

#Add a crontab every 5min
#2-59/5 * * * * cd /home/nano/freqtrade/user_data/strategies/ && sh update.sh >> update.log 2>&1



#vars
dt=$(date '+%d/%m/%Y %H:%M:%S');
strat_url="https://raw.githubusercontent.com/strategie.py"
tmp_path="/tmp/startegie.py"
local_strat="/home/nano/freqtrade/user_data/strategies/strategie.py"
client_path="/home/nano/freqtrade/scripts/rest_client.py"
config_path="/home/nano/freqtrade/config.json"
telegram_url="https://api.telegram.org/bot123456789:dslddhfsfhskfdhs/sendMessage"
chat_id=""

  echo "==================================================="
  echo "==================================================="  
  echo ""

#get last commit
wget "${strat_url}" -O "${tmp_path}" -q --show-progress --progress=bar:force

#compare files
if cmp -s "${local_strat}" "${tmp_path}"

then

  echo ""  
  echo $dt
  echo "Startegie is up to date"
  rm -f "${tmp_path}"

else

  echo "" 
  echo $dt
  echo "Files are different , Will update it with last version & reload config."

  #remove old strat & get new file
  rm "${local_strat}"
  mv "${tmp_path}" "${local_strat}"
  
  #restart bot 
  /home/nano/freqtrade/.env/bin/python "${client_path}" --config "${config_path}"

  #Notify telegram bot
  curl -s -X POST "${telegram_url}" -d chat_id="${chat_id}" -d text="Strategie was updated bot will restart." 

  #Clean temp file
  rm -f "${tmp_path}"
fi

echo
echo "==================================================="
echo "===============END================================="
echo "==================================================="


