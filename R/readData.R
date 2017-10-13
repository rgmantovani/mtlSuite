# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

readData = function(datafile, norm = FALSE) {

  cat(paste0(" @ Loading dataset: ", datafile, "\n"))
  data = foreign::read.arff(paste0("data/", datafile, ".arff"))

  # data norm (mean zero, variance one)
  if(norm) {
    for(i in colnames(data)[2:(ncol(data)-4)]) {
      data[,i] = RSNNS::normalizeData(data[,i], type="norm")
    }
  }

  return(data)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
