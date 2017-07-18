# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

defineLabel = function(result, avg) {

  avg.ordered = avg[order(avg, decreasing = TRUE)]

  best   = names(avg.ordered)[1]
  second = names(avg.ordered)[2] 

  label  = NULL

  # if the best option is a default, label is default
  if(grepl(pattern="defaults", x = best)) {
    label = best
  # if default is the second, check if there is significance (if no, default is returned)
  } else if(grepl(pattern="defaults", x = second)) {
    sign = wilcoxonTest(x1 = avg[best], x2 = avg[second])
    label = ifelse(sign, best, second)
  } else {
    label = best
  }

  return(label)
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
