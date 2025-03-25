# Kubernetes Architecture

## Cluster

A **cluster** is a collection of nodes that provide compute, memory, storage, and networking resources to run containerised applications.

## Nodes

A **node** is a single machine (virtual or physical) that runs **pods**. There are two main types:

- **Master Node (Control Plane Node)**: The command center that manages the entire cluster.
- **Worker Node**: Executes application workloads by running pods.

---

## Control Plane (Master Node)

The **control plane** is the brain of Kubernetes, responsible for maintaining the cluster’s desired state. It consists of several key components:

### **Kube API Server**

- The **entry point** for all administrative tasks.
- Exposes the Kubernetes API and processes requests.

### **etcd**

- A distributed key-value store that holds **all cluster data and state**.
- Acts as the **single source of truth** for the cluster.

### **Kube Controller Manager**

- Ensures that the actual state of the cluster matches the desired state.
- Manages controllers for nodes, replication, endpoints, and more.

### **Kube Scheduler**

- Assigns newly created pods to worker nodes based on **resource availability**.

### **Cloud Controller Manager** (For cloud-based Kubernetes)

- Integrates Kubernetes with **cloud provider APIs** (e.g., AWS, GCP, Azure).
- Manages cloud-specific operations such as **load balancing, storage, networking, and logging**.

---

## Worker Nodes

Worker nodes handle the **actual execution** of workloads in the cluster. Each worker node includes:

### **Kubelet**

- An agent that communicates with the control plane, ensuring that containers run as expected.

### **Kube Proxy**

- Manages **networking** within the cluster.
- Ensures **pods** can communicate across nodes via services and endpoints.

### **Pods**

- The **smallest deployable unit** in Kubernetes.
- A pod acts as a **wrapper around containers**, enabling their deployment and management.
- A **pod can contain one or more containers**.

---

### Summary

- The **master node (control plane)** determines **what** runs and **where**.
- The **worker nodes** execute workloads, handling **how** applications run.

![alt text](../images/k8s-architecture.png)
