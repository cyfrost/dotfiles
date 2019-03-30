#!/usr/bin/env python3

import pygithub3

GITHUB_OAUTH_TOKEN=""

def main():
    gh = pygithub3.Github(GITHUB_OAUTH_TOKEN)
    repos_list = []
    for repo in gh.get_user().get_repos():
        repos_list.append(repo.clone_url)
    print(repos_list)

if __name__ == '__main__':
    main()
