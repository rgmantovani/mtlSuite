# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getHyperSpace = function(learner, ...) {

  name = gsub(pattern="regr.|classif.|.featsel|.preproc|.imputed", replacement="", x=learner)
  substring(name, 1, 1) = toupper(substring(name, 1, 1)) 
  fn.space = get(paste0("get", name , "Space"))
  par.set = fn.space(...)

  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getGaussprSpace = function(...) {
  par.set = makeParamSet(
    makeNumericParam(id = "sigma", lower = -15, upper = 15, trafo = function(x) {2^x})
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getSvmSpace = function(...) {
  par.set = makeParamSet(
    makeNumericParam(id = "cost" , lower = -15, upper = 15, trafo = function(x) 2^x),
    makeNumericParam(id = "gamma", lower = -15, upper = 15, trafo = function(x) 2^x)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRpartSpace = function(...) {
  args = list(...)
  par.set = makeParamSet(
    makeIntegerParam(id = "cp", lower = -4, upper = -1, trafo = function(x) 10^x),
    makeIntegerParam(id = "minsplit", lower = 1, upper = min(7, floor(log2(args$n))), 
      trafo = function(x) 2^x),
    makeIntegerParam(id = "minbucket", lower = 0, upper = min(6, floor(log2(args$n))), 
      trafo = function(x) 2^x),
    makeIntegerParam(id = "maxdepth", lower = 1, upper = 30)
  )
  return(par.set)  
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRandomForestSpace = function(...) {
  args = list(...)
  par.set = makeParamSet(
    makeIntegerParam(id = "mtry", lower = round(args$p ^ 0.1), upper = round(args$p ^ 0.9)),
    makeIntegerParam(id = "ntree", lower = 0, upper = 10, trafo = function(x) 2^x),
    makeIntegerParam(id = "nodesize", lower = 1, upper = 20)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getKknnSpace = function(...) {
  par.set = makeParamSet(
    makeIntegerParam(id = "k", lower = 1, upper = 50, default = 7)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getNaiveBayesSpace = function(...) {
  par.set =  makeParamSet()
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getLogregSpace = function(...) {
  par.set = makeParamSet()
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
