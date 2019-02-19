#!/usr/bin/env bash

set -e -o pipefail

DATE=20120101
LINE_LENGTH=500
LINE_COUNT=10000
TIME_START=$(( 9 * 3600 ))
TIME_END=$(( 12 * 3600 - 1 ))
PID_MIN=3000
PID_MAX=5000
PAD_CHAR="X"
SENTENCES_URL="https://en.wikipedia.org/wiki/Amazon_S3"
STATUS_ARR=("OK" "TEMP" "PERM")
DELIMITER="|"

# Shell is not reacting to Ctrl+C immediately otherwise
trap ctrl_c INT
function ctrl_c() {
  exit 1
}

function get_sentences {
  url="$1"
  # '/^Notes\[edit\]/q'    - remove everything after "Notes"
  # 's/\^\[[^]]*\]//g'     - remove all cite notes markers
  # '/^[^ ]/d'             - remove all lines starting with non-space
  # '/^$/d'                - remove all blank lines
  # '/[^.:]$/d'            - remove all lines not ending with dot or colon
  # 's/^ *\* //'           - remove all leading bulleting points
  # 's/^ *[0-9]*\. //'     - remove all leading numbered points
  # $'s/\\. /\\.\\\n/g'    - split by sentence per line
  # 's/^ *//'              - remove all leading spaces

  lynx \
    -dump \
    -crawl \
    -width=99999 \
    "$url" \
    | sed \
      -e '/^Notes\[edit\]/q' \
      -e 's/\^\[[^]]*\]//g' \
      -e '/^[^ ]/d' \
      -e '/^$/d' \
      -e '/[^.:]$/d' \
      -e 's/^ *\* //' \
      -e 's/^ *[0-9]*\. //' \
      -e $'s/\\. /\\.\\\n/g' \
      -e 's/^ *//' \
      | grep -v '^Notes\[edit\]'
}

function repl {
  printf "$1"'%.s' $(eval "echo {1.."$(($2))"}")
}

function print_logline {
  tick=$1

  time=$(date -d "@$(( $TIME_START + $tick ))" +%H:%M:%S)
  pid=$(( ( $RANDOM % $(( $PID_MAX - $PID_MIN )) ) + $PID_MIN ))
  status=${STATUS_ARR[$(( $RANDOM % ${#STATUS_ARR[@]} ))]}
  data=${SENTENCES_ARR[$(( $RANDOM % ${#SENTENCES_ARR[@]} ))]}

  line="$(
    echo -n "${DATE}${DELIMITER}"
    echo -n "${time}${DELIMITER}"
    echo -n "${pid}${DELIMITER}"
    echo -n "${status}${DELIMITER}"
    echo -n "${data}${DELIMITER}"
  )"

  line=${line:0:$(( $LINE_LENGTH - 1 ))}
  echo -n "$line"
  echo $(repl X $(( $LINE_LENGTH - ${#line} )))
}

# Init sentences array

SENTENCES_ARR=()
while read -r line; do
  SENTENCES_ARR+=("$line")
done <<< "$(get_sentences "$SENTENCES_URL")"

# Randomize dropped ticks to match log size

total_ticks=$(( $TIME_END - $TIME_START + 1 ))
total_dropped_ticks=$(( $total_ticks - $LINE_COUNT ))
dropped_ticks=()
while [ ${#dropped_ticks[@]} -lt $total_dropped_ticks ]; do
  dropped_tick=$(( $RANDOM % total_ticks ))
  if [[ ! " ${dropped_ticks[@]} " =~ " ${dropped_tick} " ]]; then
    dropped_ticks+=($dropped_tick)
  fi
done

# Emit log stream

for tick in $(seq 0 $(( $total_ticks - 1 )) ); do
  if [[ ! " ${dropped_ticks[@]} " =~ " ${tick} " ]]; then
    print_logline $tick
  fi
done
