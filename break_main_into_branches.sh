#!/bin/bash

# Get all folders in main branch
folders=$(ls -d */)

# Iterate through each folder
for folder in $folders; do
    # Remove trailing slash from folder name
    folder=${folder%/}
    # Convert folder name to lowercase and add hyphen before uppercase letter, except the first letter
    branch_name=$(echo ${folder:0:1} | tr '[:upper:]' '[:lower:]')$(echo ${folder:1} | sed 's/\([A-Z]\)/-\l\1/g')
    # Create a new branch for the folder
    git branch $branch_name
    # Checkout the new branch
    git checkout $branch_name
    # Rename readme file from master branch to readme_master to avoid conflict
    git mv README.md README_master.md
    # Move files in the folder to the root of the branch
    git mv $folder/* .
    # Remove all other files that are not in the folder
    # git ls-files --others --exclude-standard | xargs git rm -rf
    # Remove all other folders that are not in the folder
    for other_folder in $folders; do
        other_folder=${other_folder%/}
        if [ "$other_folder" != "$folder" ]; then
            git rm -rf $other_folder
        fi
    done
    # Remove the empty folder.
    #git rm -rf $folder
    # Commit changes
    git commit -m "Moved files from $folder to new branch $branch_name and removed other folders"
    # go back to main branch
    git checkout master
done
