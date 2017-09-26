# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

  devtools::load_all()

  #------------------------------
  #------------------------------
  
  # datafile = "classif_rule_all"
  datafile = "classif_svm_169d_90_average"

  # algo = "classif.rpart"
  # algo = "classif.naiveBayes"
  # algo = "classif.randomForest"
  # algo = "classif.kknn"
  # algo = "classif.gausspr"
  # algo = "classif.logreg"
  algo = "classif.svm"
  
  seed = 1
  feat.sel = "none"
  # feat.sel = "sfs"
  # feat.sel = "sbs"
  # feat.sel = "sffs"
  # feat.sel = "sbbs"
  
  norm = FALSE
  resamp = "10-CV"
  # tuning = FALSE  
  tuning = "random"

  #------------------------------
  #------------------------------
  
  sub.data = gsub(x = list.files(path = "data/metabase/"), pattern = ".arff", replacement = "")
  assertChoice(x = datafile, choices = sub.data, .var.name = "datafile")
  assertChoice(x = resamp, choices = AVAILABLE.RESAMPLING)
  assertChoice(x = feat.sel, choices = AVAILABLE.FEATSEL)
  assertLogical(x = norm)
  assertInt(x = seed, lower = 1, upper = 30, .var.name = "seed")

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

  output.dir = paste("output", datafile, algo, sep="/")
  output.dir = paste(output.dir, ifelse(norm, "with_norm", "no_norm"), sep="/")
  output.dir = paste(output.dir, feat.sel, resamp, seed, sep="/")
  
  job.file = paste0(output.dir, "/ret_", datafile, ".RData")
  
  cat(paste0(" - Job file: \t", job.file, "\n"))

  #------------------------------
  #------------------------------
  
  if(grepl(pattern = "regr", x = algo)) {
    assertChoice(x = algo, choices = AVAILABLE.REGR, .var.name = "algo")
    task.type = "regression"
  } else if (grepl(pattern = "classif", x = algo)) {
    assertChoice(x = algo, choices = AVAILABLE.CLASS, .var.name = "algo")
    task.type = "classification"
  } else {
    stop("Invalid algo option\n")
  }

  if(task.type == "regression") {
    tasks    = getRegrSubTasks(datafile = datafile, norm = norm)
    measures = list(rmse, timetrain, timepredict)
    lrns     = getRegrLearner(algo = algo, feat.sel = feat.sel)
  } else {
    tasks    = getClassifTask(datafile = datafile, norm = norm)
    measures = list(acc, ber, timetrain, timepredict)
    lrns     = getClassifLearner(task = tasks, algo = algo, feat = feat.sel, tuning = tuning) 
  }

  if(resamp == "LOO") {
    rdesc = makeResampleDesc(method = "LOO")
  } else {
    rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
    measures = append(list(auc), measures)
  }

  res = benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
