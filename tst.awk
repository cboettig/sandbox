(state == 0) && /^---$/ { state=1; print; next }
(state == 1) && /^---$/ { state=2; next }
(state == 2) && /^./    { state=3; printf "title: %s\n---\n",$0; next }
(state == 3) && /^-+$/  { state=4; next }

state != 2 { print }
