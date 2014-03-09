import re
import os

FILENAME = 'volume2/TV2.xml'
base_adhyaya = 2
base_pada = 2

d2r_num = {'०':'0', '१':'1', '२':'2', '३':'3', '४':'4', '५':'5', '६':'6','७':'7','८':'8','९':'9'}


def num_d2r(number):
	rString = '' 
	for s in str(number):
		rString += d2r_num[s]
	return int(rString)



adhi_re = re.compile('.*?इति(—|--| *)?(?P<name>\D*धिकरणम्).*?(?P<number>\d+).*')
pada_re = re.compile('(.*इति\D*पादः.*\n)')


f = open(FILENAME,'r')
tvLines = f.readlines()
tempLineArray = []
outFile = open('log.txt', 'w')

for i in range(len(tvLines)):
	match = adhi_re.match(tvLines[i])
	if(match):
		print('Adhikarana:', match.group('name'), file=outFile)
		print('Number:', num_d2r(match.group('number')), '\n', file=outFile)



'''.*?इति(—|--)(\D*धिकरणम्).*?(\d+).*\n</lg>\n(.*इति\D*पादः.*\n)?'''