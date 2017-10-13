#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
#  Feature selection :   sfs - Sequential Forward Selection
#  Hyperprameter tuning: rs  - Random Search 

# TODO: make feature selection and tuning work together trough mlr package

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, task=NULL, norm=FALSE, feat.sel="none", tuning="none") {

  if(feat.sel != "none" & tuning != "none") {
    stop(" @ mlr package cannot handle tuning and feature selection wrapped to the same learner")
  }

  lrn = makeLearner(algo)

  #  FIXME: do we control ou nor data scaling ?
  # if(algo %in% c("regr.svm", "regr.kknn")) {
  #   lrn = setHyperPars(learner = lrn, par.vals = list(scale = norm)) 
  # }

  if(feat.sel != "none") {
   
    feat.ctrl = makeFeatSelControlSequential(method = feat.sel, alpha = ALPHA, beta = BETA)
    inner     = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = FALSE)
   
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(rmse), show.info = FALSE)
  }

  if(tuning != "none") {
    
    tn.par.set = getHyperSpace(learner = algo, p = getTaskNFeats(task), n = getTaskSize(task))
    tn.ctrl    = makeTuneControlRandom(maxit = BUDGET.TUNING)
    tn.inner   = makeResampleDesc(method = "CV", iters = INNER.FOLDS.TUNING, stratify = FALSE)
    
    lrn = makeTuneWrapper(learner = lrn, resampling = tn.inner, control = tn.ctrl, 
      measures = list(rmse), par.set = tn.par.set, show.info = FALSE)
  }

  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getClassifLearner = function(algo, task=NULL, norm=FALSE, feat.sel="none", tuning="none") {

  if(feat.sel != "none" & tuning != "none") {
    stop(" @ mlr package cannot handle tuning and feature selection wrapped to the same learner")
  }

  lrn = makeLearner(algo, predict.type = "prob")
 
  if(length(getTaskClassLevels(task)) == 2) {
    measures = list(auc)
    cat(" @ Inner perforamnce measure: AUC\n")
  } else {
    measures = list(ber)
    cat(" @ Inner perforamnce measure: BER \n")
  }

  #  FIXME: do we control ou nor data scaling ?
  # if(algo %in% c("classif.svm", "classif.kknn")) {
    # lrn = setHyperPars(learner = lrn, par.vals = list(scale = norm)) 
  # }

  # if(algo == "classif.gausspr") {
    # lrn = setHyperPars(learner = lrn, par.vals = list(scaled = norm)) 
  # }

  if(feat.sel != "none") {
    
    feat.ctrl  = makeFeatSelControlSequential(method = feat.sel, alpha = ALPHA, beta = BETA)
    feat.inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = TRUE)
    
    lrn = makeFeatSelWrapper(learner = lrn, resampling = feat.inner, control = feat.ctrl,
      measures = measures, show.info = TRUE)
  }

  if(tuning != "none") {
    
    tn.par.set = getHyperSpace(learner = algo, p = getTaskNFeats(task), n = getTaskSize(task))
    tn.ctrl    = makeTuneControlRandom(maxit = BUDGET.TUNING)
    tn.inner   = makeResampleDesc(method = "CV", iters = INNER.FOLDS.TUNING, stratify = TRUE)
    
    lrn = makeTuneWrapper(learner = lrn, resampling = tn.inner, control = tn.ctrl, 
      measures = measures, par.set = tn.par.set, show.info = TRUE)
  }

  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
