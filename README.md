# OpenWebUI Docker Automation

## 🚀 Overview  
This repository contains automation scripts for managing **OpenWebUI and pipeline components** using Docker. It simplifies updates, resets, and ensures containers are healthy, especially for self-hosted setups like NAS environments.  

## 🛠️ What is OpenWebUI Docker Automation?  
OpenWebUI Docker Automation is a set of **bash scripts** designed to **simplify self-hosting and container management** for OpenWebUI. If you're running OpenWebUI on a **NAS** and using Ollama on a **separate GPU-powered machine**, this project provides essential automation to keep everything updated and running smoothly.  

### 🚀 Why Use These Scripts?  
Managing Docker containers manually can be time-consuming. These scripts allow you to:  
- **Automatically update OpenWebUI** with the latest image.  
- **Effortlessly reset and redeploy pipeline containers** without lingering conflicts.  
- **Run health checks** to ensure proper functionality after updates.  
- **Optimize container deployment** for NAS-hosted environments.  

## 🌐 Deployment Context  
This setup assumes **OpenWebUI is running on a NAS**, while **Ollama is hosted separately on a computer with a GPU** for optimized performance.  
Users can modify environment variables like `OLLAMA_BASE_URL` to point to their specific setup.  
---

## ⚙️ Scripts

### **1️⃣ update_openwebui.sh**

This script **updates and restarts the OpenWebUI container** in Docker. It performs these actions:

1.  **Pulls the latest OpenWebUI image** from GitHub Container Registry.
    
2.  **Stops and removes** the existing container.
    
3.  **Starts a new container** with configured environment variables.
    
4.  **Runs a health check** to ensure the service is running.
    

#### 🔹 Variables in `update_openwebui.sh`

| Variable        | Description |
|----------------|-------------|
| `CONTAINER_NAME`  | Name of the OpenWebUI container in Docker (`open-webui`). |
| `IMAGE_NAME`  | Repository path for OpenWebUI’s latest image (`ghcr.io/open-webui/open-webui:main`). |
| `HOST_PORT`  | External port for OpenWebUI (**default is 3000**, but modified in this setup). |
| `CONTAINER_PORT`  | Internal container port (**default 3000** in OpenWebUI). |
| `OLLAMA_BASE_URL`  | API base URL used by OpenWebUI (customizable). |
| `VOLUME_NAME`  | Persistent volume for storing backend data. |
| `LOG_FILE`  | Log file to track script execution steps. |

---
### **2️⃣ reset_pipelines.sh**

This script **cleans and restarts the pipelines container**. It follows these steps:

1.  **Stops and removes** the pipelines container.
    
2.  **Deletes the old image** to avoid conflicts.
    
3.  **Removes old storage volume** for a clean install.
    
4.  **Pulls the latest pipelines image** and deploys a new container.
    
5.  **Performs a verification check** to confirm proper deployment.
    
---
#### 🔹 Variables in `reset_pipelines.sh`

| Variable        | Description |
|----------------|-------------|
| `CONTAINER_NAME`  | Name of the pipelines container in Docker (`pipelines`). |
| `IMAGE_NAME`  | Repository path for pipelines image (`ghcr.io/open-webui/pipelines:main`). |
| `HOST_PORT`  | External port used for pipelines (**default 9099**). |
| `CONTAINER_PORT`  | Internal port used by pipelines (**default 9099**). |
| `PIPELINES_VOLUME`  | Name of the volume where pipeline data is stored. |
| `CUSTOM_PIPELINES_URL`  | Optional URL for custom pipeline scripts (default is empty). |
| `DB_PORT`  | PostgreSQL database port (**default 5432**). |
| `PIPELINES_REQUIREMENTS_PATH`  | Path to pipeline dependencies in the container (`/app/pipelines/requirements.txt`). |
---
## 🛠️ Installation & Usage

Make scripts executable and run:

sh

```
chmod +x update_openwebui.sh  
./update_openwebui.sh  

```

sh

```
chmod +x reset_pipelines.sh  
./reset_pipelines.sh  

```
---
## 📝 Configuration

Modify these variables in scripts as needed:

-   **OpenWebUI port:** The default is **3000**, but it was changed due to conflicts.
    
-   **NAS compatibility:** Works well in NAS setups but can be used elsewhere.
    
-   **Switching to Bash:** Scripts use `sh`, but you can adapt them to `bash`.
    

## ⚠️ Notes

-   Check logs if issues arise:
    
    sh
    
    ```
    docker logs open-webui  
    
    ```
    
-   If you need custom pipelines, define `CUSTOM_PIPELINES_URL`.
    
-   Volume cleanup ensures fresh deployments—back up your data if necessary.
    

## 🏗️ Contributions

Suggestions and improvements are welcome! If you extend these scripts for **custom OpenWebUI use cases**, feel free to share.
