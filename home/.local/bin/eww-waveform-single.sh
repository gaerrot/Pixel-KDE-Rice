#!/usr/bin/env bash
cava -p /home/garrett/.config/cava-eww/config | gawk -F';' 'BEGIN{smoothed=10} {sum=0; n=0; for(i=1;i<=NF;i++){if($i!=""){sum+=$i; n++}} avg=(n>0)?sum/n:0; target=(avg - 5) * 1.4 + 10; smoothed = smoothed*0.45 + target*0.55; print int(smoothed); fflush()}'
