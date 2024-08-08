#!/bin/bash

# Verifica se o arquivo de lista de repositórios foi passado como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <arquivo-repositorios.txt>"
  exit 1
fi

# Lê o nome de usuário do GitHub
read -p "Digite o nome de usuário do GitHub: " USERNAME

# Lê a lista de repositórios do arquivo fornecido
REPOS=$(cat "$1")

# Itera sobre cada repositório na lista
for REPO in $REPOS; do
  # Remove espaços em branco ao redor do nome do repositório
  REPO=$(echo "$REPO" | xargs)

  # Verifica se o nome do repositório não está vazio
  if [ -z "$REPO" ]; then
    echo "Nome do repositório vazio, pulando..."
    continue
  fi

  echo "Clonando repositório $REPO..."
  
  # Clona o repositório
  git clone https://github.com/$USERNAME/$REPO.git
  
  if [ $? -ne 0 ]; then
    echo "Erro ao clonar o repositório $REPO, pulando..."
    continue
  fi

  # Entra no diretório do repositório clonado
  cd $REPO || { echo "Falha ao entrar no diretório $REPO"; exit 1; }
  
  # Cria uma nova branch chamada 'feature/test-commands'
  git checkout -b feature/test-commands
  
  # Volta para o diretório anterior
  cd ..
  
  echo "Branch 'feature/test-commands' criada no repositório $REPO"
done

echo "Todos os repositórios foram clonados e as branches foram criadas."
