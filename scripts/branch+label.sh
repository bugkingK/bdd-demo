#!/bin/sh

BRANCH_TREE=$0
echo ${BRANCH_TREE}
SELECTED_TAGS=()

if echo ${BRANCH_TREE} | grep -iqF bug ; then
    SELECTED_TAGS+=("bug")
fi

if echo ${BRANCH_TREE} | grep -iqF improve ; then
    SELECTED_TAGS+=("improve")
fi

if echo ${BRANCH_TREE} | grep -iqF feature ; then
    SELECTED_TAGS+=("feature")
fi

TREE_SPLIT=($(echo $BRANCH_TREE | tr "/" "\n"))
for (( i=0; i<${#TREE_SPLIT[@]}; i++ )); do
    if echo ${TREE_SPLIT[i]} | grep -iqF RT ; then
        SELECTED_TAGS+=( `echo ${TREE_SPLIT[i]} | tr [a-z] [A-Z]` )
    fi
done

echo ${SELECTED_TAGS[@]}
