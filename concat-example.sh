# Concatenation and Cache Busting Logic:
# 1. 'magic' function:
#    - Calculates MD5 checksum of a file.
#    - Renames the file to include the checksum (e.g., all.css -> all_checksum.css).
#    - Updates the reference in index.html to point to the new renamed file.
# 2. CSS Concatenation:
#    - Scans index.html for all <link rel="stylesheet"> tags.
#    - Removes those tags from index.html.
#    - Appends the content of each CSS file into a single 'all.css' file.
#    - Re-inserts a single <link> tag for 'all.css' into index.html at the CSS_ANCHOR.
#    - Applies the 'magic' function to 'all.css' for cache busting.
# 3. JS Concatenation:
#    - Similar to CSS, scans for <script src="..."> tags.
#    - Removes them and appends their content into 'all.js'.
#    - Re-inserts a single <script> tag for 'all.js' at the JS_ANCHOR.
#    - Applies 'magic' to 'all.js' for cache busting.
# 4. DB Versioning:
#    - Updates the database folder version in index.html using the latest git commit SHA.

function magic() {
    FN="$1.$2"
    MD5="$1_$(md5sum "$FN" | cut -f1 -d' ').$2"
    sed -i -e "s/$FN/$MD5/" index.html
    mv "$FN" "$MD5"
}


for file in $(grep -oP -e '"stylesheet" href="\K[^"]*' index.html); do
    sed -i -e "\\#$file#d" index.html
    cat "$file" >> all.css
done
sed -i -e 's$.*CSS_ANCHOR.*$\0\n<link rel="stylesheet" href="all.css" type="text/css" />$' index.html
magic all css


for file in $(grep -oP -e 'script src="\K[^"]*' index.html); do
    sed -i -e "\\#$file#d" index.html
    cat "$file" >> all.js
done
sed -i -e 's$.*JS_ANCHOR.*$\0\n<script src="all.js"></script>$' index.html
magic all js


DB_VERSION=$(date +%s)
# or better
DB_VERSION=$(git rev-parse --short HEAD)
sed -i -e "s/let databaseFolder = .*;/let databaseFolder = \"db-$DB_VERSION\";/" index.html
