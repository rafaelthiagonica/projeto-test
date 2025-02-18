1. adicionar o remote do bitbucket e do github.
2. Criar o alias:
    - git config --global alias.push-sync '!f() { git push "$@"; ./push_sync.sh; }; f'
    - para remover o alias: git config --global --unset alias.push-sync

3. criar o arquivo push_sync.sh
4. colocar na hook post-commit o codigo abaixo
----------------------------------------------------------------
#!/bin/sh

# Verifica se o alias push-sync existe
if git config --global --get alias.push-sync > /dev/null; then
    echo ""
    echo -e "\033[97mLembre-se de usar '\033[33mpush-sync\033[97m' para manter os repositorios sincronizados\033[0m"
    echo ""
else
    echo -e "\033[97mCriando o alias '\033[33mpush-sync\033[97m'...\033[0m"
    git config --global alias.push-sync '!f() { git push "$@"; ./push-sync.sh; }; f'
    echo -e "\033[97mAlias '\033[33mpush-sync\033[97m' criado com sucesso!\033[0m"
fi
----------------------------------------------------------------
5.
