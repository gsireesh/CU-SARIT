import re
import os

FILENAME = 'volume2/TV2.xml'
adhyaya = 2
pada = 2

d2r_num = {'०':'0', '१':'1', '२':'2', '३':'3', '४':'4', '५':'5', '६':'6','७':'7','८':'8','९':'9'}


def num_d2r(number):
	rString = '' 
	for s in str(number):
		rString += d2r_num[s]
	return int(rString)



adhi_re = re.compile('.*?इति(—|--| *)?(?P<name>\D*धिकरणम्).*?(?P<number>\d+).*')
pada_re = re.compile('(.*इति श्रीभट्टकुमारिलविरचिते मीमांसाभाष्यव्याख्याने.*\n)')
adhyaya_re = re.compile(' <p>समाप्तश्च द्वितीयोऽध्यायः ॥</p>')


f = open(FILENAME,'r')
tvLines = f.readlines()
tempLineArray = []
outFile = open('log.txt', 'w')
minLimit = 0
maxLimit = 0

for i in range(len(tvLines)):
	match = adhi_re.match(tvLines[i])
	if(match):
		clean_name = re.sub('(<.*?>)|(/?/)', '', match.group('name'))
		print('Adhikarana:', clean_name, file=outFile)
		print(pada, '.', num_d2r(match.group('number')), '\n', file=outFile)
		maxLimit = i + 2
		match2 = pada_re.match(tvLines[i+2])
		match3 = adhyaya_re.match(tvLines[i+4])
		if(i<len(tvLines)-2 and match2 ):
			maxLimit = i+4
		if(i<len(tvLines)-4 and match3):
			maxLimit = i+4
		div = str(adhyaya)+'.'+str(pada)+'.'+str(num_d2r(match.group('number')))
		with open('TVTest/'+div+' '+clean_name+'.xml', 'a+') as f:
			for line in tvLines[minLimit:maxLimit]:
				f.write(line)
		minLimit = maxLimit
		if(match2):
			pada += 1
		#special case:
		elif('चरुविनियोगाधिकरणम्' in match.group('name')):
			print('special case, check!')
			pada += 1
			print('pada:', pada)
		if(match3):
			adhyaya += 1
			pada = 1


'''.*?इति(—|--)(\D*धिकरणम्).*?(\d+).*\n</lg>\n(.*इति\D*पादः.*\n)?'''