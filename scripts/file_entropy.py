import os, fnmatch
import pandas as pd
import subprocess as sp


ser1 = pd.Series(os.listdir("."))

ps = sp.Popen(("pigz", "-p", "4", "-d", "-c", fn), stdout=sp.PIPE)
deCompSize =  int(sp.check_output(('wc', '-c'), stdin=ps.stdout))
gzSize=os.stat(fn).st_size

def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            yield file

fn=[]
pattern="*.gz"
for file in files("."):
    if fnmatch.fnmatch(file, pattern):
        fn.append(file)

ser1 = pd.Series(fn)