#! /bin/bash

for f in *OWW* 
  #$(find . -iname "*md")
  do 
    awk -f tst.awk $f > `basename $f .markdown`.md
    mv  `basename $f .markdown`.md $f
done

