#!/usr/bin/env zsh

###
# Turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
###
function _done_human_time() {
  local tmp=$(( $1 / 1000 ))
  local days=$(( tmp / 60 / 60 / 24 ))
  local hours=$(( tmp / 60 / 60 % 24 ))
  local minutes=$(( tmp / 60 % 60 ))
  local seconds=$(( tmp % 60 ))
  (( $days > 0 )) && print -n "${days}d "
  (( $hours > 0 )) && print -n "${hours}h "
  (( $minutes > 0 )) && print -n "${minutes}m "
  (( $seconds > 5 )) && print -n "${seconds}s"
  (( $tmp <= 5 )) && print -n "${1}ms"
}

###
# Send a notification when the long-running command completes
###
function _done_notify() {
  integer elapsed=$1
  local cmd=$(fc -ln -1)

  local msg="Command $cmd finished in $(_done_human_time $elapsed)"

  case $OSTYPE in
    darwin* )
      osascript -e 'display notification "'$msg'" with title "Long-running command finished"'
      ;;
    linux* )
      type notify-send >/dev/null 2>&1 && notify-send
      ;;
  esac
}

###
# Calculate the execution time and trigger the notification if
# command took longer than $DONE_MAX_EXEC_TIME (default 10s)
###
function _done_precmd() {
  local stop=$((EPOCHREALTIME*1000))
  local start=${_done_cmd_timestamp:-$stop}
  integer elapsed=$stop-$start
  (($elapsed > ${DONE_MAX_EXEC_TIME:=10000})) && _done_notify $elapsed

  unset _done_cmd_timestamp
}

###
# Store the current timestamp before executing the command
###
function _done_preexec() {
  _done_cmd_timestamp=$((EPOCHREALTIME*1000))
}

###
# Register the precmd and preexec hooks to enable the plugin
###
function _done() {
  zmodload zsh/datetime
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd _done_precmd
  add-zsh-hook preexec _done_preexec
}

_done "$@"
