#!/usr/bin/env python3
from urllib.request import urlopen
from bs4 import BeautifulSoup
from datetime import datetime
import random
import re

date_start = 1325376000 + 3600 * 9
date_end = date_start + 3600 * 3
pad_char = "X"
pid_min = 3000
pid_max = 5000
line_length = 500
line_count = 10000
sentences_url = "https://en.wikipedia.org/wiki/Amazon_S3"
delimiter = "|"
statuses = ["OK", "TEMP", "PERM"]

def get_sentences (url):
    html = urlopen(url)
    soup = BeautifulSoup(html, 'html.parser')
    lines = []

    p_tags = soup.select('#mw-content-text .mw-parser-output p')
    for tag in p_tags:
        line = (''.join(tag.strings)).strip()
        line = re.sub(r'(\[[0-9]+\])+', '', line)
        lines += line.split('. ')

    li_tags = soup.select('#mw-content-text .mw-parser-output li')
    for tag in li_tags:
        line = ("".join(tag.strings)).strip()
        line = re.sub(r"(\[[0-9]+\])+", "", line)
        line = re.sub(r"^[0-9\.]+ ", "", line)
        line = re.sub(r"^\^ ", "", line)
        if line.count("\n") > 0 : continue
        lines.append(line)

    lines = map(lambda x: x + "." if x[-1:] not in [".", ":"] else x, lines)
    lines = map(lambda x: x.replace("\n", ''), lines)
    lines = map(lambda x: x.encode("utf8").decode("ascii", "ignore"), lines)
    lines = list(filter(lambda x: x.count(" ") > 3, lines))
    lines = list(filter(lambda x: re.match(r"^[A-Z]", x), lines))

    return lines

def get_dropped_ticks(start, end, limit):
  drop_num = (end - start) - limit
  ticks = []
  while len(ticks) < drop_num:
    tick = random.randint(start, end)
    if tick in ticks: continue
    ticks.append(tick)
  return ticks

sentences = get_sentences(sentences_url)
dropped_ticks = get_dropped_ticks(date_start, date_end, line_count)

for tick in range(date_start, date_end):
  if tick in dropped_ticks: continue

  ts = datetime.utcfromtimestamp(tick)
  date = str(ts.strftime("%Y%m%d"))
  time = str(ts.strftime("%H:%M:%S"))
  pid = str(random.randint(pid_min, pid_max))
  status = random.choice(statuses)
  sentence = random.choice(sentences)
  line = delimiter.join([date, time, pid, status, sentence])
  line = line[:line_length - 1] + delimiter
  line = line + (pad_char * (line_length - len(line)))

  print(line)
