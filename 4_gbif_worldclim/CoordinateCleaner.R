library(countrycode)
library(CoordinateCleaner)
library(dplyr)
library(ggplot2)
library(rgbif)
library(sp)

clean_records <-function(sp){
	system('head -1 orobanchaceae_coordinates.GBIF.sp_filtered.tsv >temp.tsv')
	system(paste('grep \"',sp,'\" orobanchaceae_coordinates.GBIF.sp_filtered.tsv >>temp.tsv',sep=''), intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE,timeout = 0)
    ##############################
	#I. read in data or retreive data from gbif
	#select gbif columns of interest
	dat=read.table('temp.tsv',header=T,sep='\t',fill=T)
	subdat <- dat %>%
  		dplyr::select(species, infraspecificEpithet, decimalLongitude, decimalLatitude, elevation, countryCode, gbifID, taxonRank, coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode)
    #Remove unsuitable data sources, especially fossils 
	#which are responsible for the majority of problems in this case
	#table(dat$basisOfRecord)
	subdat <- filter(subdat, basisOfRecord == "HUMAN_OBSERVATION" | 
                         basisOfRecord == "OBSERVATION" |
                         basisOfRecord == "PRESERVED_SPECIMEN"|
                         basisOfRecord == "MATERIAL_SAMPLE")
	options(digits = 12)
	subdat$decimalLongitude=as.numeric(subdat$decimalLongitude)
	subdat$decimalLatitude=as.numeric(subdat$decimalLatitude)
	subdat$coordinateUncertaintyInMeters=as.numeric(subdat$coordinateUncertaintyInMeters)
	subdat=subdat[!is.na(subdat$decimalLongitude) & !is.na(subdat$decimalLatitude),]
    subdat<- subdat%>%
    	filter(taxonRank =='SPECIES' | taxonRank =='SUBSPECIES' | taxonRank =='VARIETY' )
	##############################
	#II. Visualize the data on a map
	#plot data to get an overview
	pdf(file = paste(sp,'.raw.pdf',sep=''), width = 8, height = 6)
	wm <- borders("world", colour="gray50", fill="gray50")
	plot1 <-ggplot()+ coord_fixed()+ wm +
		geom_point(data = subdat, aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5)+
		theme_bw()
	print(plot1)
	dev.off()
	##############################
	#III. Use CoordinateCleaner to automatically flag problematic records
	#1) identify geographic outliers
	#convert country code from ISO2c to ISO3c
	subdat$countryCode <-  countrycode(subdat$countryCode, origin =  'iso2c', destination = 'iso3c')
	#flag problems
	subdat <- data.frame(subdat)
	flags <- clean_coordinates(x = subdat, 
                           lon = "decimalLongitude", 
                           lat = "decimalLatitude",
                           countries = "countryCode",
                           species = "species",
                          tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                    "zeros", "countries")) # most test are on by default
	#Exclude problematic records
	dat_cl <- subdat[flags$.summary,]
	#The flagged records
	dat_fl <- subdat[!flags$.summary,]
	#2) identify temporal outliers
	flags <- cf_age(x = dat_cl,
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                taxon = "species", 
                min_age = "year", 
                max_age = "year", 
                value = "flagged")
	dat_cl <- dat_cl[flags, ]
	##############################
	#IV. Improving data quality using GBIF meta-data
	#Remove records with low coordinate precision
	#hist(dat_cl$coordinateUncertaintyInMeters / 1000, breaks = 20)
	dat_cl <- dat_cl %>%
		filter(coordinateUncertaintyInMeters / 1000 <= 30 | is.na(coordinateUncertaintyInMeters))

	#visualize
	pdf(file = paste(sp,'.cleaned.pdf',sep=''), width = 8, height = 6)
	plot2<-ggplot()+ coord_fixed()+ wm +
  		geom_point(data = dat_cl, aes(x = decimalLongitude, y = decimalLatitude),
        colour = "darkred", size = 0.5)+
        theme_bw()
    print(plot2)
	dev.off()  

	write.csv(dat_cl,paste(sp,'.cleaned.csv',sep=''), row.names=FALSE)
	#return number of records in the raw and filtered dataset
	return(c(length(subdat$species),length(dat_cl$species)))
}


###########
#Loop through species
sp_list=read.csv('oro_sp_set1.txt',header=F)
num_rec=c('Species','raw_gbif','filtered_gbif')
for (sp in sp_list$V1){
	num_rec=rbind(num_rec,c(sp,clean_records(sp)))
}



#Age of records
#table(dat_cl$year)
## 
## 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 
##    6   13   82   34   14   17   30   28   39   48   69   78   76  103  149  156  147  283  419  284  501  492  610  290  202
#dat_cl <- dat_cl%>%
#  filter(year > 1945) # remove records from before second world war

#table(dat_cl$family) #that looks good
## 
## Felidae 
##    4170
#dat_cl <- dat_cl%>%
#  filter(family == 'Felidae')

#table(dat_cl$taxonRank) # this is also good
## 
##    SPECIES SUBSPECIES 
##       1065       3105