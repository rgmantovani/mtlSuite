#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
#  Feature selection :   sfs - Sequential Forward Selection
#  Hyperprameter tuning: rs  - Random Search 

# TODO: make feature selection search methods and tuning work together trough mlr package
#  Current mlr package version does not allow it

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

isFilterFeatSel = function(feat.sel) {
  bool = (feat.sel %in% c(RELIEF.CONFS, INFO.GAIN.CONFS))
  return(bool)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, task=NULL, norm=FALSE, feat.sel="none", tuning="none") {

  if(feat.sel != "none" & tuning != "none") {
    stop(" @ mlr package cannot handle tuning and feature selection wrapped to the same learner")
  }

  lrn = makeLearner(algo)

  if(feat.sel != "none") {

    if(isFilterFeatSel(feat.sel = feat.sel)) {

      perc = tail(strsplit(x = feat.sel, split = "\\.")[[1]], n = 1)
      FILTER.PERC = as.numeric(paste("0", perc, sep="."))

      if(grepl("relief", feat.sel)) {
        FILTER = "relief"
      } else {
        FILTER = "information.gain"
      }

      lrn = makeFilterWrapper(learner = lrn, fw.method = FILTER, fw.perc = FILTER.PERC)

    } else {

   
      if(feat.sel == "ga") {
        feat.ctrl = makeFeatSelControlGA(mu = MU.SIZE, lambda = LAMBDA.SIZE, crossover.rate = 0.5, 
          mutation.rate = 0.05, maxit = GA.MAXIT)
      } else {
        feat.ctrl  = makeFeatSelControlSequential(method = feat.sel, alpha = ALPHA, beta = BETA)
      }

      inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = FALSE)
      lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
        measures = list(rmse), show.info = TRUE)
    }
  }

  if(tuning != "none") {
    
    tn.par.set = getHyperSpace(learner = algo, p = getTaskNFeats(task), n = getTaskSize(task))
    tn.ctrl    = makeTuneControlRandom(maxit = BUDGET.TUNING)
    tn.inner   = makeResampleDesc(method = "CV", iters = INNER.FOLDS.TUNING, stratify = FALSE)
    
    lrn = makeTuneWrapper(learner = lrn, resampling = tn.inner, control = tn.ctrl, 
      measures = list(rmse), par.set = tn.par.set, show.info = TRUE)
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
    measures = list(multiclass.aunp)
    cat(" @ Inner perforamnce measure: multiclass AUC \n")
  }

  if(feat.sel != "none") {

    if(isFilterFeatSel(feat.sel = feat.sel)) {

      cat(" @ Feature Selection Filter method \n")

      perc = tail(strsplit(x = feat.sel, split = "\\.")[[1]], n = 1)
      FILTER.PERC = as.numeric(paste("0", perc, sep="."))

      if(grepl("relief", feat.sel)) {
        FILTER = "relief"
      } else {
        FILTER = "information.gain"
      }

      lrn = makeFilterWrapper(learner = lrn, fw.method = FILTER, fw.perc = FILTER.PERC)

    } else {

      cat(" @ Feature Selection Search method \n")
      if(feat.sel == "ga") {
        feat.ctrl = makeFeatSelControlGA(mu = MU.SIZE, lambda = LAMBDA.SIZE, crossover.rate = 0.5, 
          mutation.rate = 0.05, maxit = GA.MAXIT)
      } else {
        feat.ctrl  = makeFeatSelControlSequential(method = feat.sel, alpha = ALPHA, beta = BETA)
      }

      feat.inner = makeResampleDesc(method = "CV", iters = INNER.FOLDS.FEATSEL, stratify = TRUE)
      lrn = makeFeatSelWrapper(learner = lrn, resampling = feat.inner, control = feat.ctrl,
        measures = measures, show.info = TRUE)
    }
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
