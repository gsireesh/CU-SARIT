import re
import os

d2r_num = {'०':0, '१':1, '२':2, '३':3, '४':4, '५':5, '६':6,'७':7,'८':8,'९':9}

adhi_re = re.compile('इति(\D*धिकरणम्).*(\d)', 0)

match = adhi_re.match('इति शब्दान्तराधिकरणम् ॥ १ ॥')
if(match):
    print(match.group(1))
    print(d2r_num[match.group(2)])
    print('general pattern works!')
    
if re.match('\d', '२'):
    print('number pattern works!')

print('''Regex to match adhikaranas with paadas: \
.*?इति(—|--)(\D*धिकरणम्).*?(\d+).*\n</lg>\n(.*इति\D*पादः.*\n)?''')
