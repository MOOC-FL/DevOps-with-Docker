#### Select a page in the chapter
1. Definitions and basic concepts
2. Running and stopping containers
3. In-depth dive into images
4. Defining start conditions for the container
5. Interacting with the container via volumes and ports
6. Utilizing tools from the Registry
7. Summary

#### This chapter introduces containerization with Docker and relevant concepts such as image and volume. By the end of this chapter you are able to:

- Run containerized applications
- Containerize applications
- Utilize volumes to store data persistently outside of the containers.
- Use port mapping to enable access via TCP to containerized applications
- Share your own containers publicly

#### Summary
- We started by learning what Docker container and image mean. Basically we started from an empty ubuntu with nothing installed into it. It's also possible to start from something else, but for now ubuntu had been enough.
- This meant that we had to install almost everything manually, either from the command line or by using a setup file "Dockerfile" to install whatever we needed for the task at hand.
- The process of dockerizing the applications meant a bit of configuration on our part, but now that we've done it and built the image anyone can pick up and run the application; no possible dependency or versioning issues.
- Understanding the architecture and the technologies used is also part of making correct choices with the setup. This lead us to read the READMEs and documentation of the software involved in the setup, not just Docker. Fortunately in real life it's often us who are developing and creating the Dockerfile.
- The starting and stopping of containers is a bit annoying, not to mention running two applications simultaneously. Continue to the next chapter to learn a handy tool to make these things a lot simpler!

