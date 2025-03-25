# 📦 Common Kubernetes Objects

## 🚀 Overview

Kubernetes manages workloads using **objects**, which define how applications **run, scale, and interact**. These objects ensure **reliability, automation, and efficiency** in containerized environments.

---

## 🔹 **1. Pods (Basic Unit of Deployment)**

✅ The **smallest deployable unit** in Kubernetes.  
✅ Can contain **one or more containers** sharing resources (storage, network).  
✅ **Ephemeral** – replaced when deleted or failed.

---

## 🔹 **2. ReplicaSets (Ensuring Availability)**

✅ Ensures a **specified number of pod replicas** are always running.  
✅ Replaces failed pods automatically.  
✅ Used within **Deployments** to manage updates.

---

## 🔹 **3. Deployments (Managing App Lifecycle)**

✅ Manages **rolling updates & rollbacks** for applications.  
✅ Ensures a **desired number of pods** are always running.  
✅ Uses **ReplicaSets** for version control and scaling.

---

## 🔹 **4. Services (Networking & Load Balancing)**

✅ Provides **stable networking** for pods.  
✅ Supports **internal (ClusterIP) and external (LoadBalancer, NodePort) traffic routing**.  
✅ Load balances traffic between pod instances.

---

## 🔹 **5. ConfigMaps & Secrets (Managing Configuration & Security)**

✅ **ConfigMaps:** Stores **non-sensitive** app configuration values (e.g., environment variables).  
✅ **Secrets:** Stores **sensitive data** like API keys, passwords (encrypted storage).

---

## 🔹 **6. Persistent Volumes (Storage Management)**

✅ Provides **persistent storage** for stateful applications.  
✅ Ensures data persists even if a pod is deleted or rescheduled.

---

## 🎯 **Conclusion**

Kubernetes objects define **how applications run, scale, and communicate**, ensuring **resilience, automation, and efficiency** in cloud-native environments. 🚀
