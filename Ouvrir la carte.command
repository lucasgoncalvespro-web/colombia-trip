#!/bin/bash
# Double-clique ce fichier dans le Finder : il démarre le serveur local
# (nécessaire pour charger les tuiles de carte et les photos) et ouvre
# la carte dans ton navigateur par défaut.

cd "$(dirname "$0")"
PORT=8777
URL="http://127.0.0.1:$PORT"

if ! curl -s -o /dev/null "$URL"; then
  echo "Démarrage du serveur local sur $PORT..."
  nohup node serve.mjs > /tmp/colombia-trip-serve.log 2>&1 &
  sleep 1
fi

open "$URL"
echo "Carte ouverte : $URL"
echo "Tu peux fermer cette fenêtre — le serveur continue de tourner en arrière-plan."
echo "(Pour l'arrêter : ouvre le Moniteur d'activité et termine le process 'node'.)"
sleep 3
