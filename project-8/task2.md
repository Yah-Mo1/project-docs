# 🐳 **Breaking Down a Docker Compose Configuration** 🚀

Let's **analyze** this `docker-compose.yml` configuration to understand how it works. 👇

---

## **🔹 Services Section (Defining Containers)**

The `services` section defines **two containers**:

### **1️⃣ Web Service (`web`)**

This is the **main application container** running from a pre-built image:

```yaml
image: yah3i94/testapp:app
```

🔹 **Key Configurations:**  
✅ **`image:`** Specifies the pre-built Docker image (`yah3i94/testapp:app`) to be used.  
✅ **`ports:`** Maps port `3000` on the host to port `3000` inside the container.  
✅ **`depends_on:`** Ensures that the `mongodb` service starts before `web`.  
✅ **`environment:`** Sets the database connection string as an **environment variable** (`DB_HOST`).  
✅ **`networks:`** Connects this service to the `node-network` bridge network.

---

### **2️⃣ Database Service (`mongodb`)**

This is the **MongoDB database container**:

```yaml
image: mongo:6-jammy
```

🔹 **Key Configurations:**  
✅ **`image:`** Uses the official MongoDB image (`mongo:6-jammy`).  
✅ **`ports:`** Exposes MongoDB on port `27017` for external access.  
✅ **`networks:`** Connects to the **same network** (`node-network`) as the `web` service.

---

## **🔹 Networks Section (Connecting Services)**

```yaml
networks:
  node-network:
    driver: bridge
```

🔹 **What this does:**  
✅ Defines a **custom bridge network** (`node-network`).  
✅ Ensures **isolated** communication between the `web` and `mongodb` containers.  
✅ Allows containers to reference each other by **service name** (e.g., `mongodb`).

---

## **🚀 Summary**

1️⃣ **A web service (`web`)** runs from `yah3i94/testapp:app`, connects to MongoDB, and listens on port **3000**.  
2️⃣ **A MongoDB service (`mongodb`)** runs from `mongo:6-jammy` and listens on port **27017**.  
3️⃣ **A custom network (`node-network`)** ensures secure and isolated communication.

### 🏗 **To Run This Setup:**

```plaintext
docker-compose up -d
```

💡 **Now your app and database are running in separate containers, communicating seamlessly!** 🐳⚡
