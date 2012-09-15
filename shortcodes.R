
#rssinpage, cetsEmbedRSS, flickr-gallery

# Get a list of all files
files <- system("ls *.markdown", intern=T)
#files <- system("ls 2012-*.markdown", intern=T)


#fix_citations(files)

#files <- "test.markdown"

# Show me a list of tags in use
active_tags <- function(files){
keys <- lapply(files, function(file){
  content <- readLines(file)
  lines <- grep("\\[\\/.*?\\]", content)
  unique(gsub(".*(\\[\\/.*?\\]).*", "\\1", content[lines]))
})
message(unique(unlist(keys)))
}



jekyllformat <- function(files, cite=TRUE){
active_tags(files)
fix_codetags(files)
fix_flickr(files)
fix_equations(files)
add_redirects(files)
if(cite)
  fix_citations(files)
rename_private(files) # changes file names, must run last 
}

# Update syntax highlighted code block tags
fix_codetags <- function(files){
lapply(files, function(file){
  content <- readLines(file)
  content <- gsub("\\[code\\]^(\\()", "\n```\n", content) #code not followed by (, eg. [code](link) will be left alone
  content <- gsub("\\[\\/code\\]", "\n```\n", content)
  content <- gsub("\\[code lang *= *['\"](\\w+)['\"]\\]", "\n```\\1\n", content)
  content <- gsub("\\[sourcecode\\]", "\n```\n", content)
  content <- gsub("\\[\\/sourcecode\\]", "\n```\n", content)
  content <- gsub("\\[sourcecode language *= *['\"](\\w+)['\"]\\]", "\n```\\1\n", content)
  content <- gsub("\\[sourcecode lang *= *['\"](\\w+)['\"]\\]", "\n```\\1\n", content)
  content <- gsub("\\[source\\]", "```\n", content)
  content <- gsub("\\[\\/source\\]", "```\n", content)
  content <- gsub("\\[source language *= *['\"](\\w+)['\"]\\]", "\n```\\1\n", content)
  content <- gsub("\\[source lang *= *['\"](\\w+)['\"]\\]", "\n```\\1\n", content)

  content <- gsub("\\[php\\]", "\n```php\n", content)
  content <- gsub("\\[\\/php\\]", "\n```\n", content)
  content <- gsub("\\[html\\]", "\n```html\n", content)
  content <- gsub("\\[\\/html\\]", "\n```\n", content)
  content <- gsub("\\[bash\\]", "\n```bash\n", content)
  content <- gsub("\\[\\/bash\\]", "\n```\n", content)
  content <- gsub("\\[css\\]", "\n```css\n", content)
  content <- gsub("\\[\\/css\\]", "\n```\n", content)
  content <- gsub("\\[xml\\]", "\n```xml\n", content)
  content <- gsub("\\[\\/xml\\]", "\n```\n", content)
  content <- gsub("<code>", "`", content)
  content <- gsub("<\\/code>", "`", content)
  writeLines(content, file)
})
}


# Update flickr tags
fix_flickr <- function(files){
lapply(files, function(file){
  content <- readLines(file)
  content <- gsub("\\[flickr.*?\\]http://flickr.com\\/photos\\/46456847@N08\\/(\\d+)?\\[\\/flickr\\]", "{% flickr_photo \\1 %}", content)
  content <- gsub("\\[flickr.*?\\](\\d+)?\\[\\/flickr\\]", "{% flickr_photo \\1 %}", content)
  writeLines(content, file)
})
}

# Update equation tags
fix_equations <- function(files){
  lapply(files, function(file){
    content <- readLines(file)
    content <- gsub("\\[latex\\]", "<div>\\\\begin{equation}", content)
    content <- gsub("\\[\\/latex\\]", "\\\\end{equation}<\\/div>", content)
    content <- gsub("\\$latex (.*) \\$", "<div>\\\\begin{equation}\\1\\\\end{equation}<\\/div>", content)
    writeLines(content, file)
  })
}
# Consider adding a footnote that post has been converted from a Wordpress site.  


# Add redirects so that old links still work  (tested on test.markdown) 
add_redirects <- function(files){
lapply(files, function(file){
       content <- readLines(file)
       content <- gsub("wordpress_id: (\\d+)", "redirects: [/wordpress/archives/\\1, /archives/\\1]", content)
       writeLines(content, file)
})
}

# Replace citations (tested on test.markdown) 
require(knitcitations)
require(gsubfn)

fix_citations <- function(files){
lapply(files, function(file){
       content <- readLines(file)
       lines <- grep("\\[\\/cite\\]", content)
       if(length(lines>0)){
         cleanbib()
         pattern <- "\\[cite\\]([a-z0-9\\/\\.\\-]+)?\\[\\/cite\\]"
         content <- gsubfn(pattern, citep, content)
         bib <- format(bibliography("html"), "html")
         if(length(bib)>0){
           content <- c(content, "## References\n", bib)
           writeLines(content, file)
         }
       }
})
}

rename_private <- function(files){
lapply(files, function(file){
       content <- readLines(file)
       private <- grep("published: false", content)
       if(length(private) > 0){
         writeLines(content, paste("private", file, sep="_"))
         system(paste("rm", file)) # remove the original file
       }
})
}





# Testing / searching for tags in use
pfind <- function(pattern){
  tags <- lapply(files, function(file){
                 content <- readLines(file)
                 lines <- grep(pattern, content)
                 content[lines]
#                 unique(gsub(paste(".*(", pattern, ").*", sep=""), "\\1", content[lines]))
  })
  unique(unlist(tags))
}

#pfind("\\\\\\\\")
#pfind("\\$latex .*?\\$")

