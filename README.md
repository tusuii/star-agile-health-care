# Medicure Healthcare Application

![Medicure Logo](https://raw.githubusercontent.com/tusuii/star-agile-health-care/master/star-agile-health-care/src/main/resources/static/images/logo.png)

## Project Overview

Medicure is a comprehensive healthcare management application built with Spring Boot. It provides a platform for patients to access healthcare services, book appointments, and interact with healthcare providers. The application is containerized and deployed on Kubernetes with monitoring capabilities through Prometheus and Grafana.

## Features

- Patient registration and management
- Healthcare provider directory
- Appointment scheduling
- Responsive web interface
- RESTful API for integration with other systems
- Metrics monitoring with Prometheus and Grafana dashboards

## Technology Stack

- **Backend**: Java 8, Spring Boot 2.7.4
- **Database**: H2 (in-memory database)
- **Build Tool**: Maven
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Monitoring**: Prometheus, Grafana
- **CI/CD**: Jenkins (optional)

## Project Structure

```
star-agile-health-care/
├── Dockerfile                 # Docker image configuration
├── k8s-configs/               # Kubernetes and monitoring configurations
│   ├── dashboards/            # Grafana dashboards
│   ├── deployment.yml         # Kubernetes deployment configuration
│   ├── service.yml            # Kubernetes service configuration
│   ├── servicemonitor.yaml    # Prometheus ServiceMonitor
│   ├── prometheus-config.yaml # Prometheus configuration
│   └── grafana-values.yaml    # Grafana configuration
├── pom.xml                    # Maven dependencies and build configuration
└── src/                       # Application source code
```

## Prerequisites

- Docker
- Kubernetes cluster (Minikube, kind, or cloud provider)
- kubectl
- Helm (for Prometheus and Grafana installation)
- Java 8 or higher (for local development)
- Maven (for local development)

## Getting Started

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/tusuii/star-agile-health-care.git
   cd star-agile-health-care
   ```

2. Build the application:
   ```bash
   ./mvnw clean package
   ```

3. Run the application:
   ```bash
   ./mvnw spring-boot:run
   ```

4. Access the application at http://localhost:8082

### Kubernetes Deployment

#### 1. Build and Push Docker Image

```bash
# Build the Docker image
docker build -t subkamble/medicure:latest .

# Push to Docker Hub (if you want to use your own image, replace with your Docker Hub username)
docker push subkamble/medicure:latest
```

#### 2. Deploy to Kubernetes

```bash
# Apply Kubernetes configurations
kubectl apply -f k8s-configs/deployment.yml
kubectl apply -f k8s-configs/service.yml
```

#### 3. Verify Deployment

```bash
# Check if pods are running
kubectl get pods

# Check if service is created
kubectl get svc healthcare-app-service
```

#### 4. Access the Application

For Minikube:
```bash
# Get Minikube IP
minikube ip

# Access the application at http://<minikube-ip>:30080
```

For other Kubernetes clusters, access the application using the NodePort (30080) or the LoadBalancer IP if configured.

### Setting Up Monitoring

#### 1. Install Prometheus and Grafana using Helm

```bash
# Add Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack (includes Prometheus, Grafana, and Prometheus Operator)
helm install prometheus prometheus-community/kube-prometheus-stack -f k8s-configs/prometheus-values.yaml
```

#### 2. Configure Grafana Dashboard

```bash
# Create ConfigMap for Grafana dashboard
kubectl create configmap grafana-dashboards --from-file=k8s-configs/dashboards/spring-boot-dashboard.json

# Apply Grafana configuration
kubectl apply -f k8s-configs/grafana-values.yaml
```

#### 3. Access Grafana

```bash
# Get Grafana service details
kubectl get svc grafana

# Access Grafana at http://<kubernetes-ip>:30092
# Default credentials: admin/admin123
```

## API Endpoints

- `GET /patients` - List all patients
- `GET /patients/{id}` - Get patient by ID
- `POST /patients` - Create a new patient
- `PUT /patients/{id}` - Update a patient
- `DELETE /patients/{id}` - Delete a patient

## Troubleshooting

### Common Issues

1. **Application not accessible**:
   - Verify pods are running: `kubectl get pods`
   - Check service configuration: `kubectl describe svc healthcare-app-service`
   - Ensure NodePort is accessible from your network

2. **Grafana shows "Origin not allowed" error**:
   - Update Grafana ConfigMap with correct CORS settings:
     ```yaml
     [security]
     allow_embedding = true
     ```
   - Restart Grafana pod: `kubectl delete pod -l "app.kubernetes.io/name=grafana"`

3. **Prometheus not scraping metrics**:
   - Verify ServiceMonitor is correctly configured
   - Check if application exposes `/actuator/prometheus` endpoint
   - Inspect Prometheus targets in Grafana

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Star Agile for project guidance
- Spring Boot community for the excellent framework
- Kubernetes community for container orchestration
- Prometheus and Grafana teams for monitoring tools
