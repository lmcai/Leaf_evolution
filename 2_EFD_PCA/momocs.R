library(Momocs)
################################
#1. Load data
##Read in leaf coordinates
x=read.table('/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/1_leaf_shape/022323/rotated_S30_1_59.91ppm.bw.png_outline.tsv')
x=as.matrix(x)
y=read.table('/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/1_leaf_shape/022323/rotated_S48_1_59.91ppm.bw.png_outline.tsv')
y=as.matrix(y)
coo=list(sp1=x,sp2=y)

# Add a $fac from scratch
fac <- data.frame(species=letters[1:5], type=c(5:1))

# Then you have to define the subclass using the right builder
# here we have outlines, so we use Out
all_leaves <- Out(coo, fac)

#################################
#2. examine your data

##Take a look by plotting
panel(all_leaves)
stack(all_leaves)
plot(all_leaves)

#scale and center
all_leaves %>% coo_scale %>% coo_center %>% stack()
#add auto align
all_leaves %>% coo_scale %>% coo_center %>% coo_alignxax() %>% coo_slidedirection("up") %>% stack()


#basic statistics
# access the different components
# $coo coordinates
head(all_leaves$coo)
# $fac grouping factors
head(all_leaves$fac)
# table summary
table(bot$fac)

# to see all methods for Coo objects.
methods(class='Coo')

# to see all methods for Out objects.
methods(class='Out') # same for Opn and Ldk

###################################
#3. Morphometrics

#Visualize EFD process
coo_oscillo(all_leaves[1], "efourier")

#apply EFD to all leaves, choose a number of harmonics to use
all_leaves.f <- efourier(all_leaves, nb.h=10)

#now all_leaves.f is a Coe object
#check the distribution of coefficients
boxplot(all_leaves.f, drop=1)

#calculate a PCA on the Coe object and plot it, along with morphospaces, calculated on the fly.
all_leaves.p <- PCA(all_leaves.f)
plot_PCA(all_leaves.p, ~type)

#all in one
all_leaves %>% efourier(nb.h=10) %>% PCA %>% plot(~domes+var)


###################################
#Traditional morphometrics based on size circulatiry, etc
ht <- measure(hearts, coo_area, coo_circularity, d(1, 3))
class(ht)
ht$coe
ht %>% PCA() %>% plot_PCA(~aut)



