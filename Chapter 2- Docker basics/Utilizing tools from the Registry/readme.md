#### Utilizing tools from the Registry
- As we have already seen it should be possible to containerize almost any project. Since we are in between Dev and Ops, let's pretend that some developer teammates of ours made an application with a README that instructs what to install and how to run the application. Now we as the container experts can containerize it in seconds.

> Open this https://github.com/docker-hy/material-applications/tree/main/rails-example-project(opens in a new tab)(opens in a new tab) project, and read through the README and think about how to transform it into a Dockerfile. Thanks to the README we should be able to decipher what we will need to do even if we have no clue about the language or technology!

- We will need to clone the repository(opens in a new tab)(opens in a new tab), which you may have already done. After that is done, let's start with a Dockerfile. We know that we need to install Ruby and whatever dependencies it has. Let's place the Dockerfile in the project root.
