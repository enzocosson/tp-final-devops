# 🧪 Tests Unitaires - Guide DevOps

## Tests configurés

### ✅ **Backend (Node.js + Jest)**

- **Framework** : Jest avec Supertest
- **Tests** : API endpoints, validation, health checks
- **Commandes** :
  ```bash
  cd backend
  npm test              # Lance tous les tests
  npm run test:watch    # Mode watch pour développement
  ```

### ✅ **Frontend (React + Vitest)**

- **Framework** : Vitest avec React Testing Library
- **Tests** : Composants React, interactions utilisateur, API calls
- **Commandes** :
  ```bash
  cd frontend
  npm test              # Mode interactif
  npm run test:run      # Une seule exécution (CI/CD)
  npm run test:ui       # Interface graphique
  ```

## Structure des tests

### Backend (`/backend/tests/`)

- `api.test.js` - Tests des endpoints REST
- `validation.test.js` - Tests de validation de base

### Frontend (`/frontend/src/test/`)

- `App.test.jsx` - Tests du composant principal
- `validation.test.js` - Tests de validation de base
- `setup.js` - Configuration des tests

## Tests dans le Pipeline CI/CD

Les tests s'exécutent automatiquement dans GitHub Actions :

1. **🏗️ Setup** - Installation des dépendances
2. **🧪 Backend Tests** - Jest + validation API
3. **🧪 Frontend Tests** - Vitest + composants React
4. **🔍 Linting** - ESLint pour la qualité du code
5. **🐳 Build** - Construction des images Docker uniquement si tests OK

## Types de tests implémentés

### ✅ **Tests de validation**

- Opérations JavaScript de base
- Configuration de l'environnement
- Imports de packages

### ✅ **Tests d'API (Backend)**

- Health check endpoint (`/health`)
- CRUD operations (`/todos`)
- Gestion d'erreurs et validation des données
- Codes de statut HTTP appropriés

### ✅ **Tests de composants (Frontend)**

- Rendu des composants React
- Interactions utilisateur (clicks, saisie)
- Appels API mockés
- Gestion des états de chargement et d'erreur

## Couverture de tests

### Backend ✅

- [x] Health check API
- [x] Validation des données d'entrée
- [x] Gestion d'erreurs
- [x] Mocks AWS SDK pour les tests

### Frontend ✅

- [x] Rendu des composants principaux
- [x] Formulaire d'ajout de todos
- [x] Gestion des états (loading, error)
- [x] Mocks des appels fetch

## Commandes rapides

```bash
# Lancer tous les tests du projet
cd backend && npm test && cd ../frontend && npm run test:run

# Tests en mode développement
cd backend && npm run test:watch  # Terminal 1
cd frontend && npm test           # Terminal 2

# Tests de validation rapide
cd backend && npm test validation.test.js
cd frontend && npm run test:run validation.test.js
```

## Intégration CI/CD

Dans `.github/workflows/deploy.yml` :

- ❌ **Tests échouent** → Pipeline s'arrête, pas de déploiement
- ✅ **Tests passent** → Build des images et déploiement automatique

---

**🎯 Résultat** : Pipeline DevOps complet avec tests automatisés garantissant la qualité avant déploiement !
