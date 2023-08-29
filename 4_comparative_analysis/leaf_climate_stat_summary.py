from statistics import mean
import pandas as pd

x=open('/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/leaf_dimention_master.csv').readlines()
y=open('/Users/lcai/Downloads/Taxon_sampling.csv').readlines()
ID={}
for l in y[1:]:
	ID[l.split(',')[0]]=l.split(',')[3]+' '+l.split(',')[4]

asp={}
area={}
Len={}
for l in x[1:]:
	sp=l.split(',')[-1]
	sp=sp.strip()
	if sp in asp.keys():
		asp[sp].append(l.split(',')[5])
		area[sp].append(l.split(',')[7])    
		Len[sp].append(l.split(',')[8])
	else:
		asp[sp]=[l.split(',')[5]]
		area[sp]=[l.split(',')[7]]   
		Len[sp]=[l.split(',')[8]]

out=open('leaf_sum.tsv','a')
out.write('ID\tSP\taspect_ratio\tleaf_area_mm2\tleaf_len_mm\n')
for k in asp.keys():
	asp_ave=mean([float(i) for i in asp[k]])
	area_ave=mean([float(i) for i in area[k]])
	Len_ave=mean([float(i) for i in Len[k]])
	try:
		sp=ID[k]
	except KeyError:sp='NA'
	d=out.write(k+'\t'+sp+'\t'+str(asp_ave)+'\t'+str(area_ave)+'\t'+str(Len_ave)+'\n')

out.close()

x=open('leaf_shape/leaf_sum.tsv').readlines()
out=open('leaf_clim_sum.tsv','a')
out.write(x[0].strip()+'\t'+'\t'.join(['elevation', 'BIO1', 'BIO2', 'BIO3', 'BIO4', 'BIO5', 'BIO6', 'BIO7', 'BIO8', 'BIO9', 'BIO10', 'BIO11', 'BIO12', 'BIO13', 'BIO14', 'BIO15', 'BIO16', 'BIO17', 'BIO18', 'BIO19'])+'\n')
for l in x[1:]:
	sp=l.split('\t')[1]
	try:
		df = pd.read_csv('worldclim/'+sp+'.worldclim.csv')
		median_ele = df['elevation'].median()
		median_BIO1 = df['BIO1'].median()
		median_BIO2 = df['BIO2'].median()
		median_BIO3 = df['BIO3'].median()
		median_BIO4 = df['BIO4'].median()
		median_BIO5 = df['BIO5'].median()
		median_BIO6 = df['BIO6'].median()
		median_BIO7 = df['BIO7'].median()
		median_BIO8 = df['BIO8'].median()
		median_BIO9 = df['BIO9'].median()
		median_BIO10 = df['BIO10'].median()
		median_BIO11 = df['BIO11'].median()
		median_BIO12 = df['BIO12'].median()
		median_BIO13 = df['BIO13'].median()
		median_BIO14 = df['BIO14'].median()
		median_BIO15 = df['BIO15'].median()
		median_BIO16 = df['BIO16'].median()
		median_BIO17 = df['BIO17'].median()
		median_BIO18 = df['BIO18'].median()
		median_BIO19 = df['BIO19'].median()
		clim=[median_ele,median_BIO1,median_BIO2,median_BIO3,median_BIO4,median_BIO5,median_BIO6,median_BIO7,median_BIO8,median_BIO9,median_BIO10,median_BIO11,median_BIO12,median_BIO13,median_BIO14,median_BIO15,median_BIO16,median_BIO17,median_BIO18,median_BIO19]
		d=out.write(l.strip()+'\t'+'\t'.join([str(i) for i in clim])+'\n')
	except (FileNotFoundError, UnicodeDecodeError):
		d=out.write(l)

out.close()