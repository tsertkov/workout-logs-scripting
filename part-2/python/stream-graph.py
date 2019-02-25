#!/usr/bin/env python3

import sys
from functools import reduce
import pandas as pd
import datetime as dt
import matplotlib.pyplot as plt

df = pd.read_csv(
  sys.stdin,
  sep="|",
  header=-1,
  parse_dates=[[0,1]],
  names=["date", "time", "pid", "status", "data", "pad"]
)

# Group by minute
df["minute"] = df.date_time.apply(dt.date.strftime, args=("%H:%M", ))
df2 = df.groupby(["minute", "status"])["status"].size().unstack()

# Add drops column
statuses = df2.columns
df2["drops"] = 0
for t in df2.index:
  df2["drops"][t] = reduce(lambda x, status: x - df2[status][t], statuses, 60)

df2.plot.bar(
  figsize=(9, 3),
  legend=False,
  stacked=True,
  ylim=(0, 60),
  fontsize=8,
  width=1.0,
  color=["#24BC14", "#EA644A", "#ECD748", "#000000"]
)

plt.ylabel("Msg per minute")
plt.xlabel("")
locs, labels = plt.xticks()
nlocs = list()
nlabels = list()

for i in range(len(locs)):
  if i % 10 != 0: continue
  nlocs.append(locs[i])
  nlabels.append(labels[i])

nlocs.append(179)
nlabels.append(labels[-1])
plt.xticks(nlocs, nlabels)

plt.tight_layout()
plt.savefig(sys.stdout.buffer)
