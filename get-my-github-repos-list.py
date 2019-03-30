#!/usr/bin/env python3

import pygithub3

def main():
    gh = pygithub3.Github("476a896a245351bd0a84dc0454f68d11f6b9608a")
    repos_list = []
    for repo in gh.get_user().get_repos():
        repos_list.append(repo.clone_url)
    print(repos_list)

if __name__ == '__main__':
    main()
