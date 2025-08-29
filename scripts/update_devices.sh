#!/bin/bash
set -e

XML_FILE="$1"
DEVICE_DIR="$2"

TMP_FILE=$(mktemp)

FOLDERS=($(ls -1 "$DEVICE_DIR"))

XML_PRODUCTS=($(grep -o '<iq:product id="[^"]*"' "$XML_FILE" | sed -E 's/<iq:product id="([^"]+)"/\1/'))
XML_COMMENTS=($(grep -o '<!-- <iq:product id="[^"]*"' "$XML_FILE" | sed -E 's/<!-- <iq:product id="([^"]+)"/\1/'))

EXISTING=()
COMMENTED=()

for prod in "${XML_PRODUCTS[@]}"; do
    EXISTING+=("$prod")
done

for prod in "${XML_COMMENTS[@]}"; do
    COMMENTED+=("$prod")
done

PRODUCTS=()
COMMENTS=()

for dev in "${FOLDERS[@]}"; do
    if [[ ! " ${COMMENTED[@]} " =~ " $dev " ]]; then
        PRODUCTS+=("$dev")
    else
        COMMENTS+=("$dev")
    fi
done

PRODUCTS=($(echo "${PRODUCTS[@]}" | tr ' ' '\n' | sort | tr '\n' ' '))
COMMENTS=($(echo "${COMMENTS[@]}" | tr ' ' '\n' | sort | tr '\n' ' '))

COMBINED=($(echo "${PRODUCTS[@]}" "${COMMENTS[@]}" | tr ' ' '\n' | sort | tr '\n' ' '))

{
    for prod in "${COMBINED[@]}"; do
        if [[ " ${COMMENTS[@]} " =~ " $prod " ]]; then
            echo "            <!-- <iq:product id=\"$prod\" /> -->"
        else
            echo "            <iq:product id=\"$prod\" />"
        fi
    done
    echo "        </iq:products>"
} > "$TMP_FILE"

awk -v newblock="$TMP_FILE" '
    BEGIN { skip=0 }
    /<iq:products>/ { print; skip=1; next }
    /<\/iq:products>/ {
        while ((getline line < newblock) > 0) print line
        close(newblock)
        skip=0
        next
    }
    { if (!skip) print }
' "$XML_FILE" > "${XML_FILE}.tmp"

mv "${XML_FILE}.tmp" "$XML_FILE"
rm "$TMP_FILE"

