#!/usr/bin/env bash

set -eo pipefail

# Create temporary RRD database

RRD_FILE="$(mktemp)"
rrdtool create "$RRD_FILE" \
--start 1325408399 \
--step 1s \
DS:ok:ABSOLUTE:1:0:10800 \
DS:temp:ABSOLUTE:1:0:10800 \
DS:perm:ABSOLUTE:1:0:10800 \
RRA:AVERAGE:0.5:60:180

# Populate RRD database with data

while read -r line; do
  cmp1="${line%%|*}"; line="${line#*|}"
  cmp2="${line%%|*}"; line="${line#*|}"
  cmp3="${line%%|*}"; line="${line#*|}"
  cmp4="${line%%|*}"; line="${line#*|}"

  timestamp=$(date --date "$cmp1 $cmp2" '+%s')
  status="$cmp4"
  status_ok=0; status_temp=0; status_perm=0;
  if [ "$status" = "OK" ]; then status_ok=1
  elif [ "$status" = "TEMP" ]; then status_temp=1
  elif [ "$status" = "PERM" ]; then status_perm=1
  fi

  rrdtool update "$RRD_FILE" $timestamp:$status_ok:$status_temp:$status_perm
done

# Create graph

GRAPH_FILE="$(mktemp)"
rrdtool graph "$GRAPH_FILE" \
  --start 1325408400 \
  --end start+10800 \
  --width=960 \
  --height=320 \
  --x-grid MINUTE:1:MINUTE:5:MINUTE:10:0:%H\:%M \
  DEF:ok=$RRD_FILE:ok:AVERAGE \
  DEF:temp=$RRD_FILE:temp:AVERAGE \
  DEF:perm=$RRD_FILE:perm:AVERAGE \
  CDEF:ok_v=ok,60,* \
  CDEF:temp_v=temp,60,*,-1,* \
  CDEF:perm_v=perm,60,*,-1,* \
  VDEF:ok_t=ok,TOTAL \
  VDEF:temp_t=temp,TOTAL \
  VDEF:perm_t=perm,TOTAL \
  CDEF:total=ok,temp,+,perm,+ \
  VDEF:total_t=total,TOTAL \
  COMMENT:"\t" \
  AREA:ok_v#24BC14:"OK\n" \
  COMMENT:"\t" \
  AREA:perm_v#EA644A:"PERM\n" \
  COMMENT:"\t" \
  AREA:temp_v#ECD748:"TEMP\n":STACK \
  LINE1:ok_v#0c5704: \
  LINE1:perm_v#811804 \
  LINE1:temp_v#675a03::STACK \
  > /dev/null

cat "$GRAPH_FILE"
