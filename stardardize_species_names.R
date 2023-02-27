library(Taxonstand)
x=read.csv('~/Downloads/species_ID.csv')
y=TPL(x$Species.Name, corr = TRUE)
write.csv(y,'standard_species_ID.csv')