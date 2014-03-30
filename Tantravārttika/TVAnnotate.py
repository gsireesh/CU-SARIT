import os
import re

d2r_num = {'०':'0', '१':'1', '२':'2', '३':'3', '४':'4', '५':'5', '६':'6','७':'7','८':'8','९':'9'}

def num_d2r(number):
	rString = '' 
	for s in str(number):
		rString += d2r_num[s]
	return int(rString)

sutra_re = re.compile('.*?॥ \d ॥',re.DOTALL)
