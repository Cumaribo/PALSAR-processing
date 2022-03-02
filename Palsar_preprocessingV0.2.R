#Purpose: This script presents a workflow to prepare ALOS-PALSAR data and re-sample it
# to build multi stack raster bricks, combining SAR and Landsat Multi Spectral data
# Authors: Jeronimo Rodriguez and Victoria Sarmiento 2020
# Update: March 2022

                                        # Required libraries --------------
dir()

packs <- c('raster', 'tidyverse', 'furrr')
sapply(packs, require, character.only = TRUE)

# stew tempdirectory in currenbt wd
dir.create("tempfiledir")
tempdir=paste(getwd(),"tempfiledir", sep="//")
rasterOptions(tmpdir=tempdir)
# 

# create untar function
files <- list.files(".", "tar.gz")
# Create function for untar
fdc <- function(files,i){
    f1 <- untar(files[i])
    return(f1)
}

#CREATE EMPTY list
tiffes <- list()
# run function
ptm<-proc.time()
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
files1 <- list.files(".", "sl_HH_F02DAR$")
files2 <- list.files(".", "sl_HV_F02DAR$")

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
set year
  year<-'2018'
namer<-c('HH', 'HV')
#dater<-### fill this ####
merged1 <- do.call(merge, r.list1)
merged2 <- do.call(merge, r.list2)
rm(r.list1, r.list2)                                                                                                                                                        
merged <- stack(merged1, merged2)                                                                                                                                                                          
msk<-raster('/path/to/template/template.tif')                                                                                                                                            
merged <- crop(merged, extent(msk)))                                                                                                                                                                                                                       |                                                                                                      
writeRaster(merged, paste('palsar', year, sep='_'), format='GTiff',overwrite=TRUE)  
#######################################
# load the filtered rasters  

setwd("path/to/thelee outputs ")
files <- list.files(".", "tif")
r.list <- list()
for(i in 1:length(files)){
    r.list[[i]] <- raster(files[i])}
# sigma naught correction function
sigma_n <- function(pals){
    filtered <- 10*log10(pals^2)-83
}
r.list <- map(1:length(r.list), function(x) sigma_n(r.list[[x]])) 
map(1:length(r.list), function(x) writeRaster(r.list[[x]],paste(names(r.list[[x]]), 'SN', sep='_'),format='GTiff'))
