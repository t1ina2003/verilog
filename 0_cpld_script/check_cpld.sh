#!/bin/sh
#######################################
# this sh script conatin following  feature:
# # count specific second elapsed
# # exec command every specific second
# # stop while different output occur
# zswang
#######################################

#######################################
# System Setting
#######################################
SLPTIME=1 # time interval between each command
defaultADDR="f8000000" # target address 
#######################################
# Function Variable
#  FUNC is the command to be executed.
example_FUNC_Dump="+             0  1  2  3  4  5  6  7 :  8  9  A  B  C  D  E  F
--------------------------------------------------------------
0xf8000000 = 02 15 65 01 22 00 00 00 : 00 00 00 c0 00 09 e3 d4 
0xf8000010 = 60 04 c0 00 60 fe 8b a5 : 8f ff 8f 40 0f 00 00 1f 
0xf8000020 = ff 0c 00 00 00 ff 00 a0 : ff 09 7f 00 00 00 00 00 
0xf8000030 = 00 41 00 00 00 00 00 00 : 00 0f 00 00 02 00 00 00 "
#######################################
FUNC() {
    if [ -n "$1" ] && [ -n "$2" ]
    then
        CpldAccess2 -r -a $1 -c $2
    elif [ -n "$1" ]
    then
        CpldAccess2 -r -a $1
    else
        CpldAccess2 -r -a $defaultADDR
    fi
    
}

#######################################
# Main
#######################################
#  initial value.
oldValue=$(FUNC $1 $2)
elapsedTime=0 
# loop sceond.
while sleep $SLPTIME
do 
    #  check if  value changed.
    if [ "$oldValue" != "$(FUNC $1 $2)" ]
    then 
        printf "something diff! at $elapsedTime sec.\n"
        printf  "new value\n"
        printf  "$(FUNC $1 $2)\n"
        printf  "old value\n"
        printf "$oldValue\n"
        break
    fi
    #  if value is not changed, fill in old value.
    oldValue="$(FUNC $1 $2)"
    # calculate elapsed time.
    elapsedTime=$(($elapsedTime+$SLPTIME))
    # print time 
    printf "elapsed $elapsedTime sec\r"
done