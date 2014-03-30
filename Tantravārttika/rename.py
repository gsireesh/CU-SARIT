#NEED TO USE PYTHON 2.7 FOR THIS SCRIPT

import os
import re
import transliterator


name = re.compile('(\d\.\d\.\d )(\D*).xml', re.U)

files = [f for f in os.listdir(os.getcwd()) if name.match(f)]
files.sort()

for f in files:
    match = name.match(f)
    if(match):
        try:
            trans = transliterator.transliterate(match.group(2),'devanagari', 'iast')
        except:
            print('derped!')
            continue
        newName = match.group(1) + trans + '.xml'
        os.rename(f, newName)

    
    

