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

getXgboostSpace = function(...) {
  par.set = makeParamSet(
    makeIntegerParam("nrounds", lower = 0, upper = 10, trafo = function(x) 2^x),
    makeNumericParam("eta", lower = -7, upper = -5, trafo = function(x) 2^x),
    makeIntegerParam("max_depth", lower = 1, upper = 30),
    makeNumericParam("subsample", lower = 1, upper = 10, trafo = function(x) 0.1*x)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRandomForestSpace = function(...) {
  args = list(...)
  par.set = makeParamSet(
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

getC50Space = function(...) {

  par.set = makeParamSet(
    makeIntegerParam(id = "trials", lower = 0, upper = 2, trafo = function(x) 10^x),
    makeNumericParam(id = "CF", lower = 0.001, upper = 0.49, default = 0.25)
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

getJ48Space = function(...) {
  par.set = makeParamSet(
    makeLogicalParam(id = "R", default = FALSE),
    makeNumericParam(id = "C", default = 0.25, lower = 0.001, upper = 0.5,
      requires = quote(R == FALSE)),
    makeIntegerParam(id = "M", default = 2L, lower = 1L, upper = 50L),
    makeIntegerParam(id = "N", default = 3L, lower = 2L, upper = 10,
      requires = quote(R == TRUE))
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getNnetSpace = function(...) {
  par.set = makeParamSet(
     makeIntegerParam(id = "size", default = 3L, lower = 0L),
     makeIntegerParam(id = "maxit", default = 100L, lower = 1L),
     makeNumericParam(id = "rang", default = 0.7),
     makeLogicalParam(id = "Hess", default = FALSE)
  )
  return(par.set)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
