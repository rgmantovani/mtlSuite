# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRegrSubTasks = function(datafile, norm = FALSE) {

  cat(paste0(" @ Loading dataset: ", datafile, "\n"))
  data = foreign::read.arff(paste0("data/metabase/", datafile, ".arff"))

  # data norm (mean zero, variance one)
  if(norm) {
    for(i in colnames(data)[2:(ncol(data)-4)]) {
      data[,i] = RSNNS::normalizeData(data[,i], type="norm")
    }
  }

  sub.data.1 = data[,c(2:(ncol(data)-4), (ncol(data)-3))]
  colnames(sub.data.1)[ncol(sub.data.1)] = "Target"

  sub.data.2 = data[,c(2:(ncol(data)-4), (ncol(data)-2))]
  colnames(sub.data.2)[ncol(sub.data.2)] = "Target"
  
  sub.data.3 = data[,c(2:(ncol(data)-4), (ncol(data)-1))]
  colnames(sub.data.3)[ncol(sub.data.3)] = "Target"
  
  sub.data.4 = data[,c(2:(ncol(data)-4), (ncol(data)))]
  colnames(sub.data.4)[ncol(sub.data.4)] = "Target"
  
  cat(paste0(" @ Creating subtasks \n"))
  task1 = makeRegrTask(id = paste0(datafile,"_cart_df"),   data = sub.data.1, target = "Target")
  task2 = makeRegrTask(id = paste0(datafile,"_cart_irace"),data = sub.data.2, target = "Target")
  task3 = makeRegrTask(id = paste0(datafile,"_J48_df"),    data = sub.data.3, target = "Target")
  task4 = makeRegrTask(id = paste0(datafile,"_J48_irace"), data = sub.data.4, target = "Target")

  regr.tasks = list(task1, task2, task3, task4)
  return(regr.tasks)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getClassifTask = function(datafile, norm = FALSE) {

  cat(paste0(" @ Loading dataset: ", datafile, "\n"))
  data = foreign::read.arff(paste0("data/metabase/", datafile, ".arff"))

  # data norm (mean zero, variance one)
  if(norm) {
    for(i in colnames(data)[2:(ncol(data)-1)]) {
      data[,i] = RSNNS::normalizeData(data[,i], type="norm")
    }
  }

  task = makeClassifTask(id = datafile, data = data[,-1], target = "Class")
  return(task)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
