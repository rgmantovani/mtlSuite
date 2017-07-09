
for data in "regr_all" "regr_cnet" "regr_comp" "regr_info" "regr_land" "regr_modl" "regr_simp" "regr_stat" "regr_time" 
do
  for norm in "TRUE" "FALSE"
  do
    for rep in $(seq 1 30);
    do
      R CMD BATCH --no-save --no-restore '--args' --datafile="$data" --normalization="$norm" \ 
        --seed="$rep" mainMTL.R out_"$data"_"$norm"_"$rep".log &
      PIDS[$rep]=$!
    done
    for k in $(seq 1 30);
      do
        wait ${PIDS[$k]}
      done;
  done
done
