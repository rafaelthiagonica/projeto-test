1. adicionar o remote do bitbucket e do github.
2. Criar o alias:
    - git config --global alias.push-sync '!f() { git push "$@"; ./push_sync.sh; }; f'
    - para remover o alias: git config --global --unset alias.push-sync

3. criar o arquivo push_sync.sh
