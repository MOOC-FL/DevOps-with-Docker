#### Multi-host environments
- Now that we have mastered containers in small systems with Docker Compose it's time to look beyond what the tools we practiced are capable of. In situations where we have more than a single host machine we cannot rely solely on Docker. However, Docker does contain other tools to help us with automatic deployment, scaling and management of dockerized applications.

- In the scope of this course, we cannot go into how to use the tools introduced in this section, but leaving them without a mention would be a disservice.
- **Docker swarm** mode is built into Docker. It turns a pool of `Docker hosts` into a single virtual host. You can read the feature highlights here(opens in a new tab)(opens in a new tab). You can run it right away with docker swarm. Docker swarm mode is the lightest way of utilizing multiple hosts.
- **Kubernetes** is the de facto way of orchestrating your containers in large multi-host environments. The reason being it's customizability, large community and robust features. However, the drawback is the higher learning curve compared to Docker swarm mode. You can read their introduction here

> It is always good to remember that a single tool is rarely an optimal solution for all possible scenarios. In a 2-3 host environment for a hobby project, the gains from Kubernetes might not be as large compared to an environment where you need to orchestrate hundreds of hosts with multiple containers each.

- You can get to know Kubernetes with k3s(opens in a new tab)(opens in a new tab) a lightweight Kubernetes distribution that you can run inside containers with k3d(opens in a new tab)(opens in a new tab). Another similar solution is kind(opens in a new tab)(opens in a new tab). These are a great way to get started as you don't have to worry about complicated setup or any credit limits that the cloud providers always have.
> We have also the course DevOps with Kubernetes available until end of January 2026 and starting again in summer 2026!
- Rather than maintaining a cluster yourself, the most common way to use Kubernetes is by using a managed service by a cloud provider. Such as **Google Kubernetes Engine (GKE)** or **Amazon Elastic** or **Kubernetes Service (Amazon EKS)**, which are both offering some credits to get started.

