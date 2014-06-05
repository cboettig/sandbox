#!/bin/bash


for f in `grep -l '##* References$' *.markdown *.md`
  # *md *.markdown 
  do 
    sed -i 's/##* References$/\n## References/g' $f 
    sed -i 's/<EM>/*/g' $f 
    sed -i 's/<\/EM>/*/g' $f 
    sed -i 's/<B>/**/g' $f 
    sed -i 's/<\/B>/**/g' $f 
    sed -i 's/\&rdquo;/"/g' $f 
    sed -i 's/\&ldquo;/"/g' $f 
    sed -i 's/<p>/\n- /g' $f 
done


