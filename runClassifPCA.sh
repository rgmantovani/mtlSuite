
for data in "classif_svm_90_pca10" "classif_svm_90_pca20" "classif_svm_90_pca40" "classif_svm_95_pca10" "classif_svm_95_pca20" "classif_svm_95_pca40" "classif_svm_99_pca10" "classif_svm_99_pca20" "classif_svm_99_pca40" 
do
  for algo in "classif.naiveBayes" "classif.svm" "classif.rpart" "classif.kknn" "classif.logreg" "classif.gausspr" "classif.randomForest" 
  #for algo in "classif.svm" "classif.rpart" "classif.kknn" "classif.gausspr" "classif.randomForest" 
  do
    #for norm in "TRUE" "FALSE"
    for norm in "FALSE"
    do
      for feat in "none" #"sfs" # "sbs" "sffs" "sfbs"
      do
        for resamp in "10-CV"
        do
          for tun in "none" # "random"
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
