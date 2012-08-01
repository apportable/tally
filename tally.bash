#!/bin/bash
# Copyright 2012, Craig Barnes
# Licensed under the Internet Systems Consortium (ISC) license

IFS=$'\n'       # Prevent loops splitting filenames on whitespace
declare -A SUB  # Initialise associative array to store subtotals

stripc() {
    awk -vRS='*/' '{gsub(/\/\*.*/,"")}1' $1 | sed -r '/^(\s|[{}])*$/d'
}

stripxml() {
    awk -vRS='-->' '{gsub(/<!--.*/,"")}1' $1 | sed '/^\s*$/d'
}

count() {
    case $2 in
    AWK|CoffeeScript|Make|Perl|Python|Sed|Shell|TCL|YAML)
        let SUB[$2]+=$(sed -r '/^\s*(#|$)/d' $1 | wc -l);;
    Ruby)
        let SUB[$2]+=$(sed -r '/^\s*(#|$)/d;/^=begin$/,/^=end$/d' $1 | wc -l);;
    C|CSS|JavaScript|Vala)
        let SUB[$2]+=$(stripc $1 | wc -l);;
    SQL|Lua)
        let SUB[$2]+=$(sed -r '/^\s*(\-\-|$)/d' $1 | wc -l);;
    HTML|Mallard|XML)
        let SUB[$2]+=$(stripxml $1 | wc -l);;
    JSON|Markdown)
        let SUB[$2]+=$(sed '/^\s*$/d' $1 | wc -l);;
    esac
}

subtotals() {
    for LANG in ${!SUB[@]}; do
        printf " │ %-13s │ %'8d │\n" $LANG: ${SUB[$LANG]}
    done | sort -nrk4
}

for F in $(find $@ -type f -not -path "*/.*"); do
    case $F in
        *.a|*.gif|*.gz|*.jpg|*.jpeg|*.o|*.obj|*.out|*.png|*.rpm|*.so| \
        *.svg|*.svgz|*.tar|*.tgz|*.xz|*.zip|*.[123456789]) ;;
        *.awk)              count $F AWK;;
        *.c|*.h)            count $F C;;
        *.coffee)           count $F CoffeeScript;;
        *.css)              count $F CSS;;
        *.html)             count $F HTML;;
        *.js)               count $F JavaScript;;
        *.json)             count $F JSON;;
        *.lua)              count $F Lua;;
        *.md|*.mkd|*.mkdn)  count $F Markdown;;
        *.page)             count $F Mallard;;
        *.perl|*.pl|*.pm)   count $F Perl;;
        *.py)               count $F Python;;
        *.rb)               count $F Ruby;;
        *.sed)              count $F Sed;;
        *.sh|*.bash)        count $F Shell;;
        *.sql)              count $F SQL;;
        *.tcl)              count $F TCL;;
        *.vala)             count $F Vala;;
        *.yaml|*.yml)       count $F YAML;;
        *.xml|*.ui|*.glade) count $F XML;;
        *[Mm]akefile|*.mk)  count $F Make;;
        # If no filename pattern matches, try to match hashbang:
        *) case "$(sed -rn '1s|(\#!.*/(env)?\s*)?(.*)|\3|p' $F)" in
            awk*|gawk*)     count $F AWK;;
            bash|sh)        count $F Shell;;
            coffee*)        count $F CoffeeScript;;
            lua*)           count $F Lua;;
            make*|?make*)   count $F Make;;
            perl*)          count $F Perl;;
            python*)        count $F Python;;
            ruby*)          count $F Ruby;;
            sed*)           count $F Sed;;
            *html*)         count $F HTML;;
            *mallard*)      count $F Mallard;;
            *xml*)          count $F XML;;
            %YAML*)         count $F YAML;;
        esac;;
    esac
done

# Exit if nothing was counted
if test ${#SUB[@]} -eq 0; then
    echo "Nothing to count" >&2
    exit 0
fi

# Print table of results
echo " ┌───────────────┬──────────┐"
echo " │ Language      │    Lines │"
echo " ├───────────────┼──────────┤"
         subtotals         00,000
echo " └───────────────┴──────────┘"
