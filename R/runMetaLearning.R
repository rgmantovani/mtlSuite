# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

runMetaLearning = function(datafile, algo, feat.sel, norm, resamp, seed, task.type) {

  set.seed(seed)
  options(mlr.debug.seed = seed)

  output.dir = paste("output", datafile, algo, sep="/")
  output.dir = paste(output.dir, ifelse(norm, "with_norm", "no_norm"), sep="/")
  output.dir = paste(output.dir, feat.sel, resamp, seed, sep="/")
  
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
  } else {
    measures = append(list(auc), measures)
    rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
  }
  
  parallelMap::parallelStartMulticore(parallel::detectCores()-1, level = "mlr.resample")
  res = benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = TRUE)
  parallelMap::parallelStop()

  print(res)
  save(res, file = job.file)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
