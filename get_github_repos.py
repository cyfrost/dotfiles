#!/usr/bin/env python3

import pygithub3

GITHUB_OAUTH_TOKEN=""

def main():
    gh = pygithub3.Github(GITHUB_OAUTH_TOKEN)
    repos_list = []
    for repo in gh.get_user().get_repos():
        uname=repo.owner.login
		pwd=GITHUB_OAUTH_TOKEN
		clone_url=repo.clone_url
		index=clone_url.find('github.com')
		auth_string = uname + ':' + pwd + '@'
		authenticated_clone_url = clone_url[:index] + auth_string + clone_url[index:]
		repos_list.append(authenticated_clone_url)
    print(repos_list)

if __name__ == '__main__':
    main()
