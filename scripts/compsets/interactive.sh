#!/bin/bash

pwd=$(pwd)
bn=$(basename $1)

## set restart
export cycle=${2:-1}
if [[ $cycle == 1 ]] ; then
  export RESTART=.false.
else
  export RESTART=.true.
fi

## source config
CONFIG=$( echo $bn | cut -d'.' -f 1 )
. $pwd/config/workflow.sh $1

if [ $? != 0 ]; then echo "setup failed, exit"; exit; fi

## cp config to $ROTDIR if $cycle == 1
if [[ $cycle == 1 ]] || [[ ! -f $ROTDIR/$1 ]] ; then
	cp $1 $ROTDIR/.
fi

cd $COMPSETDIR

##-------------------------------------------------------
## source config file
##-------------------------------------------------------

. $pwd/config/workflow.sh $ROTDIR/$bn

##-------------------------------------------------------
## execute forecast
##-------------------------------------------------------

rm -rf $RUNDIR
mkdir -p $RUNDIR
cd $RUNDIR

export VERBOSE=YES

 . $EXGLOBALFCSTSH &> $ROTDIR/wam-ipe.out
if [ $? != 0 ]; then echo "forecast failed, exit"; exit; fi
echo "fcst done" >> $ROTDIR/wam-ipe.out

exit $status

