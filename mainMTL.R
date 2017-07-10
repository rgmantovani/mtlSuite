# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

mainMTL = function(datafile, algo, feat.sel, norm, seed) {

  devtools::load_all()

  sub.data = gsub(x = list.files(path = "data/metabase/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = algo, choices = AVAILABLE.REGR, .var.name = "algo")
  assertLogical(x = norm)
  assertLogical(x = feat.sel)
  assertInt(x = seed, lower = 1, upper = 30, .var.name = "seed")

  cat(" ---------------------------- \n")
  cat(" **** Meta-learning **** \n")
  cat(" ---------------------------- \n")

  cat(paste0(" - Datafile: \t", datafile, "\n"))
  cat(paste0(" - Algo: \t", algo, "\n"))
  cat(paste0(" - Feat.Sel: \t", feat.sel, "\n"))
  cat(paste0(" - Norm: \t", norm, "\n"))
  cat(paste0(" - Seed: \t", seed, "\n"))
  cat(" ---------------------------- \n")

  runMetaLearning(datafile = datafile, algo = algo, feat.sel = feat.sel, 
    norm = norm, seed = seed)

  cat("\n - Finished!\n")
  cat(" ---------------------------- \n")
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# # parse params and call main
options(echo = TRUE) 
args = commandArgs(trailingOnly = TRUE)

# Parse arguments (we expect the form --arg=value)
parseArgs = function(x) strsplit(sub("^--", "", x), "=")
argsDF = as.data.frame(do.call("rbind", parseArgs(args)))
argsL = as.list(as.character(argsDF$V2))

# Calling execution with the arguments
mainMTL(
  datafile = argsL[[1]], 
  algo     = argsL[[2]],
  feat.sel = as.logical(argsL[[3]]),
  norm     = as.logical(argsL[[4]]),
  seed     = as.integer(argsL[[5]])
)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
