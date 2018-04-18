# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

.multiTasks = function(data, id, n, type) {

  checkmate::assertChoice(x = type, choices = c("regr", "classif"))

  aux = lapply(1:n, function(i) {

    sub.data = data[,c(2:(ncol(data)-n), (ncol(data)-(n-i)))]
    colnames(sub.data)[ncol(sub.data)] = "Class"

    task.id = paste0(id,"_", colnames(data)[ncol(data)-(n-i)])

    if(type == "regr") {
      task = mlr::makeRegrTask(id = task.id, data = sub.data, target = "Class")
    } else {
      task = mlr::makeClassifTask(id = task.id, data = sub.data, target = "Class")
    }
  })

  tasks = aux
  return(tasks)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getRegrTask = function(data, id) {

  n = length(which(grepl(colnames(data), pattern = "Class")))

  if(n == 1) {
    cat(" @ Unique Class attribute found - Single regression task\n")
    task = mlr::makeRegrTask(id = id, data = data[,-1], target = "Class")
    tasks = list(task)
  } else {
    cat(" @ Several \"Class\" attributes found - Multi-target regression tasks\n")
    tasks = .multiTasks(data = data, id = id, n = n, type = "regr")
  }

  return(tasks)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

getClassifTask = function(data, id) {

  n = length(which(grepl(colnames(data), pattern = "Class")))

  if(n == 1) {
    cat(" @ Unique Class attribute found - Single classification task\n")
    task = mlr::makeClassifTask(id = id, data = data[,-1], target = "Class")
    tasks = list(task)
  } else {
    cat(" @ Several \"Class\" attributes found - Multi-target classification tasks\n")
    tasks = .multiTasks(data = data, id = id, n = n, type = "classif")
  }

  return(tasks)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
