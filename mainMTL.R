# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

mainMTL = function(datafile, algo, feat.sel, norm, resamp, tuning, seed) {

  devtools::load_all()

  #------------------------------
  #  check parameters passed to mainMTL
  #------------------------------
  
  sub.data = gsub(x = list.files(path = "data/metabase/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = resamp, choices = AVAILABLE.RESAMPLING)
  assertChoice(x = feat.sel, choices = AVAILABLE.FEATSEL)
  assertChoice(x = tuning, choices = AVAILABLE.TUNING)
  assertInt(x = seed, lower = 1, upper = 30, .var.name = "seed")
  assertLogical(x = norm)
  
  if(grepl(pattern = "regr", x = algo)) {
    assertChoice(x = algo, choices = AVAILABLE.REGR, .var.name = "algo")
    task.type = "regression"
  } else if (grepl(pattern = "classif", x = algo)) {
    assertChoice(x = algo, choices = AVAILABLE.CLASS, .var.name = "algo")
    task.type = "classification"
  } else {
    stop("Invalid algo option\n")
  }

  cat(" ---------------------------- \n")
  cat(" **** Meta-learning **** \n")
  cat(" ---------------------------- \n")

  cat(paste0(" - Datafile: \t", datafile, "\n"))
  cat(paste0(" - Algo: \t", algo, "\n"))
  cat(paste0(" - Feat.Sel: \t", feat.sel, "\n"))
  cat(paste0(" - Norm: \t", norm, "\n"))
  cat(paste0(" - Resamp: \t", resamp, "\n"))
  cat(paste0(" - Tuning: \t", tuning, "\n"))
  cat(paste0(" - Seed: \t", seed, "\n"))
  cat(" ---------------------------- \n")

  runMetaLearning(datafile = datafile, algo = algo, feat.sel = feat.sel, 
    norm = norm, resamp = resamp, tuning = tuning, seed = seed, task.type = task.type)

  cat("\n - Finished!\n")
  cat(" ---------------------------- \n")
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

options(echo = TRUE) 
args = commandArgs(trailingOnly = TRUE)

parseArgs = function(x) strsplit(sub("^--", "", x), "=")
argsDF = as.data.frame(do.call("rbind", parseArgs(args)))
argsL = as.list(as.character(argsDF$V2))

# -------------------------------------------------------------------------------------------------
# Calling execution with the arguments
# -------------------------------------------------------------------------------------------------

mainMTL(
  datafile = argsL[[1]], 
  algo     = argsL[[2]],
  norm     = as.logical(argsL[[3]]),
  feat.sel = argsL[[4]],
  resamp   = argsL[[5]],
  tuning   = argsL[[6]],
  seed     = as.integer(argsL[[7]])
)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
