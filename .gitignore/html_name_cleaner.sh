#!/bin/bash
# Usage: ./rename_html.sh /path/to/dir

TARGET_DIR="${1:-.}"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: $TARGET_DIR is not a directory"
    exit 1
fi

find "$TARGET_DIR" -type f -name '*.html' | while read -r file; do
    dir=$(dirname "$file")
    base=$(basename "$file")

    # Lowercase + remove unwanted chars
    newname=$(echo "$base" | tr '[:upper:]' '[:lower:]' | tr -d '"'\''(),')

    # No change needed
    if [[ "$base" == "$newname" ]]; then
        echo "Skipping $file (already correct)"
        continue
    fi

    # If target name already exists → delete old mixed-case file
    if [[ -e "$dir/$newname" ]]; then
        echo "Deleting duplicate: $file (target $newname already exists)"
        rm -v -- "$file"
        continue
    fi

    # Otherwise safe two-step rename
    tmpname="$file.tmp-rename"

    echo "Renaming: $file → $dir/$newname"

    mv -- "$file" "$tmpname"
    mv -- "$tmpname" "$dir/$newname"
done

