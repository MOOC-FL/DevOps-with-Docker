
### **1. ENTRYPOINT /bin/ping -c 3 (shell form)**  
   **CMD localhost (shell form)**  
   **Result:** `/bin/sh -c '/bin/ping -c 3' /bin/sh -c localhost`

**Explanation:**  
- **ENTRYPOINT in shell form** runs inside a `/bin/sh -c` shell. Everything after `ENTRYPOINT` becomes a single string argument to `sh -c`.  
- **CMD in shell form** also runs inside a `/bin/sh -c` shell.  
- Docker's rule: When ENTRYPOINT is in shell form, **CMD is ignored entirely**. The shell running ENTRYPOINT becomes PID 1.  
- Here, the `CMD` string `localhost` is actually passed as an **argument to the shell** running ENTRYPOINT (i.e., as `$0` for the ENTRYPOINT's shell), not to `ping`. That's why you see `/bin/sh -c localhost` appended oddly.  
- **This is broken** — `localhost` is not passed to `ping` at all.

---

### **2. ENTRYPOINT ["/bin/ping","-c","3"] (exec form)**  
   **CMD localhost (shell form)**  
   **Result:** `/bin/ping -c 3 /bin/sh -c localhost`

**Explanation:**  
- **ENTRYPOINT in exec form** runs directly, no shell wrapper.  
- **CMD in shell form** is evaluated by Docker as: it runs `/bin/sh -c "localhost"`. But when CMD is used with ENTRYPOINT in exec form, the CMD value is **passed as arguments to ENTRYPOINT**.  
- So `localhost` isn't run as a command; instead, the *string* `/bin/sh -c localhost` becomes the argument to `ping`.  
- This means `ping` receives the argument `/bin/sh -c localhost` as the hostname → fails.

---

### **3. ENTRYPOINT /bin/ping -c 3 (shell form)**  
   **CMD ["localhost"] (exec form)**  
   **Result:** `/bin/sh -c '/bin/ping -c 3' localhost`

**Explanation:**  
- **ENTRYPOINT in shell form** runs inside `/bin/sh -c`.  
- **CMD in exec form** `["localhost"]` is passed as arguments to the ENTRYPOINT's shell (as `$0`, `$1`, etc.), not to `ping`.  
- Here, `localhost` becomes `$0` of the ENTRYPOINT's shell instance, still **not passed to `ping`**.  
- The ping command runs as `/bin/ping -c 3` with no host argument. Broken.

---

### **4. ENTRYPOINT ["/bin/ping","-c","3"] (exec form)**  
   **CMD ["localhost"] (exec form)**  
   **Result:** `/bin/ping -c 3 localhost`

**Explanation:**  
- **ENTRYPOINT in exec form** → Docker runs `/bin/ping -c 3`.  
- **CMD in exec form** → Docker passes `localhost` as an additional argument to ENTRYPOINT.  
- This is the **correct, predictable behavior**: ENTRYPOINT defines the main command, CMD provides default arguments that can be overridden at runtime.  
- Final command: `/bin/ping -c 3 localhost`

---

### **Key Takeaways:**

1. **Use exec form for both ENTRYPOINT and CMD** for predictable behavior (JSON array syntax).  
2. **Shell form ENTRYPOINT** ignores CMD and runs without PID 1 signal handling (bad for containers).  
3. **CMD in shell form** with exec-form ENTRYPOINT results in the shell command string being passed as an argument (usually wrong).  
4. **Best practice:**  
   ```dockerfile
   ENTRYPOINT ["/bin/ping", "-c", "3"]
   CMD ["localhost"]
   ```
   This allows overriding the host at runtime:  
   ```bash
   docker run myimage 8.8.8.8
   ```
