#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

mlr::configureMlr(on.learner.error = "warn")
mlr::configureMlr(show.info = TRUE)

AVAILABLE.REGR = c("regr.svm", "regr.rpart", "regr.randomForest", "regr.kknn", "regr.lm", 
  "regr.gausspr")

AVAILABLE.CLASS = c("classif.svm", "classif.rpart", "classif.randomForest", "classif.kknn", 
  "classif.logreg", "classif.gausspr", "classif.JRip", "classif.naiveBayes")

AVAILABLE.RESAM = c("LOO", "10-CV")

AVAILABLE.FEATSEL = c("none", "sfs", "sbs", "sffs", "sfbs")

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------