# Tech501 App VM Deployment Guide

This guide outlines the steps to deploy a dedicated App Virtual Machine in our cloud environment.

---

## 1. VM Naming Convention

- **Pattern:** `tech501-<yourname>-sparta-app-vm`
- **Note:** Replace `<yourname>` with your unique identifier to ensure the VM name is distinct.

---

## 2. Operating System Image

- **Image:** **Ubuntu 22.04 LTS**
  - Chosen for its stability and long-term support, making it ideal for database workloads.
  - Ensure you select this image during the VM provisioning process on your cloud platform (Azure, AWS, or Google Cloud).

---

## 3. VM Sizing

- **Standard Configuration:** Use the organization’s default VM size.
  - _Example:_ 2 vCPUs and 4 GB RAM.
- **Goal:** Ensure sufficient performance for database operations while allowing for future scalability.

---

## 4. Network Security Configuration

- **Network Security Group (NSG) Setup:**
  - **Allow SSH Access:**
    - **Priority:** 100 (lower numbers indicate higher priority)
    - **Port:** 22 (TCP), 80 (HTTP)
    - **Source:** Any (or restrict to specific IP ranges for enhanced security)
    - **Action:** Allow
- **Reminder:** Verify that the NSG is attached to the VM’s network interface.

---

## 5. Public IP Assignment

- **Purpose:** Enable remote management and, if needed, database access.
  - **Steps:**
    - Assign a Public IP to the VM.

---

## 6. Virtual Network (VNet) Placement

- **VNet:** Deploy the VM in the pre-configured **2-net** Virtual Network.
- **Subnet:** Use the **PUBLIC-subnet**

---

### **Preparing a Generalized Image**

1. **Document Installation Commands**

   - Document all commands used to install dependencies in a file for future reference.

2. **Move App to Root Directory**

   - Move your app to the root directory under `/repo/app`:
     ```bash
     sudo mkdir -p /repo/app
     sudo mv /home/adminuser/<app-folder>/* /repo/app/
     ```

3. **Wipe User Data**

   - Use the `waagent` command to prepare the VM:
     ```bash
     sudo waagent -deprovision+user
     ```

4. **Create the Image**

   - In Azure, create an image with the name:  
     `tech501-yahya-sparta-app-ready-to-run-img`
   - If you receive a "Plan information" error, delete the VM and create a new one using the image:  
     `yahya-official-ubuntu2204-clean-image` in the `tech501` resource group.

5. **Test the Image**
   - Create a new VM from the image, log in, and test the app:
     ```bash
     cd /repo/app
     npm install
     npm start
     ```

---
