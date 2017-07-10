
for data in "regr_all" # "regr_cnet" "regr_comp" "regr_info" "regr_land" "regr_modl" "regr_simp" "regr_stat" "regr_time" 
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
           # echo R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --algo="$algo" --norm="$norm" --feat.sel="$feat" -seed="$rep" \
            # mainMTL.R out_"$data"_"$algo"_"$norm"_"$feat"_"$rep".log &
          # PIDS[$rep]=$!
        done
        for k in $(seq 1 10);
        do
          wait ${PIDS[$k]}
        done;
      done
    done
  done
done
