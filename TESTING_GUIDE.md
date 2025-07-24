# 🚀 Guide de Test de l'Application

## URLs de l'application

### Frontend (CloudFront)

- **URL** : https://d1qxspg9qz55si.cloudfront.net
- **Description** : Interface React pour la Todo List

### Backend API (Application Load Balancer)

- **URL** : http://tp2-bis-react-app-alb-128396890.eu-west-1.elb.amazonaws.com
- **Description** : API REST Node.js pour les todos

## 🧪 Tests de l'API

### 1. Health Check

```bash
curl http://tp2-bis-react-app-alb-128396890.eu-west-1.elb.amazonaws.com/health
```

Résultat attendu :

```json
{ "status": "OK", "timestamp": "2025-07-24T..." }
```

### 2. Lister les todos

```bash
curl http://tp2-bis-react-app-alb-128396890.eu-west-1.elb.amazonaws.com/todos
```

### 3. Créer un todo

```bash
curl -X POST http://tp2-bis-react-app-alb-128396890.eu-west-1.elb.amazonaws.com/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Test DevOps","description":"Vérifier que l'\''API fonctionne"}'
```

### 4. Vérifier dans DynamoDB

Les données sont stockées dans la table : `tp2-bis-react-app-todos-production`

## 🔍 Monitoring

### CloudWatch Logs

- **Log Group** : `/ecs/tp2-bis-react-app-backend`
- **Région** : eu-west-1

### ECS Service

- **Cluster** : tp2-bis-react-app-cluster
- **Service** : tp2-bis-react-app-backend-service

## 📊 Status Dashboard

Après déploiement, vérifiez :

- ✅ ECS Service : 1/1 tasks running
- ✅ ALB Health Check : Healthy
- ✅ CloudWatch Logs : Pas d'erreurs
- ✅ Application accessible via CloudFront

## 🚨 Troubleshooting

### Si l'API ne répond pas :

1. Vérifier ECS Service dans la console AWS
2. Consulter CloudWatch Logs
3. Vérifier les Security Groups
4. Tester directement l'ALB

### Si les images ne se déploient pas :

1. Vérifier GitHub Actions logs
2. Vérifier les secrets GitHub
3. Contrôler les permissions IAM
4. Valider les images dans ECR

---

**🎯 Tout est prêt ! Il ne reste plus qu'à configurer les secrets GitHub et faire un commit pour déclencher le déploiement automatique.**
