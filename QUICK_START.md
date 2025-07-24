# 🚀 Guide de démarrage rapide

## ✅ Installation terminée !

Tous les outils nécessaires sont maintenant installés :

- ✅ **OpenTofu** v1.10.3 (alternative open-source à Terraform)
- ✅ **AWS CLI** v2.27.57
- ✅ **Node.js** v24.2.0 et npm v11.3.0

## 📋 Prochaines étapes

### 1. Configuration AWS

```bash
./setup.sh
```

Ce script vous guidera pour configurer vos credentials AWS.

### 2. Déploiement automatique

```bash
./deploy.sh
```

Ce script va :

- Construire l'application React
- Créer l'infrastructure AWS (S3 + CloudFront)
- Déployer l'application

### 3. Accéder à votre application

Après le déploiement, vous recevrez une URL CloudFront où votre application sera accessible.

## 🛠 Déploiement manuel (optionnel)

Si vous préférez faire étape par étape :

```bash
# 1. Construire l'application React
cd frontend
npm install
npm run build
cd ..

# 2. Déployer l'infrastructure
cd terraform
tofu init
tofu plan
tofu apply
cd ..

# 3. Uploader les fichiers
BUCKET_NAME=$(cd terraform && tofu output -raw s3_bucket_name)
aws s3 sync frontend/dist/ s3://$BUCKET_NAME/ --delete

# 4. Invalider le cache CloudFront
DISTRIBUTION_ID=$(cd terraform && tofu output -raw cloudfront_distribution_id)
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
```

## 🗑 Nettoyage

```bash
./cleanup.sh
```

## 📁 Structure créée

```
tp2-bis/
├── frontend/           # Application React (Vite)
├── terraform/          # Infrastructure OpenTofu
│   ├── providers.tf    # Configuration des providers
│   ├── main.tf         # Ressources AWS
│   ├── variables.tf    # Variables configurables
│   └── outputs.tf      # Sorties (URLs, IDs)
├── deploy.sh          # Script de déploiement automatique
├── setup.sh           # Script de configuration AWS
├── cleanup.sh         # Script de nettoyage
└── QUICK_START.md     # Ce guide
```

## 🎯 Fonctionnalités

- 🌐 Hébergement S3 optimisé pour React
- 🚀 CDN CloudFront global
- 🔒 HTTPS automatique
- ⚡ Cache optimisé (assets: 1 an, HTML: 1 heure)
- 🔄 Support des routes React (SPA)
- 🛡️ Sécurité avec Origin Access Control

Commencez par `./setup.sh` pour configurer AWS ! 🎉
