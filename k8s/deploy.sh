#!/bin/bash

# Script de despliegue automatizado para Kubernetes

set -e  # Detener si hay error

echo "===== DESPLIEGUE EN KUBERNETES ====="

# Verificar herramientas
if ! command -v kubectl &> /dev/null; then
    echo "ERROR: kubectl no está instalado"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "ERROR: docker no está instalado"
    exit 1
fi

echo "[1/5] Construyendo imagen Docker..."
DOCKER_USERNAME=${1:-tu-usuario}
IMAGE_NAME="$DOCKER_USERNAME/peniafiel:latest"

docker build -t "$IMAGE_NAME" .

echo "[2/5] Subiendo imagen a Docker Hub..."
docker push "$IMAGE_NAME" || echo "Advertencia: No se pudo subir la imagen. Verifica credenciales."

echo "[3/5] Creando namespace..."
kubectl apply -f k8s/00-namespace.yaml || true

echo "[4/5] Aplicando manifiestos de Kubernetes..."
kubectl apply -f k8s/01-secret.yaml
kubectl apply -f k8s/02-configmap.yaml
kubectl apply -f k8s/03-pvc.yaml
kubectl apply -f k8s/04-mongodb-service.yaml
kubectl apply -f k8s/05-mongodb-deployment.yaml

# Esperar a que MongoDB esté listo
echo "[5/5] Esperando a que MongoDB esté disponible (esto puede tardar 30 segundos)..."
kubectl wait --for=condition=ready pod -l app=mongodb --timeout=60s

kubectl apply -f k8s/06-flask-service.yaml
kubectl apply -f k8s/07-flask-configmap.yaml

# Actualizar imagen en deployment
kubectl set image deployment/peniafiel peniafiel="$IMAGE_NAME" --record 2>/dev/null || \
  kubectl create deployment peniafiel --image="$IMAGE_NAME" 2>/dev/null || true

kubectl apply -f k8s/08-flask-deployment.yaml

echo "======================================"
echo "✓ Despliegue completado"
echo ""
echo "Para verificar el estado:"
echo "  kubectl get pods"
echo "  kubectl get svc"
echo ""
echo "Para acceder a la aplicación (port-forward):"
echo "  kubectl port-forward svc/peniafiel 8080:80"
echo "  Accede a: http://localhost:8080"
echo ""
echo "Para ver logs:"
echo "  kubectl logs -f deployment/peniafiel"
echo "  kubectl logs -f deployment/mongodb"
