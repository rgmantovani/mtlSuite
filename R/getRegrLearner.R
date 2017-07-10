#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

getRegrLearner = function(algo, feat.sel = FALSE) {

  lrn = makeLearner(algo)

  if(feat.sel) {

    # Sequential Forward Selection
    feat.ctrl = makeFeatSelControlSequential(method = "sfs", alpha = 0.01)
    inner = makeResampleDesc("Holdout")
    
    lrn = makeFeatSelWrapper(learner = lrn, resampling = inner, control = feat.ctrl,
      measures = list(rmse), show.info = FALSE)
  
  }

  return(lrn)
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
