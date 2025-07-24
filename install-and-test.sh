#!/bin/bash

echo "🚀 Installation des dépendances et test de l'application..."

# Installation des dépendances du backend
echo "📦 Installation des dépendances du backend..."
cd backend
npm install
cd ..

# Installation des dépendances du frontend
echo "📦 Installation des dépendances du frontend..."
cd frontend
npm install
cd ..

echo "✅ Installation terminée !"
echo ""
echo "🧪 Pour tester l'application :"
echo "1. Appliquer l'infrastructure Terraform :"
echo "   cd terraform && terraform apply"
echo ""
echo "2. Démarrer le backend :"
echo "   cd backend && npm start"
echo ""
echo "3. Démarrer le frontend (dans un autre terminal) :"
echo "   cd frontend && npm run dev"
echo ""
echo "4. Ouvrir http://localhost:5173 dans votre navigateur"
echo ""
echo "🔧 Variables d'environnement importantes pour le backend :"
echo "   - AWS_REGION (défaut: eu-west-1)"
echo "   - DYNAMODB_TABLE_NAME (sera créé par Terraform)"
echo ""
echo "💡 Consultez backend/.env.example pour la configuration"
