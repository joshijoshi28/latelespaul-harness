#!/bin/zsh -il
# Keeps the Telegram Claude session running; restarts it if it exits.
# Resumes the previous conversation unless the watchdog asked for a clean start.
source ${0:A:h:h:h}/lib/env.sh
mkdir -p $TELEGRAM_WORKDIR
cd $TELEGRAM_WORKDIR
WD=~/.claude/channels/telegram/watchdog
mkdir -p $WD
orphaned() { [ "$(ps -o ppid= -p $$ | tr -d ' ')" = 1 ] }
while true; do
  if [ -e $WD/fresh-next ]; then
    rm -f $WD/fresh-next
    args=()
  else
    args=(--continue)
  fi
  start=$(date +%s)
  claude $args --settings ~/.claude/telegram-settings.json --channels plugin:telegram@claude-plugins-official
  code=$? ran=$(( $(date +%s) - start ))
  print -r -- "$(date '+%Y-%m-%d %H:%M:%S') claude ${args:-fresh} exited code=$code after ${ran}s" >> ~/.claude/channels/telegram/logs/launchd.log
  # A resume that dies within 30s (no conversation, broken session) falls back to a fresh start.
  (( ran < 30 )) && touch $WD/fresh-next
  # Stop if our screen session is gone (orphaned), so restarts never leave a second bot running.
  orphaned && exit
  sleep 10
  orphaned && exit
done
