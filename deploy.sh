#!/bin/bash

# Script de déploiement pour l'application React
# Ce script construit l'application et la déploie sur AWS S3 + CloudFront

set -e  # Arrêter le script en cas d'erreur

echo "🚀 Début du déploiement de l'application React..."

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher des messages colorés
print_message() {
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

# Vérifier les prérequis
print_message "Vérification des prérequis..."

# Vérifier que Node.js est installé
if ! command -v node &> /dev/null; then
    print_error "Node.js n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que npm est installé
if ! command -v npm &> /dev/null; then
    print_error "npm n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que OpenTofu est installé
if ! command -v tofu &> /dev/null; then
    print_error "OpenTofu n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que AWS CLI est installé
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

print_success "Tous les prérequis sont satisfaits ✅"

# Répertoires
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
TERRAFORM_DIR="$PROJECT_ROOT/terraform"
BUILD_DIR="$FRONTEND_DIR/dist"

print_message "Répertoire du projet : $PROJECT_ROOT"
print_message "Répertoire frontend : $FRONTEND_DIR"
print_message "Répertoire terraform : $TERRAFORM_DIR"

# Étape 1: Construction de l'application React
print_message "📦 Construction de l'application React..."
cd "$FRONTEND_DIR"

# Installer les dépendances si node_modules n'existe pas
if [ ! -d "node_modules" ]; then
    print_message "Installation des dépendances npm..."
    npm install
fi

# Construire l'application
print_message "Construction de l'application..."
npm run build

if [ ! -d "$BUILD_DIR" ]; then
    print_error "La construction a échoué. Le dossier dist n'existe pas."
    exit 1
fi

print_success "Application React construite avec succès 🎉"

# Étape 2: Déploiement de l'infrastructure Terraform
print_message "🏗️  Déploiement de l'infrastructure AWS avec Terraform..."
cd "$TERRAFORM_DIR"

# Initialiser OpenTofu
print_message "Initialisation d'OpenTofu..."
tofu init

# Planifier le déploiement
print_message "Planification du déploiement..."
tofu plan

# Appliquer les changements
print_message "Application des changements..."
tofu apply -auto-approve

# Récupérer les outputs d'OpenTofu
BUCKET_NAME=$(tofu output -raw s3_bucket_name)
CLOUDFRONT_DISTRIBUTION_ID=$(tofu output -raw cloudfront_distribution_id)
CLOUDFRONT_URL=$(tofu output -raw cloudfront_url)

print_success "Infrastructure déployée avec succès 🎉"
print_message "Bucket S3 : $BUCKET_NAME"
print_message "Distribution CloudFront ID : $CLOUDFRONT_DISTRIBUTION_ID"
print_message "URL de l'application : $CLOUDFRONT_URL"

# Étape 3: Upload des fichiers vers S3
print_message "📤 Upload des fichiers vers S3..."

# Synchroniser le dossier build avec S3
aws s3 sync "$BUILD_DIR" "s3://$BUCKET_NAME" --delete

print_success "Fichiers uploadés vers S3 avec succès 🎉"

# Étape 4: Invalidation du cache CloudFront
print_message "🔄 Invalidation du cache CloudFront..."
aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*" > /dev/null

print_success "Cache CloudFront invalidé avec succès 🎉"

# Résumé final
echo ""
echo "==========================================="
print_success "🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS 🎉"
echo "==========================================="
echo ""
print_message "Votre application React est maintenant disponible à l'adresse :"
echo -e "${GREEN}$CLOUDFRONT_URL${NC}"
echo ""
print_message "Informations de déploiement :"
echo "  • Bucket S3 : $BUCKET_NAME"
echo "  • Distribution CloudFront : $CLOUDFRONT_DISTRIBUTION_ID"
echo "  • Région AWS : $(terraform output -raw aws_region 2>/dev/null || echo 'eu-west-1')"
echo ""
print_warning "Note : Il peut falloir quelques minutes pour que les changements se propagent via CloudFront."
echo ""
