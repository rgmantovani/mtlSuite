
# for data in "classif_best_all" "classif_rule_all" 

for data in "classif_svm_169d_90_average" "classif_svm_169d_95_average" "classif_svm_169d_99_average"
do
  # for algo in "classif.naiveBayes" "classif.svm" "classif.rpart" "classif.kknn" "classif.logreg" "classif.gausspr" "classif.randomForest" 
  for algo in "classif.svm" "classif.rpart" "classif.kknn" "classif.gausspr" "classif.randomForest" 
  do
    for norm in "TRUE" "FALSE"
    do
      for feat in "none" #"sfs" # "sbs" "sffs" "sfbs"
      do
        for resamp in "10-CV"
        do
          for tun in "random" # "none"
          do
            for rep in $(seq 1 10);
            do
              R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --algo="$algo" --norm="$norm" \
                --feat.sel="$feat" --resamp="$resamp" --tuning="$tun" -seed="$rep" mainMTL.R \
                out_"$data"_"$algo"_"$norm"_"$feat"_"$resamp"_"$tuning"_"$rep".log &
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
  done
done
