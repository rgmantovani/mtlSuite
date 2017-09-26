#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
#  Feature selection :   sfs - Sequential Forward Selection
#  Hyperprameter tuning: rs  - Random Search 
#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, task=NULL, feat.sel="none", tuning=FALSE) {

  lrn = makeLearner(algo)

  if(feat.sel != "none") {
    feat.ctrl = makeFeatSelControlSequential(method = feat.sel, alpha = 0.01, beta = -0.01)
    inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = TRUE)
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(rmse), show.info = FALSE)
  }

  # TODO: add tuning for regressors

  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getClassifLearner = function(algo, task=NULL, feat.sel="none", tuning="none") {

  lrn = makeLearner(algo, predict.type = "prob")

  if(feat.sel != "none") {
    feat.ctrl  = makeFeatSelControlSequential(method = feat.sel, alpha = 0.01, beta = -0.01)
    feat.inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = TRUE)
    lrn = makeFeatSelWrapper(learner = lrn, resampling = feat.inner, control = feat.ctrl,
      measures = list(auc), show.info = TRUE)
  }

  if(tuning != "none") {
    tn.par.set = getHyperSpace(learner = algo, p = getTaskNFeats(task), n = getTaskSize(task))

    tn.ctrl  = makeTuneControlRandom(maxit = BUDGET.TUNING)
    tn.inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.TUNING, stratify = TRUE)
    lrn = makeTuneWrapper(learner = lrn, resampling = tn.inner, control = tn.ctrl, 
      measures = list(auc), par.set = tn.par.set, show.info = TRUE)
  }

  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
