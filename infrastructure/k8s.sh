#!/bin/bash

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if command was successful
check_error() {
    if [ $? -ne 0 ]; then
        log "Error: $1"
        exit 1
    fi
}

# Function to setup master node
setup_master() {
    log "Setting up Kubernetes master node..."
    
    sudo su - root <<'EOF'
    wget https://raw.githubusercontent.com/akshu20791/Deployment-script/main/k8s-master.sh
    chmod 777 k8s-master.sh
    ./k8s-master.sh
    
    # Generate join token and save it
    JOIN_COMMAND=$(kubeadm token create --print-join-command)
    echo "${JOIN_COMMAND} --cri-socket unix:///var/run/cri-dockerd.sock" > /tmp/k8s_join_command.sh
    chmod +x /tmp/k8s_join_command.sh
EOF
    
    check_error "Failed to setup master node"
    log "Master node setup completed"
}

# Function to setup worker node
setup_worker() {
    log "Setting up Kubernetes worker node..."
    
    sudo su - root <<'EOF'
    wget https://raw.githubusercontent.com/akshu20791/Deployment-script/main/k8s-nodes.sh
    chmod 777 k8s-nodes.sh
    ./k8s-nodes.sh
    
    # Configure networking
    modprobe br_netfilter
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
    echo 1 > /proc/sys/net/ipv4/ip_forward
EOF
    
    check_error "Failed to setup worker node"
    log "Worker node setup completed"
}

# Main script
case "$1" in
    "master")
        setup_master
        ;;
    "worker")
        setup_worker
        ;;
    *)
        echo "Usage: $0 {master|worker}"
        echo "Example:"
        echo "  For master node: $0 master"
        echo "  For worker node: $0 worker"
        exit 1
        ;;
esac

log "Script execution completed successfully"
