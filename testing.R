# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

  devtools::load_all()

  # datafile = "classif_rule_all"
  datafile = "classif_svm_169d_90_all"

  # algo = "classif.rpart"
  algo = "classif.JRip"
  
  seed = 1
  feat.sel = TRUE #FALSE
  norm = FALSE
  resamp = "CV"

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
    lrns     = getClassifLearner(algo = algo, feat = feat.sel) 
  }

  if(resamp == "LOO") {
    rdesc = makeResampleDesc(method = "LOO")
    measures = append(list(auc), measures)
  } else {
    rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
  }

  res = benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
