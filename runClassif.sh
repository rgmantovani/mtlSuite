
# for data in "classif_best_all" "classif_rule_all" 
for data in "classif_svm_169d_90_all" "classif_svm_169d_95_all" "classif_svm_169d_95_all"
do
  for algo in "classif.svm" "classif.rpart" "classif.randomForest" "classif.kknn" "classif.logreg" "classif.gausspr"
  do
    for norm in "TRUE" "FALSE"
    do
      for feat in "none" "sfs" # "sbs" "sffs" "sfbs"
      do
        for rep in $(seq 1 10);
        do
          R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --algo="$algo" --norm="$norm" --feat.sel="$feat" -seed="$rep" \
            mainMTL.R out_"$data"_"$algo"_"$norm"_"$feat"_"$rep".log &
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
