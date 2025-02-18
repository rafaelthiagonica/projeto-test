#!/bin/bash

echo "Sincronizando Branchs"

# Pega os nomes dos remotes configurados
remotes=$(git remote)

# Verifique se temos pelo menos dois remotes configurados (Bitbucket e GitHub)
if [ $(echo "$remotes" | wc -l) -lt 2 ]; then
    echo "É necessário ter pelo menos dois remotes configurados (Bitbucket e GitHub)."
    exit 1
fi

# Obtenha os remotes de Bitbucket e GitHub
REMOTE_BITBUCKET=$(echo "$remotes" | grep -i bitbucket)
REMOTE_GITHUB=$(echo "$remotes" | grep -i github)

# Se não encontrou os remotes, avise ao usuário
if [ -z "$REMOTE_BITBUCKET" ] || [ -z "$REMOTE_GITHUB" ]; then
    echo "Não foi possível identificar os remotes do Bitbucket e GitHub. Certifique-se de que estão configurados corretamente."
    exit 1
fi

# Obtenha a branch atual
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Verificar se a branch principal do GitHub (main) está sendo empurrada para o Bitbucket
if [[ "$CURRENT_BRANCH" == "main" ]]; then
  echo "Erro: Você não pode empurrar a branch 'main' para o Bitbucket!"
  exit 1
fi

# Verificar se a branch principal do Bitbucket (master) está sendo empurrada para o GitHub
if [[ "$CURRENT_BRANCH" == "master" ]]; then
  echo "Erro: Você não pode empurrar a branch 'master' para o GitHub!"
  exit 1
fi


# Verificar se a branch atual existe no Bitbucket
echo ""
echo "Verificando se a branch '$CURRENT_BRANCH' existe no '$REMOTE_BITBUCKET'..."
BRANCH_EXISTS=$(git ls-remote --heads $REMOTE_BITBUCKET $CURRENT_BRANCH)

if [[ -z "$BRANCH_EXISTS" ]]; then
  echo " ❌ A branch '$CURRENT_BRANCH' NÃO existe no '$REMOTE_BITBUCKET'."
  git push $REMOTE_BITBUCKET
else
  echo " ✅ A branch '$CURRENT_BRANCH' já existe no '$REMOTE_BITBUCKET'."
fi

echo ""
echo "Verificando se a branch '$CURRENT_BRANCH' está atualizada no Bitbucket..."
LOCAL_COMMIT=$(git rev-parse $CURRENT_BRANCH)
REMOTE_COMMIT=$(git rev-parse $REMOTE_BITBUCKET/$CURRENT_BRANCH)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
  echo " ✅ A branch '$CURRENT_BRANCH' já está atualizada no Bitbucket."
else
  echo " ❌ A branch '$CURRENT_BRANCH' não está atualizada no Bitbucket. Empurrando..."
  git push $REMOTE_BITBUCKET
fi


# Verificar se a branch atual existe no Github
echo ""
echo "Verificando se a branch '$CURRENT_BRANCH' existe no '$REMOTE_GITHUB'..."
BRANCH_EXISTS=$(git ls-remote --heads $REMOTE_GITHUB $CURRENT_BRANCH)

if [[ -z "$BRANCH_EXISTS" ]]; then
  echo " ❌ A branch '$CURRENT_BRANCH' NÃO existe no '$REMOTE_GITHUB'."
  git push $REMOTE_GITHUB
else
  echo " ✅ A branch '$CURRENT_BRANCH' já existe no '$REMOTE_GITHUB'."
fi

echo ""
echo "Verificando se a branch '$CURRENT_BRANCH' está atualizada no GitHub..."
LOCAL_COMMIT=$(git rev-parse $CURRENT_BRANCH)
REMOTE_COMMIT=$(git rev-parse $REMOTE_GITHUB/$CURRENT_BRANCH)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
  echo " ✅ A branch '$CURRENT_BRANCH' já está atualizada no GitHub."
else
  echo " ❌ A branch '$CURRENT_BRANCH' não está atualizada no GitHub. Empurrando..."
  git push $REMOTE_GITHUB
fi



# Obtém as URLs dos remotes
BITBUCKET_URL=$(git remote get-url bitbucket | sed 's/\.git$//')
GITLAB_URL=$(git remote get-url github | sed 's/\.git$//')

# Gerar links de PR
BITBUCKET_PR_URL="$BITBUCKET_URL/branches/compare/$CURRENT_BRANCH%0Dmaster"
GITHUB_PR_URL="$GITLAB_URL/compare/$CURRENT_BRANCH?expand=1"
echo ""
echo "Abra os seguintes links para criar Pull Requests:"
echo " 🔗 Bitbucket: $BITBUCKET_PR_URL"
echo " 🔗 GitHub: $GITHUB_PR_URL"
