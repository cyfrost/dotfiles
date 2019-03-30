#!/bin/bash

GITHUB_REPOS_SCRIPT="./get_repo_urls.py"
REPOS_DIR="$HOME/repos"
AUTH_TOKEN="$1"
CUR_DIR=`pwd`

#
# https://raw.githubusercontent.com/cyfrost/dotfiles/master/get_github_repos.py
#
# #!/usr/bin/env python3

# import pygithub3

# GITHUB_OAUTH_TOKEN=""

# def main():
#     gh = pygithub3.Github(GITHUB_OAUTH_TOKEN)
#     repos_list = []
#     for repo in gh.get_user().get_repos():
#         repos_list.append(repo.clone_url)
#     print(repos_list)

# if __name__ == '__main__':
#     main()

rm -f $GITHUB_REPOS_SCRIPT;

mkdir -p $REPOS_DIR;

curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/get_github_repos.py" >> $GITHUB_REPOS_SCRIPT

sed -i 's/GITHUB_OAUTH_TOKEN=""/GITHUB_OAUTH_TOKEN="'"$AUTH_TOKEN"'"/g' "$GITHUB_REPOS_SCRIPT"

REPOS_LIST=($(python3 $GITHUB_REPOS_SCRIPT | tr -d '[],'))

cd $REPOS_DIR

for repo in "${REPOS_LIST[@]}"
do
    printf "\n\n"
    repo=$(echo "$repo" | tr -d \')
    git clone "$repo";
done

for d in `find . -name .git -type d`; do
   cd $d/.. > /dev/null;
   echo -e "\nUpdating `pwd`";
   git pull;
   cd - > /dev/null;
done;

printf "\n" && cd $CUR_DIR
