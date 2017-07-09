# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

runMetaLearning = function(datafile, algo) {

  output.dir = paste("output", datafile, algo, sep = "/")
  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  #chech if job is finish
  job.file = paste0(output.dir, "/ret_", datafile, ".RData")
  if(file.exists(job.file)) {
    warningf("Job already finished!")
    return (NULL)
  }

  tasks = getRegrSubTasks(datafile = datafile)

  measures = list(rmse,timetrain, timepredict)

  lrn = makeLearner("regr.randomForest")

  loo.cv = makeResampleDesc(method="LOO")

  parallelMap::parallelStartSocket(parallel::detectCores() - 1)
  res = benchmark(learners = lrn, tasks = tasks, resamplings = loo.cv,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)
  parallelMap::parallelStop()

  print(res)
  save(res, file = job.file)

}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
