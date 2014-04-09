import os
import re
import subprocess

d2r_num = {'०':'0', '१':'1', '२':'2', '३':'3', '४':'4', '५':'5', '६':'6',\
'७':'7','८':'8','९':'9'}

def num_d2r(number):
	rString = '' 
	for s in str(number):
		rString += d2r_num[s]
	return int(rString)

sutra_re = re.compile('.*?(?<!धिकरणम्) ॥ (?P<number>\d+) ॥.*?</.{1,2}>',re.DOTALL)
adhi_re = re.compile('(?P<text>.*)<(lg|p)>.*?(?P<trailer>इति(—|--| *)?\D*धिकरणम्)\
.*?(?P<number>\d+).*?</(lg|p)>', re.DOTALL)

folder = 'inProgress'
os.chdir(folder)
filesList = sorted([f for f in os.listdir() if os.path.isfile(f)])
i = 0

for f in filesList:
    oldFile = open(f,'r')
    text = oldFile.read()
    oldFile.close()
    print(f)

    number  = re.split(' |\.xml',f)[0]
    name    = re.split(' |\.xml',f)[1]
    newFileName = subprocess.check_output(['python2.7','../transliterator.py',\
    name , 'DEVANAGARI', 'IAST']).capitalize()
    
    adhi_match = adhi_re.match(text)

    newFile = open('output/'+number+'-'+newFileName.decode('utf-8')+'.xml','w')
    print('<div type="adhikaraṇa" n="{0}">'.format(num_d2r(adhi_match.group('number'))), file = newFile)
    for sutra in sutra_re.finditer(text):
        print('<div type="sūtra" n="{0}">'.format(num_d2r(sutra.group('number')\
        )),file = newFile)
        print(sutra.group(0), file=newFile)
        print('</div>', file=newFile)
    print('<trailer>{0}</trailer>'.format(adhi_match.group('trailer')), file = newFile)
    print('</div>', file=newFile)
    newFile.close()
    
    

