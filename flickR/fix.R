
Add .convert to call to processFlickrResponse()





nargs = length(formals(f))
#formals(f)[[nargs + 1]] = "XML"
aa = formals(f)
a[["format"]]= "XML"
formals(f)[[nargs + 2]] = as.name("NULL")
formals(f)[[nargs + 3]] = list()
formals(f)[[nargs + 4]] = as.name("NULL")
names(formals(f))[nargs + (1:4)] = c("format", ".convert", ".opts", ".curl")
  
  body(f)[[4]][[6]] = as.name(".convert")
  names(body(f)[[4]])[6] = ".convert"
  body(f)[[3]][[3]][[4]] = as.name(".opts")
  body(f)[[3]][[3]][[5]] = as.name(".curl")
  names(body(f)[[3]][[3]])[4:5] = c(".opts", ".curl")
