# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

devtools::load_all("../")

mySeed = 42
parsed.obj = NULL
parsed.obj$seed      = mySeed

set.seed(parsed.obj$seed)
options(mlr.debug.seed = parsed.obj$seed)

parsed.obj$datafile = "toy_iris"

parsed.obj$algo    = "classif.C50"

# AVAILABLE.REGR = c("regr.svm", "regr.rpart", "regr.randomForest", "regr.kknn", "regr.lm",
  # "regr.gausspr", "regr.xgboost")

parsed.obj$feat.sel  = "none"
parsed.obj$resamp    = "10-CV" #5-CV
parsed.obj$tuning    = "none"
parsed.obj$balancing = "none"
parsed.obj$models    = FALSE
parsed.obj$norm      = TRUE

# task.type = "regression"
task.type = "classification"

#--------------------------
# creating output dir
#--------------------------

output.dir = paste("../output", parsed.obj$datafile, parsed.obj$algo, sep="/")
output.dir = paste(output.dir, ifelse(parsed.obj$norm, "with_norm", "no_norm"), sep="/")
output.dir = paste(output.dir, parsed.obj$feat.sel, parsed.obj$resamp, parsed.obj$tuning,
  parsed.obj$balancing, parsed.obj$seed, sep="/")

if(!dir.exists(output.dir)) {
  dir.create(path = output.dir, recursive = TRUE)
  cat(paste0(" - Creating dir: ", output.dir, "\n"))
}

job.file = paste0(output.dir, "/ret_", parsed.obj$datafile, ".RData")
print(job.file)
if(file.exists(job.file)) {
  warningf("Job already finished!")
  return (NULL)
}

#--------------------------
# reading data
#--------------------------

# data = readData(datafile = parsed.obj$datafile, norm = parsed.obj$norm)

cat(paste0(" @ Loading dataset: ", parsed.obj$datafile, "\n"))
data = farff::readARFF(path=paste0("../data/", parsed.obj$datafile,".arff"))

# data normalization
if(parsed.obj$norm ) {
  # https://mlr.mlr-org.com/reference/normalizeFeatures.html
  class.id = grep(x=colnames(data), pattern="Class")
  data = mlr::normalizeFeatures(obj=data, target=colnames(data)[class.id],
       method = "standardize")
}

#--------------------------
# setting up experiment
#--------------------------

if(task.type == "regression") {

  if(parsed.obj$balancing != "none") {
    stop("There is no data balancing option available for regression tasks.\n")
  }

  tasks    = getRegrTask(data = data, id = parsed.obj$datafile)
  measures = list(rmse, mse, mae, rsq, spearmanrho, timetrain, timepredict)
  lrns     = getRegrLearner(task = tasks[[1]], algo = parsed.obj$algo,
    feat = parsed.obj$feat.sel, tuning = parsed.obj$tuning)

  if(parsed.obj$resamp == "LOO") {
    rdesc = mlr::makeResampleDesc(method = "LOO")
  } else if(parsed.obj$resamp == "10-CV") {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 10, stratify = FALSE)
  } else if(parsed.obj$resamp == "5-CV") {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 5, stratify = FALSE)
  } else {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 3, stratify = FALSE)
  }

} else {

  tasks    = getClassifTask(data = data, id = parsed.obj$datafile)
  measures = list(acc, ber, timetrain, timepredict)
  lrns     = getClassifLearner(task = tasks[[1]], algo = parsed.obj$algo,
    feat = parsed.obj$feat.sel, tuning = parsed.obj$tuning,
    balancing = parsed.obj$balancing)

  if(length(getTaskClassLevels(tasks[[1]])) == 2) {
    measures = append(list(auc, gmean, f1, mlr::kappa, tpr, tnr), measures)
  } else {
    measures = append(list(multiclass.aunp, mlr::kappa), measures)
  }

  if(parsed.obj$resamp == "LOO") {
    rdesc = mlr::makeResampleDesc(method = "LOO")
  } else if(parsed.obj$resamp == "10-CV") {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
  } else if(parsed.obj$resamp == "5-CV") {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 5, stratify = TRUE)
  } else {
    rdesc = mlr::makeResampleDesc(method = "CV", iters = 3, stratify = TRUE)
  }
}

#--------------------------
# Running and saving job
#--------------------------

res = mlr::benchmark(learners = lrns, tasks = tasks, resamplings = rdesc, measures = measures,
  show.info = TRUE, keep.pred = TRUE, models = parsed.obj$models)

print(res)

save(res, file = job.file)

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
