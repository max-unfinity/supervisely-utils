#!/bin/bash
set -e

# Define a list of GitHub repository URLs
REPOS=("mmclassification" "hrda" "detectron2")

# Loop through each repository URL
for REPO_NAME in "${REPOS[@]}"
do
    REPO="https://github.com/supervisely-ecosystem/"$REPO_NAME

    # Clone the repository
    git clone "$REPO"
    cd "$REPO_NAME"

    # Checkout to the specified branch
    git checkout -b fix-image-links

    # Run script
    cp ../replace_image_links_in_jupyter.py .
    python3 replace_image_links_in_jupyter.py -n 2
    rm replace_image_links_in_jupyter.py

    # Commit the changes
    git add .
    git commit -m "Fixed image links"

    # Push the changes to a new branch
    git push --set-upstream origin fix-image-links

    # Delete repo
    cd ..
    rm -rf "$REPO_NAME"
done
