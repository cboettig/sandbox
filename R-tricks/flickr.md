


It's amazing how nice it is to work with well-developed software.  It took me about 20 minutes to extend Yuhui's interface to allow me to upload images through flickr instead of imgur, and embed them into a wordpress blog using the shortcode from the flickr gallery plugin.  

To do this, I just modified the hook used by the markdown format.  First, I define a quick R function that uploads to flickr and returns the flickr identifier number.  For the moment this is just calling a command-line flickr uploader, though it should be straight-forward to replace this with something like flickR, if I can get it on R-2.14.  


Create the dynamic document header: 
[code lang='r']
render_wordpress()
opts_knit$set(upload = TRUE)
opts_knit$set(imgur.key = getOption("imgur"))
[/code]




[code lang='r']
flickr <- function(file, 
    tags = "", description = "", 
    public = TRUE) {
    out <- system(paste("flickr_upload --tag=\"", 
        tags, " \" --description=\"", 
        description, "\"", 
        " --public ", as.integer(public), 
        file), intern = TRUE)
    gsub(".*ids=(\\d+)", 
        "\\1", out[3])
}
[/code]



Once we have such an uploading function, it's super simple to wrap into knitr.  I let my function be triggered by the same "upload" option that Yuhui introduced for imgur, but instead call the flickr function above,

[code lang='r']
.flickr.url = function(x) {
    file = paste(x, collapse = ".")
    if (opts_knit$get("upload")) {
        flickr(file)
    } else file
}
[/code]



Lastly I define the function hook to run the upload and return the shortcode:
[code lang='r']
hook_plot_flickr = function(x, 
    options) {
    sprintf("[flickr]%s[/flickr]", 
        .flickr.url(x))
}
[/code]




I can then define a wordpress rendering environment by mapping the hooks to my choices.  
[code lang='r']
render_wordpress <- function() {
    render_gfm()
    options(width = 30)
    opts_knit$set(upload = TRUE)
    output = function(x, 
        options) paste("[code]\n", 
        x, "[/code]\n", 
        sep = "")
    warning = function(x, 
        options) paste("[code]\n", 
        x, "[/code]\n", 
        sep = "")
    message = function(x, 
        options) paste("[code]\n", 
        x, "[/code]\n", 
        sep = "")
    inline = function(x, 
        options) paste("<pre>", 
        x, "</pre>", sep = "")
    error = function(x, 
        options) paste("[code]\n", 
        x, "[/code]\n", 
        sep = "")
    source = function(x, 
        options) paste("[code lang='r']\n", 
        x, "[/code]\n", 
        sep = "")
    knit_hooks$set(output = output, 
        warning = warning, 
        message = message, 
        inline = inline, 
        error = error, 
        source = source, 
        plot = hook_plot_flickr)
}
[/code]



Note that the rendering sets a custom 30 character width that fits my theme better. Now simply adding the call to render_wordpress in the header of my documents will render this in wordpress format.  If you're reading this on wordpress, it was already in the header. Any figures will embed as flickr shortcode:

[code lang='r']
library(ggplot2)
qplot(hp, mpg, 
    data = mtcars) + geom_smooth()
[/code]
[flickr]6793394960[/flickr]




It would be nicer to have built this around flickR, and provide the urls so that the image can be used without the wordpress flickr shortcode. But for now, the real point is that it's intuitive to extend knitr to this very customized format, specific to my platform, my plugins, and my shortcodes, with minimal effort.  All thanks to Yuhui's very nice implementation of knitr.   



