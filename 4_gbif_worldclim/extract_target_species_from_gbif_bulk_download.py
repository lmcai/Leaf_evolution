x=open('/Users/limingcai/Downloads/leaf_sp.txt').readlines()
x=[l.strip() for l in x]
y=open('/Users/limingcai/Downloads/orobanchaceae_coordinates.GBIF.tsv').readlines()
z=open('orobanchaceae_coordinates.GBIF.filtered.tsv','a')
z.write(y[0])
a=[]
for l in y[1:]:
	h=l.split('\t')
	if h[9] in x:
		b=z.write(l)
		a.append(h[9])
	else:
		try:
			old_name=h[12].split()
			old_name=old_name[0]+' '+old_name[1]
			if old_name in x:
				b=z.write(l)
				a.append(old_name)
		except IndexError:pass

z.close()
c=[i for i in x if not i in a]
z=open('not_in_gbif.txt','a')
z.write('\n'.join(c))