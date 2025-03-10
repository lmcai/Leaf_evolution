import re
from numpy import median
x=open('leaf_dimension_sum.csv').readlines()

wd={}
length={}
size={}
solidity={}
asp={}
for l in x[1:]:
	sp=l.split(',')[0]
	sp=sp[8:]
	if not bool(re.match(r'^(XL|L|S)\d+', sp)):
		sp = sp.split('_')
		sp = sp[0]+'_'+sp[1]
	else:
		sp = sp.split('_')[0]
	if sp in wd.keys():
		wd[sp].append(float(l.split(',')[9]))
		length[sp].append(float(l.split(',')[11]))
		size[sp].append(float(l.split(',')[13]))
		solidity[sp].append(float(l.split(',')[6]))
		asp[sp].append(float(l.split(',')[12]))
	else:
		wd[sp]=[float(l.split(',')[9])]
		length[sp]=[float(l.split(',')[11])]
		size[sp]=[float(l.split(',')[13])]
		solidity[sp]=[float(l.split(',')[6])]
		asp[sp]=[float(l.split(',')[12])]


splist=open('s.txt').readlines()
out=open('s.traits.tsv','w')
for l in splist:
	sp=l.strip()
	try:
		wd_m = str(median(wd[sp]))
		len_m = str(median(length[sp]))
		size_m = str(median(size[sp]))
		solidity_m = str(median(solidity[sp]))
		asp_m = str(median(asp[sp]))
		d=out.write('\t'.join([sp,wd_m,len_m,size_m,solidity_m,asp_m])+'\n')
	except KeyError:
		d=out.write(l)

out.close()

		