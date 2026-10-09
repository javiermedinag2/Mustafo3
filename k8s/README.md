# GUÍA DE DESPLIEGUE EN KUBERNETES

## REQUISITOS PREVIOS
- Cluster Kubernetes ejecutándose (minikube, Docker Desktop, EKS, GKE, AKS, etc.)
- kubectl instalado y configurado
- Docker image del proyecto subida a un registro (Docker Hub, ECR, GCR, etc.)

## PASOS DE DESPLIEGUE

### 1. Preparar la imagen Docker
```bash
# Construir la imagen
docker build -t your-username/peniafiel:latest .

# Subir a Docker Hub (o tu registro)
docker push your-username/peniafiel:latest
```

### 2. Actualizar la imagen en el manifesto
Edita `k8s/08-flask-deployment.yaml` y reemplaza:
```yaml
image: your-registry/peniafiel:latest
```
Con tu imagen real, ej:
```yaml
image: docker.io/tu-usuario/peniafiel:latest
```

### 3. Aplicar los manifiestos
```bash
# Opción A: Aplicar todo de una vez
kubectl apply -f k8s/

# Opción B: Aplicar en orden
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-secret.yaml
kubectl apply -f k8s/02-configmap.yaml
kubectl apply -f k8s/03-pvc.yaml
kubectl apply -f k8s/04-mongodb-service.yaml
kubectl apply -f k8s/05-mongodb-deployment.yaml
kubectl apply -f k8s/06-flask-service.yaml
kubectl apply -f k8s/07-flask-configmap.yaml
kubectl apply -f k8s/08-flask-deployment.yaml
```

### 4. Verificar el despliegue
```bash
# Ver pods en ejecución
kubectl get pods

# Ver servicios
kubectl get svc

# Ver detalles de un pod
kubectl describe pod <pod-name>

# Ver logs
kubectl logs -f deployment/peniafiel
kubectl logs -f deployment/mongodb
```

### 5. Acceder a la aplicación
```bash
# Local (Port Forward)
kubectl port-forward svc/peniafiel 8080:80
# Accede a http://localhost:8080

# En cloud (LoadBalancer)
kubectl get svc peniafiel
# Obtiene la IP EXTERNA (puede tomar 2-5 minutos en la nube)
```

## VERIFICACIÓN DE SEGURIDAD
```bash
# Ver secrets
kubectl get secret mongodb-credentials -o yaml

# Ver configmaps
kubectl get configmap

# Ver PVC
kubectl get pvc

# Verificar contexto de seguridad
kubectl get pods -o jsonpath='{.items[0].spec.securityContext}'
```

## TROUBLESHOOTING

### Pod no inicia
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### MongoDB no conecta
```bash
# Verificar service DNS
kubectl exec -it <flask-pod> -- nslookup mongodb

# Verificar credentials
kubectl get secret mongodb-credentials -o yaml
```

### Limpiar todo
```bash
kubectl delete -f k8s/
# o específicamente:
kubectl delete namespace biblioteca
```

## NOTAS IMPORTANTES

1. **Credenciales**: Actualiza `k8s/01-secret.yaml` con contraseñas seguras ANTES de deployar en producción
2. **Imagen**: Asegúrate de que la imagen está en un registro accesible por tu cluster
3. **PVC**: El tamaño y tipo de storage depende de tu cluster (local, cloud, etc.)
4. **Replicas**: Puedes escalar con: `kubectl scale deployment peniafiel --replicas=3`
5. **Health Checks**: Los probes están configurados pero dependen de endpoints en tu app Flask
