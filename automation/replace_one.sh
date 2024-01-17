# clone repo
# checkout to branch fix-image-links
# run script replace_image_links_in_jupyter.py
# commit changes
# push changes in a new branch
set -e

REPO_NAME="mmdetection"

# clone repo
git clone "https://github.com/supervisely-ecosystem/"$REPO_NAME -q
cd "$REPO_NAME"

# checkout to branch fix-image-links
git checkout -b fix-image-links

# run script
cp ../replace_image_links_in_jupyter.py .
python3 replace_image_links_in_jupyter.py -n 2
rm replace_image_links_in_jupyter.py

# commit changes
git add .
git commit -m "Fix image links"

# push changes in a new branch
git push --set-upstream origin fix-image-links

# Delete repo
cd ..
rm -rf "$REPO_NAME"
