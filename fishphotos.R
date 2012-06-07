require(httr)
require(XML)
require(RCurl)

family <- "Labridae"


## Download all images
get_fish_pages <- function(family){
  base <- "http://pbs.bishopmuseum.org/images/JER/"
  a <- GET(paste(base, "images.asp?nm=", family, "&loc=&size=i&cols=0", sep=""))
  b <- htmlParse(a)
  node <- getNodeSet(b, "//@href")
}

## USE:
## pages <- get_fish_pages("Labridae")
## download_images(pages)
## length_data <- get_lengths(pages)

download_images <- function(node){
  sapply(4:length(node), function(i){
    id <- as.character(gsub(".*ID=(\\d.+)", "\\1", node[[i]]))
    download.file(paste(base, "large/", id, ".jpg", sep=""), paste(id, ".jpg", sep=""))
  })
}


get_lengths <- function(node){
  handle <- getCurlHandle()
  sapply(4:length(node), function(i){
    img <- paste(base, node[[i]], sep="")
    page <- getURLContent(img, curl=handle)
    p <- strsplit(page[[1]], "\n")[[1]]
    p <- gsub("\t", "", p)
    p <- gsub("\r", "", p)
    j <- grep("Size", p)
    lengths <- strsplit( gsub(".*font> (\\d.*) SL; (\\d.*) TL.*", "\\1,\\2", p[j]), ",")
  })
}


parse_image_pages <- function(node){
  pages <- sapply(4:length(node), function(i){
    img <- paste(base, node[[i]], sep="")
    page <- getURLContent(img, curl=handle)
    p <- strsplit(page[[1]], "\n")[[1]]
    p <- gsub("\t", "", p)
    p <- gsub("\r", "", p)
    p <- htmlParse(p)
  }) 
}
