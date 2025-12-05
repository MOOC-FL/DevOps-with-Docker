#### Virtual machines​
- Isn't there already a solution for this? Virtual Machines are not the same as Containers - they solve different problems. We will not be looking into Virtual Machines in this course. However, here's a diagram to give you a rough idea of the difference.
- Virtual Machines (VMs) run on a hypervisor(opens in a new tab)(opens in a new tab), which virtualizes the physical hardware. Each VM includes a full operating system (OS) along with the necessary binaries and libraries, making them heavier and more resource-intensive. Containers, on the other hand, share the host OS kernel and only package the application and its dependencies, resulting in a more lightweight and efficient solution.
- - VMs provide strong isolation and are suited for running multiple OS environments, but they have a performance overhead and longer startup times. Containers offer faster startup, better resource utilization, and high portability across different environments, though their isolation is at the process level, which may not be as robust as that of VMs. Overall, VMs could be used for scenarios needing complete OS environments, while containers excel in lightweight, efficient, and consistent application deployment.
-- Docker relies on Linux kernels, which means that macOS and Windows cannot run Docker natively without some additional steps. Each operating system has its own solution for running Docker. For example, Docker for Mac actually uses a Linux virtual machine under the hood, within which Docker operates.


#### **Architectural Diagram**

```
┌─────────────────────────────────┐ ┌─────────────────────────────────┐
│      VIRTUAL MACHINE            │ │         CONTAINER              │
│                                 │ │                                 │
│ ┌─────────────────────────────┐ │ │ ┌─────────────────────────────┐ │
│ │        App 1                │ │ │ │        App 1                │ │
│ ├─────────────────────────────┤ │ │ ├─────────────────────────────┤ │
│ │        App 2                │ │ │ │        App 2                │ │
│ ├─────────────────────────────┤ │ │ ├─────────────────────────────┤ │
│ │     Bins/Libraries          │ │ │ │     Bins/Libraries          │ │
│ ├─────────────────────────────┤ │ │ ├─────────────────────────────┤ │
│ │    Guest OS (Full)          │ │ │ │        Container Engine     │ │
│ └─────────────────────────────┘ │ │ └─────────────────────────────┘ │
│                                 │ │                                 │
│ ┌─────────────────────────────┐ │ │                                 │
│ │      Hypervisor             │ │ │                                 │
│ │ (VMware, Hyper-V, KVM, etc)│ │ │                                 │
│ └─────────────────────────────┘ │ │                                 │
├─────────────────────────────────┤ ├─────────────────────────────────┤
│        Host Operating System    │ │        Host Operating System    │
├─────────────────────────────────┤ ├─────────────────────────────────┤
│        Hardware (Server)        │
