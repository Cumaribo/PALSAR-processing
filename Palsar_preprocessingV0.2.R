#Purpose: This script presents a workflow to prepare ALOS-PALSAR data and re-sample it 
#         to build multi stack raster bricks, combining SAR and Landsat Multi Spectral data
# Authors: Jeronimo Rodriguez and Victoria Sarmiento 2020 
# Date: July 2020

# Required libraries --------------
library(raster)

# Setting working directory --------
inpath='Z:/PALSAR'
setwd(inpath)

# DECOMPRESSING tar.gz ------------------------------------------------ 
# List of selected tar.gz files and untar the .gz files
files <- list.files(".", "18_MOS_F02DAR.tar.gz")

#untar all the tar.gz files
fdc <- function(files,i){
   f1 <- untar(files[i])
   return(f1)
 }
 
list <- list()
 ptm<-proc.time()
 for(i in 1:length(files)){
   list[[i]] <- fdc(files,i)
 }

dir() #checking that the files where decompressed 

# CREATE A LIST OF HH/HV FILES ---------------------------------------------
# You need to create a list of the actual raster. The code below selects ".HV_F02DAR" for the HV band 
# or ".HH_F02DAR" for the HH band. Take into account that the pattern in the name could change depending on the 
# date of your Palsar Data. 
# IMPORTANT: You need to include "$" at the end so R will not include the ".hdr" files in the list.
# ** You need to perform this step for each band (HH/HV). 

#List only HH/HV files 
files <- list.files(".", "HH_F02DAR$")

# create an empty list
r.list <- list()

# load the rasters
for(i in 1:length(files)){
  r.list[[i]] <- raster(files[i])}
# merge the raster/create the mosaic
merged <- do.call(merge, r.list)
plot(merged)


# REPROJECT AND CROP ----------------------------------------------------
# The native CRS of PALSAR data is WGS 84 and the pixel resolution is ~24m. You still need to reproject
# and re-sample your data to convert into 30m resolution. It should not take that long.
# ** You need to perform this step for each band (HH/HV).

#load a template with your Landsat Data that contains the desire CRS. 
# The template will be sued to crop, reproject and resample the PALSAR Data. 
template <- raster('topcor.tif') # any band works fine.

#Reproject
template <- projectRaster(merged, template)
crs('merged') #check the new CRS 


# crop the image to the same extent
merged <- crop(merged, extent(template))

# check visaully that your Palsar and Landsat data cover the area correctly. 
plot (merged)
plot(template, add=TRUE)

# re-sample and converts data from integer to float. You need to round it back
merged <- resample(merged, template)
merged <- round(merged, digits=0)

# Make a mask and reclassify values from 0 to 20000 to get rid of NA's. 
m <- c(-Inf,-1,NA, 0, Inf, 1)
m <- matrix(m, ncol=3, byrow=TRUE)
msk <- reclassify(template, m)
plot(msk)
merged <- mask(merged, msk)

#Save your raster. 
writeRaster(merged, 'Palsar_18HH.tif', format='GTiff')

# You still need to run the Speckle (Lee) filters. 
# Use ESA's SNAP for this. You can download it here:https://step.esa.int/main/download/snap-download/

# CONVERT DN INTO dB ----------------------------------------------------------------
# Once you have run the Speckle filter you can proceed with the conversion of Digital numbers into sigma-naught.
# Conversion from digital number (DN) to the backscattering coefficient (sigma-naught) (dB) 
# can be done by the following equations: s = 10*log10(DN^2)+CF 

#load your Palsar Data
merged <- brick("Palsar_10HH_Spk.tif") 

# Convert DN to dB
merged  <- 10*log10(merged^2)-83
plot(merged)

writeRaster(merged, 'Palsar10HH_dB.tif', format='GTiff')

# -------------------------  END ----------------------------------------
