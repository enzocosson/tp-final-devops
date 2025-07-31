#!/bin/bash

# Script de test pour vérifier les améliorations du pipeline
# Ce script peut être utilisé pour tester localement les changements

echo "🧪 Test des améliorations du pipeline de déploiement"
echo "================================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables (à adapter selon votre environnement)
ECS_CLUSTER="tp2-bis-react-app-cluster"
ECS_SERVICE="tp2-bis-react-app-backend-service"
ALB_NAME="tp2-bis-react-app-alb"
TARGET_GROUP_NAME="tp2-bis-react-app-backend-tg"

echo -e "${BLUE}1. Vérification de la configuration AWS...${NC}"
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}❌ AWS CLI n'est pas configuré correctement${NC}"
    exit 1
fi
echo -e "${GREEN}✅ AWS CLI configuré${NC}"

echo -e "${BLUE}2. Test de construction du backend avec curl...${NC}"
cd backend
if docker build -t test-backend . > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Image backend construite avec succès${NC}"
    
    # Vérifier que curl est disponible
    if docker run --rm test-backend curl --version > /dev/null 2>&1; then
        echo -e "${GREEN}✅ curl disponible dans l'image${NC}"
    else
        echo -e "${RED}❌ curl non disponible dans l'image${NC}"
    fi
    
    # Nettoyer l'image de test
    docker rmi test-backend > /dev/null 2>&1
else
    echo -e "${RED}❌ Échec de construction de l'image backend${NC}"
fi
cd ..

echo -e "${BLUE}3. Vérification de l'infrastructure AWS...${NC}"

# Vérifier le cluster ECS
if aws ecs describe-clusters --clusters $ECS_CLUSTER > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Cluster ECS trouvé${NC}"
else
    echo -e "${YELLOW}⚠️ Cluster ECS non trouvé (normal si pas encore déployé)${NC}"
fi

# Vérifier le service ECS
if aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Service ECS trouvé${NC}"
    
    # Afficher le statut du service
    echo -e "${BLUE}Statut actuel du service :${NC}"
    aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE \
        --query 'services[0].{RunningCount:runningCount,PendingCount:pendingCount,DesiredCount:desiredCount,Status:status}' \
        --output table
else
    echo -e "${YELLOW}⚠️ Service ECS non trouvé (normal si pas encore déployé)${NC}"
fi

# Vérifier l'ALB
if aws elbv2 describe-load-balancers --names $ALB_NAME > /dev/null 2>&1; then
    echo -e "${GREEN}✅ ALB trouvé${NC}"
    
    # Obtenir l'URL de l'ALB
    ALB_URL=$(aws elbv2 describe-load-balancers --names $ALB_NAME --query 'LoadBalancers[0].DNSName' --output text)
    echo -e "${BLUE}URL ALB: http://$ALB_URL${NC}"
    
    # Tester le health endpoint si l'ALB est accessible
    echo -e "${BLUE}4. Test du endpoint de santé...${NC}"
    if curl -f -s --max-time 10 "http://$ALB_URL/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Health endpoint accessible${NC}"
    else
        echo -e "${YELLOW}⚠️ Health endpoint non accessible (service peut être en cours de déploiement)${NC}"
    fi
    
    # Vérifier la santé des targets
    if TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names $TARGET_GROUP_NAME --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null); then
        echo -e "${BLUE}5. Statut des targets ALB :${NC}"
        aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN --output table
    fi
else
    echo -e "${YELLOW}⚠️ ALB non trouvé (normal si pas encore déployé)${NC}"
fi

echo -e "${BLUE}6. Validation de la configuration Terraform...${NC}"
cd terraform
if terraform validate > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Configuration Terraform valide${NC}"
else
    echo -e "${RED}❌ Configuration Terraform invalide${NC}"
    terraform validate
fi
cd ..

echo ""
echo -e "${GREEN}🎉 Test terminé !${NC}"
echo ""
echo "📝 Notes :"
echo "- Si l'infrastructure n'est pas encore déployée, certains tests échoueront normalement"
echo "- Après le déploiement, relancez ce script pour vérifier que tout fonctionne"
echo "- En cas de problème, consultez PIPELINE_IMPROVEMENTS.md pour plus de détails"
