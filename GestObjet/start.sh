#!/bin/sh

echo "🚀 Démarrage..."
echo "⚙️  Exécution des migrations..."
node ace mongo:seed --force

echo "⚡ Lancement du serveur..."
node bin/server.js