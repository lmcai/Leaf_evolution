library(raster)


#Load the elevation and biological variable data using the "raster" package
elev <- raster("wc2.1_30s_elev.tif")
BIO1 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_1.tif")
BIO2 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_2.tif")
BIO3 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_3.tif")
BIO4 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_4.tif")
BIO5 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_5.tif")
BIO6 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_6.tif")
BIO7 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_7.tif")
BIO8 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_8.tif")
BIO9 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_9.tif")
BIO10 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_10.tif")
BIO11 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_11.tif")
BIO12 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_12.tif")
BIO13 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_13.tif")
BIO14 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_14.tif")
BIO15 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_15.tif")
BIO16 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_16.tif")
BIO17 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_17.tif")
BIO18 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_18.tif")
BIO19 <- raster("worldclim/wc2.1_30s_bio/wc2.1_30s_bio_19.tif")


#define functions
get_elevation<-function(sp_dat){
	#Extract the elevation value for a given set of coordinates using the "extract" function:
	coords <- data.frame(lon = sp_dat$decimalLongitude, lat = sp_dat$decimalLatitude)

	# Convert the coordinates to spatial points
	pts <- SpatialPoints(coords, proj4string = CRS("+proj=longlat +datum=WGS84"))

	# Extract the elevation value
	elev_values <- extract(elev, pts)
	sp_dat=cbind(sp_dat,elevation = elev_values)
	return(sp_dat)
}

get_worlclimbio<-function(sp_dat){
	#Extract the elevation value for a given set of coordinates using the "extract" function:
	coords <- data.frame(lon = sp_dat$decimalLongitude, lat = sp_dat$decimalLatitude)
	# Convert the coordinates to spatial points
	pts <- SpatialPoints(coords, proj4string = CRS("+proj=longlat +datum=WGS84"))	
	#loop through 19 biological variables
	wc_bio = sp_dat
	wc_bio=cbind(wc_bio,BIO1=extract(BIO1, pts))
	wc_bio=cbind(wc_bio,BIO2=extract(BIO2, pts))
	wc_bio=cbind(wc_bio,BIO3=extract(BIO3, pts))
	wc_bio=cbind(wc_bio,BIO4=extract(BIO4, pts))
	wc_bio=cbind(wc_bio,BIO5=extract(BIO5, pts))
	wc_bio=cbind(wc_bio,BIO6=extract(BIO6, pts))
	wc_bio=cbind(wc_bio,BIO7=extract(BIO7, pts))
	wc_bio=cbind(wc_bio,BIO8=extract(BIO8, pts))
	wc_bio=cbind(wc_bio,BIO9=extract(BIO9, pts))
	wc_bio=cbind(wc_bio,BIO10=extract(BIO10, pts))
	wc_bio=cbind(wc_bio,BIO11=extract(BIO11, pts))
	wc_bio=cbind(wc_bio,BIO12=extract(BIO12, pts))
	wc_bio=cbind(wc_bio,BIO13=extract(BIO13, pts))
	wc_bio=cbind(wc_bio,BIO14=extract(BIO14, pts))
	wc_bio=cbind(wc_bio,BIO15=extract(BIO15, pts))
	wc_bio=cbind(wc_bio,BIO16=extract(BIO16, pts))
	wc_bio=cbind(wc_bio,BIO17=extract(BIO17, pts))
	wc_bio=cbind(wc_bio,BIO18=extract(BIO18, pts))
	wc_bio=cbind(wc_bio,BIO19=extract(BIO19, pts))
	return(wc_bio)
}



####################################
#Loop through species

sp_list=read.csv('oro_sp_set1.txt',header=F)

for (sp in sp_list$V1){
	sp_dat=read.csv(paste('gbif/',sp,'.cleaned.csv',sep=''))
	sp_clim=get_elevation(sp_dat)
	sp_clim=get_worlclimbio(sp_clim)
	write.csv(sp_clim,paste('worldclim/',sp,'.worldclim.csv',sep=''), row.names=FALSE)
}




#visualization
col_pal <- colorRampPalette(c("darkblue", "blue", "green", "yellow", "red"))
# Set the plot parameters
par(mar = c(5, 5, 2, 2), mfrow = c(1, 1))

# Plot the elevation values
plot(elev, col = col_pal(100), main = "Elevation")
points(pts, pch = 16, col = "black")
#text(pts, labels = elev_values, cex = 0.8, pos = 3)

#zoom in in east asia
east_asia_extent <- extent(50, 150, -20, 60)
elev_crop <- crop(elev, east_asia_extent)
col_pal <- colorRampPalette(c("darkblue", "blue", "green", "yellow", "red"))
# Set the plot parameters
par(mar = c(5, 5, 2, 2), mfrow = c(1, 1))

# Plot the elevation values
plot(elev_crop, col = col_pal(100), main = "Elevation in East Asia")
points(pts, pch = 16, cex=0.2, col = "white")
