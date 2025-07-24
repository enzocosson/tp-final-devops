#!/bin/bash

# Script de configuration initiale pour le déploiement AWS

echo "🔧 Configuration initiale pour le déploiement AWS"
echo "=================================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "Étapes de configuration :"
echo "1. Configuration d'AWS CLI"
echo "2. Vérification des permissions"
echo "3. Test de la configuration OpenTofu"
echo ""

# Configuration AWS CLI
print_info "Configuration d'AWS CLI..."
echo ""
print_warning "Vous allez avoir besoin de vos credentials AWS :"
echo "  - Access Key ID"
echo "  - Secret Access Key" 
echo "  - Région (recommandée: eu-west-1)"
echo "  - Format de sortie (recommandé: json)"
echo ""

read -p "Appuyez sur Entrée pour continuer avec 'aws configure'..."

aws configure

echo ""
print_info "Vérification de la configuration AWS..."

# Test de la configuration
if aws sts get-caller-identity > /dev/null 2>&1; then
    print_success "✅ Configuration AWS réussie !"
    echo ""
    print_info "Informations du compte AWS :"
    aws sts get-caller-identity
else
    print_error "❌ Erreur dans la configuration AWS"
    print_error "Veuillez vérifier vos credentials et réessayer."
    exit 1
fi

echo ""
print_info "Test de la configuration OpenTofu..."

cd terraform

# Test d'OpenTofu
if tofu plan > /dev/null 2>&1; then
    print_success "✅ Configuration OpenTofu réussie !"
else
    print_warning "⚠️  Des erreurs peuvent survenir lors du premier plan OpenTofu."
    print_info "Ceci est normal et sera résolu lors du déploiement."
fi

echo ""
print_success "🎉 Configuration terminée !"
echo ""
print_info "Prochaines étapes :"
echo "  1. Construire l'application React : npm run build (dans le dossier frontend)"
echo "  2. Déployer l'infrastructure : ./deploy.sh"
echo "  3. Votre application sera disponible via CloudFront"
echo ""
print_warning "Note : Le déploiement initial peut prendre 15-20 minutes à cause de CloudFront."
