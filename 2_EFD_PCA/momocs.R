library(momocs)
x=read.table('~/Documents/GitHub/Leaf_evolution/1_EFD/toy/test.txt')
x=as.matrix(x)
y=read.table('~/Documents/GitHub/Leaf_evolution/1_EFD/toy/S30_2_59.91ppm.bw.png_outline.tsv')
y=as.matrix(y)
test=list(sp1=x,sp2=y)
a=Out(test)