
for data in "regr_all" 
do
  for algo in "regr.svm" "regr.rpart" "regr.randomForest" "regr.kknn" "regr.lm" "regr.gausspr"
  do
    for norm in "TRUE" "FALSE"
    do
      for feat in "TRUE" "FALSE"
      do
        for rep in $(seq 1 10);
        do
          R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --algo="$algo" --norm="$norm" --feat.sel="$feat" -seed="$rep" \
            mainMTL.R out_"$data"_"$algo"_"$norm"_"feat.sel"_"$rep".log &
          PIDS[$rep]=$!
        done
        for k in $(seq 1 10);
        do
          wait ${PIDS[$k]}
        done;
      done
    done
  done
done
