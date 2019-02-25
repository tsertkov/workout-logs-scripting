#!/usr/bin/env python3

import sys
from functools import reduce
import pandas as pd

df = pd.read_csv(
  sys.stdin,
  sep="|",
  header=-1,
  names=["date", "time", "pid", "status", "data", "pad"]
)

words = []
for row in df["data"].str.split("[\W_]+"):
  for word in row:
    if len(word) > 0: words.append(word)

words = pd.DataFrame(words, columns=["Word"])
topwords = words.groupby("Word").size().nlargest(10)
print(topwords.to_string())
