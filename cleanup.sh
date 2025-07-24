#!/bin/bash

# Script de nettoyage pour supprimer l'infrastructure AWS
# ⚠️  ATTENTION : Ce script supprime définitivement toutes les ressources AWS

set -e

echo "🗑️  Script de nettoyage de l'infrastructure AWS"

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Répertoires
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/terraform"

print_warning "⚠️  ATTENTION ⚠️"
print_warning "Ce script va SUPPRIMER DÉFINITIVEMENT toute l'infrastructure AWS créée."
print_warning "Cela inclut :"
print_warning "  - Le bucket S3 et tout son contenu"
print_warning "  - La distribution CloudFront"
print_warning "  - Toutes les politiques et configurations associées"
echo ""

# Demander confirmation
read -p "Êtes-vous sûr de vouloir continuer ? (tapez 'oui' pour confirmer) : " confirmation

if [ "$confirmation" != "oui" ]; then
    print_message "Annulation du nettoyage."
    exit 0
fi

print_message "Vérification de la présence de Terraform..."
if ! command -v terraform &> /dev/null; then
    print_error "Terraform n'est pas installé."
    exit 1
fi

print_message "Déplacement vers le répertoire Terraform..."
cd "$TERRAFORM_DIR"

if [ ! -f "main.tf" ]; then
    print_error "Fichier main.tf non trouvé dans $TERRAFORM_DIR"
    exit 1
fi

# Vérifier si le state existe
if [ ! -f "terraform.tfstate" ]; then
    print_warning "Aucun fichier terraform.tfstate trouvé."
    print_warning "L'infrastructure n'a peut-être pas été déployée ou a déjà été supprimée."
    exit 0
fi

print_message "Initialisation de Terraform..."
terraform init

print_message "Planification de la destruction..."
terraform plan -destroy

echo ""
print_warning "Dernière chance d'annuler !"
read -p "Tapez 'SUPPRIMER' pour confirmer la destruction : " final_confirmation

if [ "$final_confirmation" != "SUPPRIMER" ]; then
    print_message "Annulation du nettoyage."
    exit 0
fi

print_message "🗑️  Destruction de l'infrastructure en cours..."
terraform destroy -auto-approve

print_success "🎉 Infrastructure supprimée avec succès !"

# Nettoyage des fichiers Terraform locaux (optionnel)
echo ""
read -p "Voulez-vous aussi supprimer les fichiers Terraform locaux (.terraform, tfstate) ? (o/n) : " clean_local

if [ "$clean_local" = "o" ] || [ "$clean_local" = "O" ] || [ "$clean_local" = "oui" ]; then
    print_message "Nettoyage des fichiers locaux..."
    rm -rf .terraform
    rm -f terraform.tfstate*
    rm -f .terraform.lock.hcl
    print_success "Fichiers locaux supprimés."
fi

echo ""
print_success "✅ Nettoyage terminé !"
print_message "Toutes les ressources AWS ont été supprimées."
