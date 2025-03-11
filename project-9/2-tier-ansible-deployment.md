## **📌 Project Documentation: Ansible-Based Deployment of a Node.js App with MongoDB**

### **Overview**

This documentation outlines the process of using **Ansible** to automate the deployment of a **Node.js application** running in the background using **PM2**, with a **MongoDB database** hosted on a separate VM. It includes troubleshooting and best practices for managing the infrastructure efficiently.

---

## **1️⃣ Setting Up Ansible on the Controller VM**

### **🔹 Steps**

1. **Create an Ansible Controller EC2 Instance** (Ubuntu 22.04).
2. **Install Ansible**:
   ```sh
   sudo apt update && sudo apt install -y ansible
   ```
3. **Ensure SSH Access to Target Nodes**:
   - Copy the **SSH private key** into the controller’s `~/.ssh/` directory.
   - Set appropriate permissions:
     ```sh
     chmod 400 ~/.ssh/your-key.pem
     ```
4. **Edit the Ansible Hosts File** (`/etc/ansible/hosts`):

   ```ini
   [web]
   app-instance ansible_host=<APP_INSTANCE_PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem

   [db]
   db-instance ansible_host=<DB_INSTANCE_PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
   ```

---

## **2️⃣ Provisioning the App Server (`prov_app_with_pm2.yml`)**

### **🔹 Goal:** Install Node.js, clone the app, configure environment variables, and run the app using PM2.

#### **📝 Playbook: `prov_app_with_pm2.yml`**

```yaml
---
- name: Install app dependencies and run app with PM2
  hosts: web
  gather_facts: yes
  become: yes

  tasks:
    - name: Install dependencies
      apt:
        name:
          - nodejs
          - npm
          - git
        state: present
        update_cache: yes

    - name: Clone the app repository
      git:
        repo: "https://github.com/Yah-Mo1/test-app"
        dest: "/home/ubuntu/app"
        version: main

    - name: Install app dependencies
      command: npm install
      args:
        chdir: /home/ubuntu/app

    - name: Install PM2 globally
      npm:
        name: pm2
        global: yes
        state: present

    - name: Set DB_HOST environment variable permanently
      lineinfile:
        path: /etc/environment
        line: 'DB_HOST="mongodb://<DB_INSTANCE_PRIVATE_IP>:27017"'
        create: yes

    - name: Restart PM2 with updated environment
      shell: pm2 restart my-app --update-env
      args:
        chdir: /home/ubuntu/app
```

### **🔹 Run the Playbook**

```sh
ansible-playbook prov_app_with_pm2.yml
```

---

## **3️⃣ Provisioning the Database Server (`prov-db.yml`)**

### **🔹 Goal:** Install MongoDB 7.0, allow external connections, and ensure the service runs.

#### **📝 Playbook: `prov-db.yml`**

```yaml
---
- name: Provision Database VM
  hosts: db
  gather_facts: yes
  become: yes

  tasks:
    - name: Import MongoDB public key
      apt_key:
        url: "https://pgp.mongodb.com/server-7.0.asc"
        state: present

    - name: Add MongoDB repository
      apt_repository:
        repo: "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse"
        state: present
        filename: mongodb-org-7.0

    - name: Install MongoDB 7.0
      apt:
        name: mongodb-org
        state: present
        update_cache: yes

    - name: Configure MongoDB to allow external connections
      lineinfile:
        path: /etc/mongod.conf
        regexp: "^ *bindIp: 127.0.0.1"
        line: "  bindIp: 0.0.0.0"
        backrefs: yes

    - name: Restart and enable MongoDB service
      service:
        name: mongod
        state: restarted
        enabled: yes
```

### **🔹 Run the Playbook**

```sh
ansible-playbook prov-db.yml
```

---

## **4️⃣ Running Both Playbooks Together (`prov-app-all.yml`)**

### **🔹 Goal:** Deploy both **app** and **database** in a single run.

#### **📝 Playbook: `prov-app-all.yml`**

```yaml
---
- import_playbook: prov-db.yml
- import_playbook: prov_app_with_pm2.yml
```

### **🔹 Run the Combined Playbook**

```sh
ansible-playbook prov-app-all.yml
```

---

## **5️⃣ Testing & Troubleshooting**

### **🔹 Verify App is Running**

```sh
ansible web -m shell -a "pm2 list"
```

Expected output:

```
┌─────┬───────────┬────────┬───────┬───────┬────────┐
│ id  │ name      │ status │ cpu % │ mem % │ uptime │
├─────┼───────────┼────────┼───────┼───────┼────────┤
│ 0   │ my-app    │ online │ 0.1%  │ 50MB  │ 10s    │
└─────┴───────────┴────────┴───────┴───────┴────────┘
```

### **🔹 Test API Endpoint**

```sh
curl http://<APP_INSTANCE_PUBLIC_IP>:3000/posts
```

### **🔹 Check Database Connection**

```sh
ansible db -m shell -a "systemctl status mongod"
```

Expected output:

```
● mongod.service - MongoDB Database Server
   Active: active (running)
```

### **🔹 Ensure `DB_HOST` is Set on App VM**

```sh
ansible web -m shell -a "cat /etc/environment | grep DB_HOST"
```

---

## **6️⃣ Deploying to New VMs**

1. **Update the `hosts` file** with the new instance IPs.
2. **Run the full provisioning playbook**:
   ```sh
   ansible-playbook prov-app-all.yml
   ```

---

## **7️⃣ (Optional) Configure Nginx as Reverse Proxy**

### **📝 Add These Tasks to `prov_app_with_pm2.yml`**

```yaml
- name: Install Nginx
  apt:
    name: nginx
    state: present

- name: Configure Nginx for reverse proxy
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/sites-available/default

- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

### **📝 `nginx.conf.j2`**

```nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### **🔹 Restart Nginx**

```sh
sudo systemctl restart nginx
```

Now, your app should be accessible via:

```
http://<APP_INSTANCE_PUBLIC_IP>
```

---

## **📌 Conclusion**

✅ **Automated deployment of Node.js app using Ansible**  
✅ **Provisioned MongoDB database on a separate VM**  
✅ **Configured PM2 for process management**  
✅ **Ensured app and database communicate correctly**  
✅ **(Optional) Configured Nginx for reverse proxy**
