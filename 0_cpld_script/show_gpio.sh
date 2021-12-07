#!/bin/sh
DIN=0x04
DOUT=0x0c
OE=0x10
OTYP=0x14
PU=0x1C
PD=0x20
POL=0x08
IEM=0x58
EVTYP=0x28
EVBE=0x2c
EVEN=0x40
EVST=0x4C

readd()
{
  B=$1
  D=$2
  A=$(printf "0x%x" $((B+D)))
  RES=$(MemAccess2 -rl -a $A -c 1 | sed -n "s#.*= ##p")
  echo "0x$RES"
}

tb()
{
   LBL=$1
   TST=$2
   RES="0"
   if [ $TST != 0 ] ; then
     RES="1"
   fi
   echo -n "$LBL:$RES "
} 

for X in `seq 0 7` ; do
  BASE=$(printf "0x%x" $((0xF0010000 + $X*0x1000)))
  GPB=$(($X*32))
  echo ============== $BASE $GPB
  vDIN=$(readd $BASE $DIN)
  vDOUT=$(readd $BASE $DOUT)
  vOE=$(readd $BASE $OE)
  vPU=$(readd $BASE $PU)
  vPD=$(readd $BASE $PD)
  vIEM=$(readd $BASE $IEM)
  vEVTYP=$(readd $BASE $EVTYP)
  vEVEN=$(readd $BASE $EVEN)
  vEVST=$(readd $BASE $EVES)
  vEVBE=$(readd $BASE $EVBE)
  vPOL=$(readd $BASE $POL)
  vEVTYP=$(readd $BASE $EVTYP)
  vOTYP=$(readd $BASE $OTYP)
  M=1
  echo "dio:$vDIN $vDOUT pud:$vPU $vPD ioe:$vIEM $vOE evten:$vEVTYP $vEVEN evbep:$vEVBE $vPOL"
  for i in `seq 0 31` ; do
    GPN=$(printf "%3d" $((i + GPB)))
    FUNC=$(grep "pin $((i + GPB)) " /sys/kernel/debug/pinctrl/pinctrl@f0800000-npcm7xx-pinctrl/pinmux-pins | sed -n "s#.*function# #p")
    echo -n "gpio $GPN "
    if [ $((M & vOE)) != 0 ] ; then
      tb "dout" $(($M & $vDOUT))
    elif [ $((M & vIEM)) != 0 ] ; then
      tb "din " $(($M & $vDIN))
    else
      echo -n "xinout "
    fi
    if [ $((M & vPU)) != 0 ] ; then
      echo -n "pull-up   "
    elif [ $((M & vPD)) != 0 ] ; then
      echo -n "pull-down "
    else
      echo -n "nopull    "
    fi
    if [ $((M & vOTYP)) != 0 ] ; then
      echo -n "open-drain "
    else
      echo -n "push-pull  "
    fi
    if [ $((M & vEVTYP)) != 0 ] ; then
      echo -n "edge  "
      if [ $((M & vEVBE)) != 0 ] ; then
        echo -n "both    "
      elif [ $((M & vPOL)) != 0 ] ; then
        echo -n "falling "
      else
        echo -n "rising  "
      fi
    else
      echo -n "level "
      if [ $((M & vPOL)) != 0 ] ; then
         echo -n "high    "
      else
         echo -n "low     "
      fi
    fi
    if [ $((M & vEVEN)) != 0 ] ; then
      echo -n "irqen  "
    else
      echo -n "------ "
    fi
    if [ $((M & vEVST)) != 0 ] ; then
      echo -n "pending "
    fi 
    echo "$FUNC"
    M=$((M*2))
  done
done
