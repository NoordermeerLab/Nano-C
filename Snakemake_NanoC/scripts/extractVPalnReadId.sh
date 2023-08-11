awk '{ if ($1 !~ /^@/) print $1}' $1 > $2
