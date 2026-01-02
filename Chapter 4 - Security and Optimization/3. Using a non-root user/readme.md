#### Using a non-root user
- Let's get back to the yt-dlp application, that we for last time worked with it
- The application could, in theory, escape the container due to a bug in Docker or Linux kernel. To mitigate this security issue we will add a non-root user to our container and run our process with that user. Another option would be to map the root user to a high, non-existing user id on the host with.
- 
