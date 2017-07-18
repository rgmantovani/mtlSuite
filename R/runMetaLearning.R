# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

runMetaLearning = function(datafile, algo, feat.sel, norm, seed, task.type) {

  # Seed for reproducibility
  set.seed(seed)
  options(mlr.debug.seed = seed)

  # output directory with results
  output.dir = paste("output", datafile, algo, sep="/")
  output.dir = paste(output.dir, ifelse(feat.sel, "with_feat", "no_feat"), sep="/")
  output.dir = paste(output.dir, ifelse(norm, "with_norm", "no_norm"), sep="/")
  output.dir = paste(output.dir, seed, sep="/")
  
  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  job.file = paste0(output.dir, "/ret_", datafile, ".RData")
  if(file.exists(job.file)) {
    warningf("Job already finished!")
    return (NULL)
  }

  if(task.type == "regression") {
    tasks     = getRegrSubTasks(datafile = datafile, norm = norm)
    measures  = list(rmse, timetrain, timepredict)
    lrns      = getRegrLearner(algo = algo, feat.sel = feat.sel)
  } else {
    tasks     = getClassifTask(datafile = datafile, norm = norm)
    measures  = list(ber, multiclass.au1p, multiclass.au1u, multiclass.aunp, 
      multiclass.aunu, timetrain, timepredict)
    lrns      = getClassifLearner(algo = algo, feat = feat.sel) 
  }

  loo.cv    = makeResampleDesc(method = "LOO")

  # parallelMap::parallelStartMulticore(parallel::detectCores()-1)
  res = benchmark(learners = lrns, tasks = tasks, resamplings = loo.cv,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = TRUE)
  # parallelMap::parallelStop()

  print(res)
  save(res, file = job.file)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
