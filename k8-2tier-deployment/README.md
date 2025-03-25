# 🧱 Two-Tier Application Deployment on Kubernetes (Node.js + MongoDB)

This project demonstrates how to deploy a production-style two-tier application using **Kubernetes**, consisting of:

- A **Node.js API** (`/` and `/posts` endpoints)
- A **MongoDB database** with persistent storage
- Full seeding support and service-based communication

---

## 📦 Application Overview

The application is built with:

- A Node.js backend that exposes two routes:
  - `/` — A simple landing page
  - `/posts` — Displays 100 randomly generated posts stored in MongoDB
- A `seed.js` script that seeds the `posts` collection in MongoDB
- MongoDB running as a container with persistent volume claims

---

## 📁 Project Structure (Kubernetes Manifests)

| File                      | Purpose                                 |
| ------------------------- | --------------------------------------- |
| `testapp-deployment.yaml` | Deploys the Node.js application         |
| `testapp-svc.yaml`        | Exposes the app using a NodePort        |
| `mongod-deployment.yaml`  | Deploys MongoDB with PVC + readiness    |
| `mongo-pv.yaml`           | Declares a PersistentVolume (hostPath)  |
| `mongo-pvc.yaml`          | PersistentVolumeClaim for Mongo         |
| `mongo-svc.yaml`          | Internal ClusterIP service for Mongo    |
| `mongo-seed-job.yaml`     | One-time Kubernetes Job to seed MongoDB |

---

## 🚀 Deployment Steps

### 🧱 1. Apply MongoDB Storage Resources

```bash
kubectl apply -f mongo-pv.yaml
kubectl apply -f mongo-pvc.yaml
```

```

```

✅ Ensure the PVC is **Bound**:

```bash
kubectl get pvc
```

---

### 🍃 2. Deploy MongoDB

```bash
kubectl apply -f mongod-deployment.yaml
kubectl apply -f mongo-svc.yaml
```

⚠️ Ensure MongoDB has a `readinessProbe` defined, so that the application waits until Mongo is fully ready.

---

### 🧑‍💻 3. Deploy the Node.js Application

```bash
kubectl apply -f testapp-deployment.yaml
kubectl apply -f testapp-svc.yaml
```

---

### 🌱 4. Seed the MongoDB Database

Run a one-time Job to insert the `posts` data into MongoDB:

```bash
kubectl apply -f mongo-seed-job.yaml
kubectl logs job/mongo-seed
```

🧼 Once seeding is successful, clean up the job:

```bash
kubectl delete job mongo-seed
```

---

### 🌐 5. Access the Application

To access the application locally:

```bash
kubectl port-forward svc/testapp-svc 8080:3000
```

Then open your browser and visit:

- [http://localhost:8080](http://localhost:8080) → Home page
- [http://localhost:8080/posts](http://localhost:8080/posts) → View seeded posts

---

## 🔧 Troubleshooting

### ❌ Mongo connection refused?

- Ensure MongoDB is running and the `mongod-svc` service is resolvable
- Use `initContainers` to delay app startup until Mongo is reachable
- Confirm that Mongo is listening on `0.0.0.0:27017`

### ❌ No data on `/posts`?

- Re-run the seed job to populate the database:
  ```bash
  kubectl apply -f mongo-seed-job.yaml
  ```

### ❌ PVC stuck in `Pending`?

- Make sure the `mongo-pv.yaml` exists and matches the `mongo-pvc.yaml` in storageClass and capacity

---

## ✅ Highlights

- Uses **ClusterIP** for internal MongoDB communication
- **Persistent storage** for MongoDB with `hostPath`
- **Database seeding** via Kubernetes Job
- **Port-forwarding** for local testing
- **Readiness probe** ensures app only starts when Mongo is ready
- Clean separation between **application and database tiers**
