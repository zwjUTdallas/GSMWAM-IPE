#!/bin/bash
#:qset -ax

# NMEM_ENS/NJOBS should be an integer by normal math
NMEM_ENS=100
NJOBS=10
#cycles=1

export MODE=standaloneWAM
export PTMP=/glade/work/$USER/scrub/ptmp
export CDATE=2013031600

export mem_per_job=$(($NMEM_ENS/$NJOBS))

export base_job_name=ensemble_test
export driver_input=/glade/work/felixn/noscrub/ensemble_test/wam_input_1.csv

for job_num in $(seq 0 $((NJOBS-1))) ; do

  export job_name=${base_job_name}_$(printf %02d $job_num)
  export njob=$job_num

  envsubst < ensemble.config > ensjob_${job_num}.config

  ./submit.sh ensjob_${mem}.config

  rm -rf ensjob_${mem}.config
done
