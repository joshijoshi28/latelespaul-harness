#!/bin/zsh -il
# Keeps the firstmate Claude session running; restarts it if it exits.
# Run it inside tmux (install.sh --start does this): tmux new -d -s <FIRSTMATE_SESSION> <this file>
# With FIRSTMATE_TELEGRAM=1 the session also runs firstmate's own Telegram bot
# (state in ~/.claude/channels/telegram-firstmate, separate from the telegram module's bot).
source ${0:A:h:h:h}/lib/env.sh
cd $FIRSTMATE_DIR || exit 1
log=$HARNESS_DIR/logs/firstmate-run.log
mkdir -p ${log:h}
args=()
if [[ $FIRSTMATE_TELEGRAM == 1 ]]; then
  export TELEGRAM_STATE_DIR=~/.claude/channels/telegram-firstmate
  mkdir -p $TELEGRAM_STATE_DIR/logs
  args=(--settings ~/.claude/telegram-settings.json --channels plugin:telegram@claude-plugins-official)
fi
while true; do
  start=$(date +%s)
  claude --continue $args
  code=$? ran=$(( $(date +%s) - start ))
  print -r -- "$(date '+%Y-%m-%d %H:%M:%S') firstmate claude exited code=$code after ${ran}s" >> $log
  # A resume that dies fast (no conversation to continue) falls back to a fresh start once.
  if (( ran < 30 )); then
    claude $args
  fi
  sleep 10
done
