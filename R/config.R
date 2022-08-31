#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mlr::configureMlr(on.learner.error = "warn")
mlr::configureMlr(show.info = TRUE)

AVAILABLE.REGR = c("regr.svm", "regr.rpart", "regr.randomForest", "regr.kknn", "regr.lm",
  "regr.gausspr", "regr.xgboost")

AVAILABLE.CLASS = c("classif.svm", "classif.rpart", "classif.randomForest", "classif.kknn",
  "classif.logreg", "classif.gausspr", "classif.naiveBayes", "classif.xgboost", "classif.C50",
  "classif.J48", "classif.nnet")

AVAILABLE.RESAMPLING = c("LOO", "10-CV", "5-CV", "3-CV")

# feature selection options
RELIEF.CONFS = paste("relief", seq(from = 0.05, to = 1, by = 0.05), sep=".")
INFO.GAIN.CONFS = paste("information.gain", seq(from = 0.05, to = 1, by = 0.05), sep=".")
AVAILABLE.FEATSEL = c("none", "sfs", "sbs", "sffs", "sfbs", "ga", RELIEF.CONFS, INFO.GAIN.CONFS)
INNER.FOLDS.FEATSEL = 3

# Sequential feature selection methods
ALPHA = 0.001
BETA  = -0.01

# GA feature selection method
GA.MAXIT = 100
MU.SIZE  = 10L
LAMBDA.SIZE = 10L

# tuning options
AVAILABLE.TUNING = c("random", "none")
INNER.FOLDS.TUNING = 3
BUDGET.TUNING = 300

AVAILABLE.BALANCING = c("none", "smote", "oversamp", "undersamp")
SMOTE.RATE = 2
UNDER.RATE = 1/2
OVER.RATE  = 2

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
