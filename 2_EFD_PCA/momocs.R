library(momocs)
x=read.table('~/Documents/GitHub/Leaf_evolution/1_EFD/toy/test.txt')
x=as.matrix(x)
y=read.table('~/Documents/GitHub/Leaf_evolution/1_EFD/toy/S30_2_59.91ppm.bw.png_outline.tsv')
y=as.matrix(y)
test=list(sp1=x,sp2=y)
a=Out(test)

## Not run: 
# to see all methods for Coo objects.
methods(class='Coo')

# to see all methods for Out objects.
methods(class='Out') # same for Opn and Ldk

# Let's take an Out example. But all methods shown here
# work on Ldk (try on 'wings') and on Opn ('olea')
bot

# Primarily a 'Coo' object, but also an 'Out'
class(bot)
inherits(bot, "Coo")
panel(bot)
stack(bot)
plot(bot)

# Getters (you can also use it to set data)
bot[1] %>% coo_plot()
bot[1:5] %>% str()

# Setters
bot[1] <- shapes[4]
panel(bot)

bot[1:5] <- shapes[4:8]
panel(bot)

# access the different components
# $coo coordinates
head(bot$coo)
# $fac grouping factors
head(bot$fac)
# or if you know the name of the column of interest
bot$type
# table
table(bot$fac)
# an internal view of an Out object
str(bot)

# subsetting
# see ?filter, ?select, and their 'see also' section for the
# complete list of dplyr-like verbs implemented in Momocs

length(bot) # the number of shapes
names(bot) # access all individual names
bot2 <- bot
names(bot2) <- paste0('newnames', 1:length(bot2)) # define new names

# Add a $fac from scratch
coo <- bot[1:5] # a list of five matrices
length(coo)
sapply(coo, class)

fac <- data.frame(name=letters[1:5], value=c(5:1))
# Then you have to define the subclass using the right builder
# here we have outlines, so we use Out
x <- Out(coo, fac)
x$coo
x$fac


## End(Not run)