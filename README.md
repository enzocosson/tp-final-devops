# Lien d'accès : https://d1g0nijwsvm4k.cloudfront.net

# Déploiement de l'application React avec AWS S3 et CloudFront

Ce projet contient une application React qui peut être déployée sur AWS en utilisant S3 pour l'hébergement statique et CloudFront comme CDN.

## Architecture

- **S3 Bucket** : Hébergement des fichiers statiques de l'application React
- **CloudFront** : CDN pour la distribution globale avec cache optimisé
- **Terraform** : Infrastructure as Code pour provisionner les ressources AWS

## Prérequis

Avant de déployer l'application, assurez-vous d'avoir installé :

1. **Node.js** (version 16 ou supérieure)

   ```bash
   node --version
   npm --version
   ```

2. **Terraform** (version 1.0 ou supérieure)

   ```bash
   terraform --version
   ```

3. **AWS CLI** configuré avec vos credentials
   ```bash
   aws --version
   aws configure list
   ```

## Configuration AWS

Assurez-vous que votre AWS CLI est configuré avec les bonnes credentials :

```bash
aws configure
```

Vous aurez besoin des permissions suivantes :

- S3 (création de buckets, upload de fichiers)
- CloudFront (création et gestion des distributions)
- IAM (pour les politiques de bucket)

## Structure du projet

```
tp2-bis/
├── frontend/          # Application React (Vite)
│   ├── src/
│   ├── package.json
│   └── vite.config.js
├── terraform/         # Configuration Infrastructure
│   ├── main.tf        # Ressources principales
│   ├── variables.tf   # Variables d'entrée
│   └── outputs.tf     # Sorties
└── deploy.sh         # Script de déploiement automatisé
```

## Déploiement automatisé

### Option 1 : Script de déploiement complet

Le moyen le plus simple est d'utiliser le script de déploiement automatisé :

```bash
./deploy.sh
```

Ce script va :

1. Vérifier les prérequis
2. Construire l'application React
3. Déployer l'infrastructure AWS avec Terraform
4. Uploader les fichiers vers S3
5. Invalider le cache CloudFront

### Option 2 : Déploiement manuel étape par étape

#### 1. Construction de l'application React

```bash
cd frontend
npm install
npm run build
```

#### 2. Déploiement de l'infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

#### 3. Upload vers S3

```bash
# Récupérer le nom du bucket depuis Terraform
BUCKET_NAME=$(terraform output -raw s3_bucket_name)

# Synchroniser les fichiers
aws s3 sync ../frontend/dist s3://$BUCKET_NAME --delete
```

#### 4. Invalidation CloudFront

```bash
# Récupérer l'ID de la distribution
DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)

# Invalider le cache
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
```

## Configuration Terraform

### Variables personnalisables

Vous pouvez personnaliser le déploiement en modifiant les variables dans `terraform/variables.tf` :

- `aws_region` : Région AWS (défaut: eu-west-1)
- `bucket_name` : Nom de base du bucket S3
- `environment` : Environnement de déploiement
- `project_name` : Nom du projet

### Outputs disponibles

Après le déploiement, Terraform fournit :

- `cloudfront_url` : URL de votre application
- `s3_bucket_name` : Nom du bucket S3
- `cloudfront_distribution_id` : ID de la distribution CloudFront

## Caractéristiques de la configuration

### S3

- Hébergement web statique activé
- Politique de bucket pour accès public en lecture
- Configuration pour SPA (Single Page Application)

### CloudFront

- HTTPS forcé (redirection automatique)
- Gestion des erreurs 404/403 vers index.html (pour React Router)
- Cache optimisé pour les assets statiques (1 an)
- Cache standard pour les pages HTML (1 heure)
- Compression automatique activée

### Sécurité

- Origin Access Control (OAC) pour sécuriser l'accès S3
- HTTPS uniquement
- Politique de bucket restrictive

## Monitoring et maintenance

### Vérifier le statut du déploiement

```bash
# Status de la distribution CloudFront
aws cloudfront get-distribution --id $(terraform output -raw cloudfront_distribution_id)

# Contenu du bucket S3
aws s3 ls s3://$(terraform output -raw s3_bucket_name) --recursive
```

### Redéploiement

Pour redéployer après des modifications :

```bash
# Rebuild et redéploiement complet
./deploy.sh

# Ou juste l'application (sans infrastructure)
cd frontend && npm run build
aws s3 sync dist s3://$(cd ../terraform && terraform output -raw s3_bucket_name) --delete
aws cloudfront create-invalidation --distribution-id $(cd ../terraform && terraform output -raw cloudfront_distribution_id) --paths "/*"
```

### Destruction de l'infrastructure

⚠️ **Attention** : Ceci supprimera définitivement toutes les ressources AWS.

```bash
cd terraform
terraform destroy
```

## Coûts AWS

Cette architecture utilise :

- **S3** : Stockage et requêtes (~quelques centimes par mois)
- **CloudFront** : Distribution CDN (niveau gratuit disponible)
- **Route 53** : Non utilisé dans cette configuration

Le coût mensuel estimé pour une petite application est généralement inférieur à 5€.

## Dépannage

### Erreurs communes

1. **"Bucket already exists"**

   - Le nom de bucket doit être unique globalement
   - Modifiez la variable `bucket_name` dans `terraform/variables.tf`

2. **"Access Denied"**

   - Vérifiez vos credentials AWS
   - Assurez-vous d'avoir les permissions nécessaires

3. **"Distribution not found"**
   - Attendez que la distribution CloudFront soit complètement déployée
   - Cela peut prendre 10-15 minutes

### Logs et debugging

```bash
# Logs Terraform détaillés
export TF_LOG=DEBUG
terraform apply

# Status CloudFront détaillé
aws cloudfront get-distribution --id YOUR_DISTRIBUTION_ID
```

## Support

Pour toute question ou problème :

1. Vérifiez les logs Terraform et AWS CLI
2. Consultez la documentation AWS
3. Vérifiez que toutes les variables sont correctement configurées
