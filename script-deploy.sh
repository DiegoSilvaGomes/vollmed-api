#!/bin/bash

echo "==== INICIANDO DEPLOY ===="

# Carrega imagem Docker
if [ ! -f vollmed-api.tar ]; then
  echo "Arquivo vollmed-api.tar não encontrado!"
  exit 1
fi

docker load -i vollmed-api.tar || { echo "Erro ao carregar imagem Docker"; exit 1; }

# Renomeia arquivo de compose
if [ ! -f docker-compose-prod.yaml ]; then
  echo "Arquivo docker-compose-prod.yaml não encontrado!"
  exit 1
fi

mv docker-compose-prod.yaml docker-compose.yaml

# Para containers existentes
container_ids=$(docker ps -q)

if [ -z "$container_ids" ]; then
  echo "Não há containers em execução"
else
  for container_id in $container_ids; do
    echo "Parando container: $container_id"
    docker stop $container_id
  done
  echo "Todos os containers em execução foram parados."
fi

# Sobe containers
echo "Subindo containers com Docker Compose"
docker compose up -d || { echo "Erro ao subir containers"; exit 1; }

echo "==== DEPLOY FINALIZADO COM SUCESSO ===="
