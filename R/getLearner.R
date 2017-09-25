#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
#  Feature selection : sfs - Sequential Forward Selection
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, feat.sel = feat.sel) {

  lrn = makeLearner(algo)

  if(feat.sel != "none") {
    feat.ctrl = makeFeatSelControlSequential(method = feat.sel, alpha = 0.01, beta = -0.01)
    inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEAT, stratify = TRUE)
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(rmse), show.info = FALSE)
  }
  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getClassifLearner = function(algo, feat.sel = "none") {

  lrn = makeLearner(algo, predict.type = "prob")

  if(feat.sel != "none") {
    feat.ctrl = makeFeatSelControlSequential(method = feat.sel, alpha = 0.01, beta = -0.01)
    inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEAT, stratify = TRUE)
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(auc), show.info = TRUE)
  }
  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
