#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export multiclass.f1
#' @rdname measures
#' @format none
multiclass.f1 = makeMeasure(id = "multiclass.f1", minimize = FALSE, best = 1, worst = 0,
  properties = c("classif", "classif.multi", "req.pred", "req.truth"),
  name = "Multiclass F-measure",
  fun = function(task, model, pred, feats, extra.args) {
    measureMulticlassF1(pred$data$truth, pred$data$response)
  }
)

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

#' @export measureMulticlassF1
#' @rdname measures
#' @format none
measureMulticlassF1 = function(truth, response) {

  aux = lapply(levels(truth), function(lv){
    res.aux = as.character(response)
    tru.aux = as.character(truth)
    tru.aux[which(tru.aux != lv)] = "other"
    res.aux[which(res.aux != lv)] = "other"
    value = mlr:::measureF1(truth = tru.aux, response = res.aux, positive = lv)
    return(value)
  })
  return(mean(unlist(aux)))
}

#--------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------
