#!/bin/bash

# Script pour tester l'application localement avec DynamoDB
echo "🚀 Configuration de l'environnement de test local..."

# Variables d'environnement pour le développement local
export AWS_REGION=eu-west-1
export DYNAMODB_TABLE_NAME=tp2-bis-react-app-todos-production
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_ENDPOINT_URL=http://localhost:8000

echo "📋 Variables d'environnement configurées :"
echo "  - AWS_REGION: $AWS_REGION"
echo "  - DYNAMODB_TABLE_NAME: $DYNAMODB_TABLE_NAME"
echo "  - AWS_ENDPOINT_URL: $AWS_ENDPOINT_URL"

echo ""
echo "🔧 Pour tester localement :"
echo "1. Démarrer DynamoDB Local (optionnel pour développement) :"
echo "   docker run -p 8000:8000 amazon/dynamodb-local"
echo ""
echo "2. Installer les dépendances du backend :"
echo "   cd backend && npm install"
echo ""
echo "3. Démarrer le backend :"
echo "   cd backend && npm start"
echo ""
echo "4. Installer les dépendances du frontend :"
echo "   cd frontend && npm install"
echo ""
echo "5. Démarrer le frontend :"
echo "   cd frontend && npm run dev"
echo ""
echo "🌟 L'application sera accessible sur http://localhost:5173"
echo "🔗 L'API sera accessible sur http://localhost:3005"
