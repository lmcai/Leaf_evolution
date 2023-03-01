library(countrycode)
library(CoordinateCleaner)
library(dplyr)
library(ggplot2)
library(rgbif)
library(sp)

##############################
#I. read in data or retreive data from gbif
#select gbif columns of interest
dat <- dat %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
         gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
         basisOfRecord, institutionCode, datasetName)

# remove records without coordinates
#dat <- dat%>%
#  filter(!is.na(decimalLongitude))%>%
#  filter(!is.na(decimalLatitude))

##############################
#II. Visualize the data on a map
#plot data to get an overview
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = dat, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()


##############################
#III. Use CoordinateCleaner to automatically flag problematic records
#1) identify geographic outliers

#convert country code from ISO2c to ISO3c
dat$countryCode <-  countrycode(dat$countryCode, origin =  'iso2c', destination = 'iso3c')

#flag problems
dat <- data.frame(dat)
flags <- clean_coordinates(x = dat, 
                           lon = "decimalLongitude", 
                           lat = "decimalLatitude",
                           countries = "countryCode",
                           species = "species",
                          tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                    "zeros", "countries")) # most test are on by default
#2) identify temporal outliers
flags <- cf_age(x = dat_cl,
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                taxon = "species", 
                min_age = "year", 
                max_age = "year", 
                value = "flagged")

##############################
#IV. Improving data quality using GBIF meta-data
#Remove records with low coordinate precision
hist(dat_cl$coordinateUncertaintyInMeters / 1000, breaks = 20)


dat_cl <- dat_cl %>%
  filter(coordinateUncertaintyInMeters / 1000 <= 100 | is.na(coordinateUncertaintyInMeters))

#Remove unsuitable data sources, especially fossils 
#which are responsible for the majority of problems in this case
table(dat$basisOfRecord)
## 
##     FOSSIL_SPECIMEN   HUMAN_OBSERVATION MACHINE_OBSERVATION     MATERIAL_SAMPLE         OBSERVATION  PRESERVED_SPECIMEN 
##                  10                4706                   3                  37                   1                 241 
##             UNKNOWN 
##                   2

dat_cl <- filter(dat_cl, basisOfRecord == "HUMAN_OBSERVATION" | 
                         basisOfRecord == "OBSERVATION" |
                         basisOfRecord == "PRESERVED_SPECIMEN")

#Individual count
table(dat_cl$individualCount)
## 
##   1   2   3   4   5   6   9  11  14  15  20 
## 108  35   4   5   5   5   1   3   1   1   1
dat_cl <- dat_cl%>%
  filter(individualCount > 0 | is.na(individualCount))%>%
  filter(individualCount < 99 | is.na(individualCount)) # high counts are not a problem

#Age of records
table(dat_cl$year)
## 
## 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 
##    6   13   82   34   14   17   30   28   39   48   69   78   76  103  149  156  147  283  419  284  501  492  610  290  202
dat_cl <- dat_cl%>%
  filter(year > 1945) # remove records from before second world war

table(dat_cl$family) #that looks good
## 
## Felidae 
##    4170
dat_cl <- dat_cl%>%
  filter(family == 'Felidae')

table(dat_cl$taxonRank) # this is also good
## 
##    SPECIES SUBSPECIES 
##       1065       3105