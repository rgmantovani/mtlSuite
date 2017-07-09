# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

runMetaLearning = function(datafile, normalization, seed) {

  set.seed(seed)

  if(normalization) {
    output.dir = paste("output", datafile, "with_norm", seed, sep = "/")
  } else {
    output.dir = paste("output", datafile, "no_norm", seed, sep = "/")
  }

  if(!dir.exists(output.dir)) {
    dir.create(path = output.dir, recursive = TRUE)
    cat(paste0(" - Creating dir: ", output.dir, "\n"))
  }

  # chech if job is finished
  job.file = paste0(output.dir, "/ret_", datafile, ".RData")
  if(file.exists(job.file)) {
    warningf("Job already finished!")
    return (NULL)
  }

  tasks     = getRegrSubTasks(datafile = datafile)
  measures  = list(rmse,timetrain, timepredict)
  lrns      = getRegrLearners()
  loo.cv    = makeResampleDesc(method="LOO")

  parallelMap::parallelStartSocket(parallel::detectCores() - 1)
  res = benchmark(learners = lrns, tasks = tasks, resamplings = loo.cv,
    measures = measures, show.info = TRUE, keep.pred = TRUE, models = FALSE)
  parallelMap::parallelStop()

  print(res)
  save(res, file = job.file)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
