#### Deployment pipelines
- CI/CD(opens in a new tab)(opens in a new tab) pipeline (sometimes called deployment pipeline) is a corner stone of DevOps. According to Gitlab(opens in a new tab)(opens in a new tab):
  > CI/CD automates much or all of the manual human intervention traditionally needed to get new code from a commit into production.
  > 
  > With a CI/CD pipeline, development teams can make changes to code that are then automatically tested and pushed out for delivery and deployment. Get CI/CD right and downtime is minimized and code releases happen faster.


- Let us now see how one can set up a deployment pipeline that can be used to automatically deploy containerized software to any machine. So every time you commit the code in your machine, the pipeline builds the image and starts it up in the server.

- Since we cannot assume that everyone has access to their own server, we will demonstrate the pipeline using a local machine as the development target, but the exact same steps can be used for a virtual machine in the cloud (such as one provided by Hetzner(opens in a new tab)(opens in a new tab)) or even Raspberry Pi.
- We will use GitHub Actions(opens in a new tab)(opens in a new tab) to build an image and push the image to Docker Hub, and then use a project called Watchtower(opens in a new tab)(opens in a new tab) to automatically pull and restart the new image in the target machine.
- As an example, we will look repository https://github.com/mluukkai/beermapping(opens in a new tab)(opens in a new tab) that contains a simple containerized Node.js application.
- As was said GitHub Actions(opens in a new tab)(opens in a new tab) is used to implement the first part of the deployment pipeline. The documentation(opens in a new tab)(opens in a new tab) gives the following overview:
