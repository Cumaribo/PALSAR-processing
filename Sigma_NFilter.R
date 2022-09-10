#Sigma Nought Filter for ALOS-PALSAR data
#this code takes PALSAR dual polarized SAR data that has already been filterd (speckle) and set the Signmanought dB correction
packs <- c('raster', 'tidyverse', 'furrr')
sapply(packs, require, character.only = TRUE)

dir()

files <- list.files(".", "Spk.tif")

r.list1 <- list()
for(i in 1:length(files)){
    r.list1[[i]] <- raster(files[i], band=1)
}
r.list2 <- list()
for(i in 1:length(files)){
    r.list2[[i]] <- raster(files[i], band=2)
}

sigma_n <- function(pals){
    filtered <- 10*log10(pals^2)-83
}

r.list1 <- map(1:length(r.list1), function(x) sigma_n(r.list1[[x]])) 
map(1:length(r.list), function(x) writeRaster(r.list[[x]],paste(names(r.list[[x]]), 'HH_SN', sep='_'),format='GTiff'))
r.list2 <- map(1:length(r.list2), function(x) sigma_n(r.list2[[x]])) 

map(1:length(r.list2), function(x) writeRaster(r.list2[[x]],paste(names(r.list[[x]]), 'HV_SN', sep='_'),format='GTiff'))



names(r.list2[[1]])
