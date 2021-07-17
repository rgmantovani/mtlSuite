# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

readData = function(datafile, norm=FALSE) {

  cat(paste0(" @ Loading dataset: ", datafile, "\n"))
  data = farff::readARFF(path=paste0("data/", datafile,".arff"))

  # data normalization
  if(norm) {
    # https://mlr.mlr-org.com/reference/normalizeFeatures.html
    class.id = grep(x=colnames(data), pattern="Class")
    ret = mlr::normalizeFeatures(obj=data, target=colnames(data)[class.id],
         method = "standardize")
  } else {
    ret = data
  }

  return(ret)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
