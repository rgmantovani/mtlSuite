# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

runMetaLearning = function(datafile, algo, feat.sel, norm, resamp, tuning, 
  balancing, seed, task.type) {

  set.seed(seed)
  options(mlr.debug.seed = seed)

  #--------------------------
  # creating output dir
  #--------------------------

  output.dir = paste("output", datafile, algo, sep="/")
  output.dir = paste(output.dir, ifelse(norm, "with_norm", "no_norm"), sep="/")
  output.dir = paste(output.dir, feat.sel, resamp, tuning, balancing, seed, sep="/")
  
  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  job.file = paste0(output.dir, "/ret_", datafile, ".RData")
  print(job.file)
  if(file.exists(job.file)) {
    warningf("Job already finished!")
    return (NULL)
  }

  #--------------------------
  # reading data
  #--------------------------

  data = readData(datafile = datafile, norm = norm)

  #--------------------------
  # setting up experiment
  #--------------------------

  if(task.type == "regression") {
    
    tasks    = getRegrTask(data = data, id = datafile)
    measures = list(rmse, timetrain, timepredict)
    lrns     = getRegrLearner(task = tasks[[1]], algo = algo, feat = feat.sel, tuning = tuning)

    if(resamp == "LOO") {
      rdesc = makeResampleDesc(method = "LOO")
    } else {
      rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = FALSE)
    }

  } else {
  
    tasks    = getClassifTask(data = data, id = datafile)
    measures = list(acc, ber, timetrain, timepredict)
    lrns     = getClassifLearner(task = tasks[[1]], algo = algo, feat = feat.sel, 
      tuning = tuning, balancing = balancing)

    if(length(getTaskClassLevels(tasks[[1]])) == 2) {
      measures = append(list(auc, gmean, f1, mlr::kappa), measures)
    } else {
      measures = append(list(multiclass.aunp, mlr::kappa), measures)
    }

    if(resamp == "LOO") {
      rdesc = makeResampleDesc(method = "LOO")
    } else {
      rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
    }
  }
  
  #--------------------------
  # Running and saving job
  #--------------------------
  
  res = benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
    measures = measures, show.info = TRUE, keep.pred = TRUE, 
    models = TRUE)
    # models = FALSE) # uncomment to avoid export models
  
  print(res)
  save(res, file = job.file)

}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
