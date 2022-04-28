#Purpose: This script presents a workflow to prepare ALOS-PALSAR data and re-sample it
# to build multi stack raster bricks, combining SAR and Landsat Multi Spectral data
# Authors: Jeronimo Rodriguez and Victoria Sarmiento 2020
# Update: April 2022

                                        # Required libraries --------------
setwd('/storage/home/TU/tug76452/RA_Spring_2022/Mekong')

packs <- c('raster', 'tidyverse', 'furrr')
sapply(packs, require, character.only = TRUE)

# stew tempdirectory in currenbt wd
dir.create("tempfiledir")
tempdir=paste(getwd(),"tempfiledir", sep="//")
rasterOptions(tmpdir=tempdir)
# 

# create untar function
files <- list.files(".", "zip")
# Create function for untar
fdc <- function(files,i){
    f1 <- unzip(files[i])#, exdir = "/storage/home/TU/tug76452/RA_Spring_2022/Mekong/MMXV")
    return(f1)
}

#CREATE EMPTY list
tiffes <- list()
# run function

for(i in 1:length(files)){
    tiffes[[i]] <- fdc(files,i)
}

# CREATE A LIST OF HH/HV FILES ---------------------------------------------
# You need to create a list of the actual raster. The code below selects ".HV_F02DAR" for the HV band
# or ".HH_F02DAR" for the HH band. Take into account that the pattern in the name could change depending on the
# date of your Palsar Data.
# IMPORTANT: You need to include "$" at the end so R will not include the ".hdr" files in the list.
# ** You need to perform this step for each band (HH/HV).
                                        #List HH/HV files
#This is missing. Depending on the year, the names of the rasters change slightly. (include the "F02DAR" or not)
# and needs to be adjusted manually
files1 <- list.files(".", "sl_HH_F02DAR")
files2 <- list.files(".", "sl_HV_F02DAR")

#here, add a piece of code that reads form inside folders
mem_future <- 10000*1024^2 #this is to set the limit to 1GB
options(future.globals.maxSize= mem <- future)
plan(multisession, workers=2)
                                        # create an empty list
r.list1 <- list()
r.list2 <- list()                                        # load the rasters
for(i in 1:length(files1)){
    r.list1[[i]] <- raster(files1[i])}
for(i in 1:length(files2)){
  r.list2[[i]] <- raster(files2[i])}
 # merge the raster/create the mosaic
#set year
  year<-'2021'
namer<-c('HH', 'HV')
#dater<-### fill this ####
merged1 <- do.call(merge, r.list1)
merged2 <- do.call(merge, r.list2)
rm(r.list1, r.list2)                                                                                                 
merged <- stack(merged1, merged2)                                                                                    
msk<-raster('/storage/share/Mekong_ARD/Classifications/2000_Mekong_ard.tif')
merged <- crop(merged, extent(msk))
writeRaster(merged, paste('palsar', year, sep='_'), format='GTiff',overwrite=TRUE)  
#######################################


getwd()

