
#' Auth caching demo function
#' 
#' @param x a parameter value x 
#' @return stores x in envirnoment AuthCache and returns value of x invisbily
#' @export
auth <- 
function(x){
  assign('x', x, envir=AuthCache)
  invisible(x)
} 



#' Auth caching demo function
#' 
#' @return returns x from envirnoment AuthCache
#' @export
get_auth <- 
function(){
  get('x', envir=AuthCache)
} 



