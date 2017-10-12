#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mlr::configureMlr(on.learner.error = "warn")
mlr::configureMlr(show.info = TRUE)

AVAILABLE.REGR = c("regr.svm", "regr.rpart", "regr.randomForest", "regr.kknn", "regr.lm", 
  "regr.gausspr")

AVAILABLE.CLASS = c("classif.svm", "classif.rpart", "classif.randomForest", "classif.kknn", 
  "classif.logreg", "classif.gausspr", "classif.naiveBayes")

AVAILABLE.RESAMPLING = c("LOO", "10-CV")

AVAILABLE.FEATSEL = c("none", "sfs", "sbs", "sffs", "sfbs")
INNER.FOLDS.FEATSEL = 3
ALPHA = 0.001
BETA  = -0.01

AVAILABLE.TUNING = c("random", "none")
INNER.FOLDS.TUNING = 3
BUDGET.TUNING = 300

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------