#!/bin/bash

# Remove byte order mark
sed -i -e 's/\xEF\xBB\xBF//g' $1
# Remove ZWJ and replace it with virama (this needs work)
#sed -i 's/\xe2\x80/\xe0\xa5/g' $1
#sed -i 's/\xe0\xa5\x8d\xe0\xa5/\xe0\xa5/g' $1
sed -i 's/ङ‍ग/ङ्ग/g' $1
sed -i 's/ङि‍ग/ङ्गि/g' $1
sed -i 's/ङ्‌मा/ङ्मा/g' $1
# Replaces --- with em dashes
sed -i 's/---/—/g' $1
# Replace <q> tag with <hi rend="bold"> (only for TV)
sed -i 's/<q>/<hi rend="bold">/g' $1
sed -i 's/<\/q>/<\/hi>/g' $1

# Try to get apostrophes right
sed -i "s/^'/‘/g" $1
sed -i "s/>'/>‘/g" $1
sed -i "s/'$/’/g" $1
sed -i "s/। '/। ‘/g" $1
sed -i "s/\([^\s]\)'\s'\([^\s]\)/\1’ ‘\2/g" $1 # Back-to-back quotes
sed -i "s/' इ/’ इ/g" $1 # To catch iti
sed -i "s/\(.\)\(\s\)'/\1\2‘/g" $1
sed -i "s/\(.\)'\(\s\)/\1’\2/g" $1

# Add non-breaking space before daṇḍas
sed -i 's/ ।/ ।/g' $1
# Typographic double daṇḍas
sed -i 's/।।/॥/g' $1


# Getting lg on different lines
sed -i "s/<lg><l>/<lg>\n<l>/g" $1
sed -i "s/<\/l><\/lg>/<\/l>\n<\/lg>/g" $1

