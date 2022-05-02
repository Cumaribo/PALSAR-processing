#This function resamples the palsar data into the ARD spatial resolution, using the outline of colombia as a template.

packs <- c('raster','rgdal','parallel', 'gdalR', 'R.utils', 'rvest','xml2','tidyverse', 'landscapemetrics', 'sf','dplyr','httr','getPass','gdalUtils','gdalUtilities','rgeos', 'viridis', 'rasterVis','rlang', 'rasterDT', 'furrr')
sapply(packs, require, character.only = TRUE)

dir. <-"/storage/home/TU/tug76452/RA_Spring_2022/Mekong"

#Load list of files. Use "SN" as the pattern
tiffes<- dir(dir., pattern='SN.tif')
#Subset (if necessary)
#Create list of paths to the tif files
tiffes1 <- file.path(dir.,tiffes)
                                        #create folder to store the new rasters
#There is a better wy to do this. Just paste the first part of the path.

dir.create("/storage/home/TU/tug76452/RA_Spring_2022/Mekong/outs")
#Path to the template raster

reference.<-raster('/storage/share/Mekong_ARD/Pheno_C/2020_Mekong_ard.tif')

                                        #Create list of paths for the destinations### This can be improvved, just read the string and put "outs" after.
tiffes2  <- file.path("/storage/home/TU/tug76452/RA_Spring_2022/Mekong/outs",tiffes)


#https://csaybar.github.io/blog/2018/12/05/resample/
# Gere is where i get the fucntion from, but each time is a pain in the ass!! it was working two weeks ago. So frustrating!!!!


                                        #Function gdal_resample:
 gdal_resample <- function(input, output, r_base, method = 'bilinear'){
   #Geometry attributes
   t1 <- c(raster::xmin(r_base), raster::ymin(r_base),
           raster::xmax(r_base), raster::ymax(r_base))
   res <- raster::res(r_base)
                    #GDAL time!
   gdalwarp(tiffes1, tiffes2,
  tr = res, te = t1, r = method)#, num_threads=ncores)
 resample_raster = raster(input)
 return(resample_raster)
 }

#Set the environment for multi core. Pending to find a more efficient way to do this
mem_future <- 10000*1024^2 #this is toset the limit to 1GB
options(future.globals.maxSize= mem_future)
plan(multisession, workers=4)

test<- map(1:length(tiffes1), function(x) gdal_resample(tiffes1[x], tiffes2[x], reference., method='bilinear'))


tes1 <- gdal_resample(tiffes1[1], tiffes2[1], reference., method='bilinear')


I am getting this stupid error that i had already solved !!!
dir()

getwd()


dir()

files <- list.files('.', pattern='2020_Mekong')

mdw <-'/storage/share/Mekong_ARD/'
setwd(mdw)

stest1 <- raster(tiffes1[1])

fyuckyou <- raster(tiffes2[1])

reference.

https://gist.github.com/johnbaums/ae81ad566061534f9c31


gdal_project <- function(infile, outdir, xres, yres=xres, s_srs, t_srs,
                            resampling, extent, of='GTiff', extension='tif',
                            ot='Float32') {
    outfile <- infile
    extension(outfile) <- sub('^\\.+', '.', paste0('.', extension))
    outfile <- file.path(normalizePath(outdir), basename(outfile))
    system(sprintf('gdalwarp -ot %s -s_srs "%s" -t_srs "%s" -r %s -multi %s -tr %s -dstnodata -9999 -of %s "%s" "%s"',
                   ot, s <- srs, t <- srs, resampling,
                   if(!missing(extent)) paste(c('-te', extent), collapse=' ') else '',
                   paste(xres, yres), of, infile, outfile))
    system(sprintf('gdalinfo -stats %s', outfile), show.output.on.console=FALSE)
}

srs <- '+proj=longlat +datum=WGS84 +no <- defs +ellps=WGS84 +towgs84=0,0,0'

test<- map(1:length(tiffes1), function(x) gdal_project(infile=tiffes1[x],outdir= "/storage/home/TU/tug76452/RA_Spring_2022/Mekong/outs", xres=raster::res(reference.),yres=xres,s_srs=srs, t_srs=s_srs,  resampling='bilinear',  extent=c(raster::xmin(r_base), raster::ymin(r_base),
           raster::xmax(r_base), raster::ymax(r_base)), of='GTiff', extension='tif', ot= 'Float32'))
