#!/usr/bin/env bash

# pergunta a main class
read -p "Digite o caminho da main class: " MAIN_CLASS

# verifica se foi informado algo
if [ -z "$MAIN_CLASS" ]; then
  echo "Nenhuma main class informada."
  exit 1
fi

# executa o maven
mvn exec:java -Dexec.mainClass="$MAIN_CLASS"
