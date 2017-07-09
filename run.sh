
for data in "regr_all" "regr_cnet" "regr_comp" "regr_info" "regr_land" "regr_modl" "regr_simp" "regr_stat" "regr_time" 
do
  # echo $data
  R CMD BATCH --no-save --no-restore '--args' --datafile="$data" mainMTL.R out_"$data".log &
done
