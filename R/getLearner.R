#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
#  Feature selection : sfs - Sequential Forward Selection

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, feat.sel = FALSE) {

  lrn = makeLearner(algo)

  if(feat.sel) {
    feat.ctrl = makeFeatSelControlSequential(method = "sfs", alpha = 0.01)
    inner = makeResampleDesc("Holdout")
    
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(rmse), show.info = FALSE)
  }
  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getClassifLearner = function(algo, feat.sel = FALSE) {

  lrn = makeLearner(algo, predict.type = "prob")

  if(feat.sel) {
    feat.ctrl = makeFeatSelControlSequential(method = "sfs", alpha = 0.01)
    inner = makeResampleDesc("Holdout")
    
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(acc), show.info = FALSE)
  }
  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
