#!/bin/bash

for name in `ls *.markdown`
  do
    file_name=`echo $name | cut -d. -f1 | cut -d "_" -f 2-`
     git mv $name $file_name.md
done
