#### **Docker Image vs Container: The Complete Guide**

#### **Visual Analogy**

```
┌─────────────────────────────────────────────────────────────┐
│                    ANALOGY: BLUEPRINT vs HOUSE              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   IMAGE (Blueprint/Recipe)      │   CONTAINER (Running Instance) │
│                                 │                             │
│   📄 Dockerfile                 │   🏠 Running Application    │
│   📦 Immutable template         │   🔄 Live, changing state   │
│   📚 Stored in registry         │   🚀 Executing process      │
│   🏗️  Built once, used many times│   ⏱️  Temporary, ephemeral    │
│   📊 Multiple layers            │   💾 Has writable layer     │
│                                 │                             │
└─────────────────────────────────────────────────────────────┘
```

#### **Quick Summary Table**

| **Aspect** | **Docker Image** | **Docker Container** |
|------------|------------------|----------------------|
| **Nature** | Template/Blueprint | Running instance |
| **State** | Immutable, read-only | Mutable, read-write |
| **Storage** | Registry/Docker Hub | Host filesystem |
| **Lifespan** | Persistent | Ephemeral |
| **Layers** | Multiple read-only layers | Read-only layers + writable layer |
| **Creation** | `docker build` | `docker run` |
| **Purpose** | Define what will run | Actually run the application |

#### **Detailed Comparison**

#### **1. Definition & Purpose**

| **Image** | **Container** |
|-----------|---------------|
| **Definition**: A packaged application with all dependencies needed to run | **Definition**: A running instance of an image |
| **Purpose**: To be a portable, reusable template | **Purpose**: To execute the application in isolation |
| **Analogy**: A Class in OOP | **Analogy**: An Object instance of that class |
| **File Format**: Tarball with metadata | **Runtime State**: Processes + filesystem |

#### **2. Storage & Structure**

#### **Docker Image Structure (Layered)**
```
┌─────────────────────────────────┐
│      MyApp:latest (Image)       │
├─────────────────────────────────┤
│   Layer 4: App code changes     │  ← Your application changes
│           (+5MB)                │
├─────────────────────────────────┤
│   Layer 3: Install dependencies │  ← `RUN npm install`
│           (+150MB)              │
├─────────────────────────────────┤
│   Layer 2: Copy package.json    │  ← `COPY package.json`
│           (+1KB)                │
├─────────────────────────────────┤
│   Layer 1: Base OS (Alpine)     │  ← `FROM alpine:3.14`
│           (+5MB)                │
└─────────────────────────────────┘
Total Size: ~161MB (but layers are shared)
```

#### **Docker Container Structure**
```
┌─────────────────────────────────┐
│    Running Container            │
├─────────────────────────────────┤
│   Writable Layer (Container Layer) │  ← Unique to this container
│   • Log files                   │     (logs, temp files, data)
│   • Temporary files             │
│   • Application data           │
├─────────────────────────────────┤
│   Image Layers (Read-Only)      │  ← Shared with other containers
│   • Layer 4: App code           │     using same image
│   • Layer 3: Dependencies       │
│   • Layer 2: package.json       │
│   • Layer 1: Base OS           │
└─────────────────────────────────┘
```

#### **3. Lifecycle & Commands**

| **Stage** | **Image Commands** | **Container Commands** |
|-----------|--------------------|------------------------|
| **Create** | `docker build -t myapp .` | `docker run myapp` |
| **List** | `docker images` | `docker ps` (running) or `docker ps -a` (all) |
| **Inspect** | `docker image inspect myapp` | `docker container inspect <id>` |
| **Remove** | `docker rmi myapp` | `docker rm <container>` |
| **Stop/Start** | N/A (images aren't running) | `docker stop/start <container>` |

#### **4. Key Characteristics**

| **Characteristic** | **Image** | **Container** |
|-------------------|-----------|---------------|
| **Mutability** | Immutable (can't change) | Mutable (changes during runtime) |
| **Sharing** | Shareable via registries | Local to host (but state can be persisted) |
| **Size on Disk** | Stored once, shared | Minimal (just writable layer) |
| **Tagging** | Can have tags (v1.0, latest) | Has unique ID and optional name |
| **Portability** | Highly portable | Bound to host (but can be recreated anywhere) |

#### **Real-World Example: Web Application**

#### **Image Creation (Dockerfile)**
```dockerfile
# This creates an IMAGE
FROM node:14-alpine          # ← Base image layer
WORKDIR /app                 # ← Layer 2
COPY package*.json ./        # ← Layer 3
RUN npm install              # ← Layer 4 (big layer!)
COPY . .                     # ← Layer 5
EXPOSE 3000                  # ← Metadata
CMD ["npm", "start"]         # ← Metadata
```

Build the image:
```bash
docker build -t my-web-app:1.0 .
# Creates: my-web-app:1.0 (IMAGE)
```

### **Container Creation & Management**
```bash
# Create and run a CONTAINER from the image
docker run -d --name web1 -
