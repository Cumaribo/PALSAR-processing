


packs <- c('raster','rgdal','parallel', 'R.utils', 'rvest','xml2','tidyverse', 'landscapemetrics', 'sf','dplyr','httr','getPass','gdalUtils','gdalUtilities','rgeos', 'viridis', 'rasterVis','rlang', 'rasterDT', 'furrr')
sapply(packs, require, character.only = TRUE)


#install.packages("remotes")
#remotes::install_github("MirzaCengic/gdalR")

library(gdalR)

dir. <- "/storage/home/TU/tug76452/Lee_filter"


tiffes<- dir(dir., pattern='SN.tif')

tiffes <- tiffes[c(7,8,10,11,13,14,16,17,19,20)]
#tiffes <- tiffes[-3]


tiffes <- tiffes[20]

tiffes1 <- file.path(dir.,tiffes)
                                        #create folder to store the new rasters

dir.create("/storage/home/TU/tug76452/Lee_filter/outs")


reference.<-'/storage/share/Shared_summer_21/mask_colombia.tif'

reference.<-raster('/storage/share/BiomapCol_22/mask_colombia.tif')

tiff2 <- tiffes2[7]

tiffes2  <- file.path("/storage/home/TU/tug76452/Lee_filter/outs",tiffes)

system.time(
    malr <- function(x,y)
        gdalwarp(
            src=x,
            dstfile=y,
            tr=res,
            te=t1,
            nThreads=8,
            verbose=TRUE),
    (tiffes1,tiffes2)

teta <- Map(function(x,y)
gdal_resample(unaligned=tiffes1,
            reference=reference.,
            dstfile=tiffes2,
            nThreads=8,
            verbose=TRUE)

 gdal_resample <- function(input, output, r_base, method = 'bilinear'){#, ncores) {
   #Geometry attributes
   t1 <- c(xmin(r_base), ymin(r_base),
           xmax(r_base), ymax(r_base))
   res <- res(r_base)
                     #' #GDAL time!
   gdalwarp(tiffes1, tiffes2,
  tr = res, te = t1, r = method)#, num_threads=ncores)
 resample_raster = raster(tiffes2)
 return(resample_raster)
 }


mem_future <- 10000*1024^2 #this is toset the limit to 1GB
options(future.globals.maxSize= mem_future)
plan(multisession, workers=4)

test<- map(1:length(tiffes1), function(x) gdal_resample(tiffes1[x], tiffes2[x], reference., method='bilinear'))#, ncores=6)

test<- gdal_resample(tiffes1[4], tiffes2[4], reference., method='bilinear')#, nc

raster<-raster(tiffes1[2])

dir.create("tempfiledir")
tempdir=paste(getwd(),"tempfiledir", sep="//")
rasterOptions(tmpdir=tempdir)

r_base<-raster('/storage/share/Shared_summer_21/mask_colombia.tif')
t1 <- c(xmin(r_base), ymin(r_base),
           xmax(r_base), ymax(r_base))
   res <- res(r_base)
   

test2 <- gdalwarp(tiffes1[2], tiffes2[2], tr = res, te = t1, r = 'bilinear')      




tiffes1

tiffes2[2]

test <-resample(raster, reference.)

setwd("/storage/home/TU/tug76452/Lee_filter/outs")
getwd()

writeRaster(test,filename='HH_2016_SN', format='GTiff') 



arnings()


# i forgot to activate tyhe workers. 
library(furrr)


test2 <- future_map(2:length(tiffes1), function(x) gdal_resample(tiffes1[x], tiffes2[x], reference., method='bilinear'))


)

tiffes2[2]


