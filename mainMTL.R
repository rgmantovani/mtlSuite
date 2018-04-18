# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

mainMTL = function(parsed.obj) {

  devtools::load_all()
  parsed.obj$norm = as.logical(parsed.obj$norm)
  parsed.obj$seed = as.integer(parsed.obj$seed)

  if(is.null(parsed.obj$models)) {
    parsed.obj$models = FALSE
  } else {
    parsed.obj$models = TRUE
  }

  #-------------------------------------
  #  check parameters passed to mainMTL
  #-------------------------------------
  
  sub.data = gsub(x = list.files(path = "data/"), pattern = ".arff", replacement = "")
  checkmate::assertChoice(x = parsed.obj$datafile, choices = sub.data, .var.name = "datafile")
  checkmate::assertChoice(x = parsed.obj$resamp, choices = AVAILABLE.RESAMPLING)
  checkmate::assertChoice(x = parsed.obj$feat.sel, choices = AVAILABLE.FEATSEL)
  checkmate::assertChoice(x = parsed.obj$tuning, choices = AVAILABLE.TUNING)
  checkmate::assertChoice(x = parsed.obj$balancing, choices = AVAILABLE.BALANCING)
  checkmate::assertLogical(x = parsed.obj$norm)
  checkmate::assertInt(x = parsed.obj$seed, lower = 1, upper = 30, .var.name = "seed")
  
  #-------------------------------------
  #  check possible combinations
  #-------------------------------------
  
  if(grepl(pattern = "regr", x = parsed.obj$algo)) {
    assertChoice(x = parsed.obj$algo, choices = AVAILABLE.REGR, .var.name = "algo")
    task.type = "regression"
  } else if (grepl(pattern = "classif", x = parsed.obj$algo)) {
    assertChoice(x = parsed.obj$algo, choices = AVAILABLE.CLASS, .var.name = "algo")
    task.type = "classification"
  } else {
    stop("Invalid algo option\n")
  }

  if(task.type == "regression" & parsed.obj$balancing != "none") {
    stop("Balancing is not available for regression tasks \n")
  }

  #-------------------------------------
  #  main execution
  #-------------------------------------
  
  cat(" ---------------------------- \n")
  cat(" **** Meta-learning **** \n")
  cat(" ---------------------------- \n")

  cat(paste0(" - Datafile: \t", parsed.obj$datafile, "\n"))
  cat(paste0(" - Algo: \t", parsed.obj$algo, "\n"))
  cat(paste0(" - Feat.Sel: \t", parsed.obj$feat.sel, "\n"))
  cat(paste0(" - Norm: \t", parsed.obj$norm, "\n"))
  cat(paste0(" - Resamp: \t", parsed.obj$resamp, "\n"))
  cat(paste0(" - Tuning: \t", parsed.obj$tuning, "\n"))
  cat(paste0(" - Balancing: \t", parsed.obj$balancing, "\n"))
  cat(paste0(" - Seed: \t", parsed.obj$seed, "\n"))

  if(parsed.obj$models) {
    cat(paste0(" - Exporting models\n"))
  }
  cat(" ---------------------------- \n")

  runMetaLearning(parsed.obj = parsed.obj, task.type = task.type)

  cat("\n - Finished!\n")
  cat(" ---------------------------- \n")
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

options(echo = TRUE) 
args = commandArgs(trailingOnly = TRUE)

option_list = list(
  optparse::make_option(c("--datafile"), type="character", action="store", 
    help="dataset's filename"),
  optparse::make_option(c("--algo"), type="character", action="store", 
    help="ML algorithm"),
  optparse::make_option(c("--norm"), type="logical", action="store", 
    help="perform data normalization"),
  optparse::make_option(c("--feat.sel"), type="character", action="store", 
    help="perform feature selection"),
  optparse::make_option(c("--resamp"), type="character", action="store", 
    help="resampling strategy"),
  optparse::make_option(c("--tuning"), type="character", action="store", 
    help="tuning technique"),
  optparse::make_option(c("--balancing"), type="character", action="store", 
    help="data balancing technique"),
  optparse::make_option(c("--seed"), type="integer", action="store", 
    help="seed for reproducibility"),
  optparse::make_option(c("--models"), action="store_true", 
    help="should it export models?")
)

parsed.obj = optparse::parse_args(optparse::OptionParser(option_list=option_list), args = args)
print(parsed.obj)

mainMTL(parsed.obj = parsed.obj)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
