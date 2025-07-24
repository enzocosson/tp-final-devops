# 🔐 Configuration des Secrets GitHub

## Secrets nécessaires pour GitHub Actions

Pour que le pipeline CI/CD fonctionne, vous devez configurer les secrets suivants dans votre repository GitHub :

### 📋 **Secrets à ajouter**

1. **AWS_ACCESS_KEY_ID**

   - Votre clé d'accès AWS
   - Nécessaire pour s'authentifier auprès d'AWS

2. **AWS_SECRET_ACCESS_KEY**
   - Votre clé secrète AWS
   - Utilisée avec la clé d'accès pour l'authentification

### 🛠️ **Comment configurer les secrets**

1. **Aller sur GitHub** :

   - Ouvrez votre repository `tp-final-devops`
   - Cliquez sur "Settings" (onglet du repository)

2. **Accéder aux Secrets** :

   - Dans le menu de gauche, cliquez sur "Secrets and variables"
   - Sélectionnez "Actions"

3. **Ajouter les secrets** :

   - Cliquez sur "New repository secret"
   - Nom : `AWS_ACCESS_KEY_ID`
   - Valeur : Votre clé d'accès AWS
   - Cliquez sur "Add secret"

   - Répétez pour `AWS_SECRET_ACCESS_KEY`

### 🔑 **Obtenir vos clés AWS**

Si vous n'avez pas encore de clés d'accès AWS :

1. **Console AWS IAM** :

   - Allez sur https://console.aws.amazon.com/iam/
   - Cliquez sur "Users" → Votre utilisateur
   - Onglet "Security credentials"
   - "Create access key"

2. **Permissions nécessaires** :
   Votre utilisateur AWS doit avoir les permissions :
   - `AmazonEC2ContainerRegistryFullAccess`
   - `AmazonECS_FullAccess`
   - `ElasticLoadBalancingFullAccess`

### ✅ **Vérification**

Une fois les secrets configurés :

1. Les workflows GitHub Actions pourront s'authentifier auprès d'AWS
2. Le déploiement automatique fonctionnera à chaque push sur `main`
3. Vous verrez les résultats dans l'onglet "Actions" de GitHub

### 🚀 **Déclenchement du pipeline**

Le pipeline se déclenche automatiquement :

- ✅ Sur chaque `git push` vers la branche `main`
- ✅ Manuellement via l'onglet "Actions" → "Run workflow"

### 📊 **Ce que fait le pipeline**

1. 🧪 **Tests et linting** du code
2. 🐳 **Build des images Docker** (Frontend + Backend)
3. 📤 **Push vers ECR** (avec tags `latest` et SHA du commit)
4. 🚀 **Déploiement sur ECS** (mise à jour automatique du service)
5. ⏳ **Attente de stabilité** du service
6. 🌐 **Test de l'URL** de l'application
7. 📧 **Notification** du résultat

---

**🔥 PROCHAINE ÉTAPE** : Configurez les secrets et faites un commit pour déclencher le premier déploiement automatique !
