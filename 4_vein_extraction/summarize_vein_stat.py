from numpy import median

x=open('vein_stat_MASTER.tsv').readlines()

VFEratio={}
Valpha={}
#VMSTratio={}
VTotLD={}
AmdCnA={}
AmdElg={}
AmdDav={}

for l in x[1:]:
	sp=l.split('\t')[0]
	sp=sp.split('_')[0]
	if l.split('\t')[7]=='':continue
	if sp in VFEratio.keys():
		VFEratio[sp].append(float(l.split('\t')[7]))
		Valpha[sp].append(float(l.split('\t')[8]))
		VTotLD[sp].append(float(l.split('\t')[20]))
		AmdCnA[sp].append(float(l.split('\t')[113]))
		AmdElg[sp].append(float(l.split('\t')[102]))
		AmdDav[sp].append(float(l.split('\t')[119]))
	else:
		VFEratio[sp]=[float(l.split('\t')[7])]
		Valpha[sp]=[float(l.split('\t')[8])]
		VTotLD[sp]=[float(l.split('\t')[20])]
		AmdCnA[sp]=[float(l.split('\t')[113])]
		AmdElg[sp]=[float(l.split('\t')[102])]
		AmdDav[sp]=[float(l.split('\t')[119])]
		

sp_list=open('a.txt').readlines()
out=open('vein_sum.tsv','w')
out.write('\t'.join(['Species','VFEratio','Valpha','VTotLD','AmdCnA','AmdElg','AmdDav'])+'\n')
for l in sp_list:
	sp =l.strip()
	if sp in VFEratio.keys():
		d=out.write(sp+'\t'+str(median(VFEratio[sp]))+'\t'+str(median(Valpha[sp]))+'\t'+str(median(VTotLD[sp]))+'\t'+str(median(AmdCnA[sp]))+'\t'+str(median(AmdElg[sp]))+'\t'+str(median(AmdDav[sp]))+'\n')
	else:
		d=out.write(l)


out.close()	
		