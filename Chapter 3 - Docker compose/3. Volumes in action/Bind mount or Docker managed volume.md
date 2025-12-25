#### Bind mount or Docker managed volume
- The benefit of a bind mount is that since you know exactly where the data is in your file system, it is easy to create backups. If the Docker managed volumes are used, the location of the data in the file system can not be controlled and that makes backups a bit less trivial...

> Tips for making sure the backend connection works

In the next exercise try using your browser to access http://localhost/api/ping and see if it answers pong

If the request fails, it might be Nginx configuration problem. Ensure there is a trailing / on the backend URL as specified under the location /api/ context in the nginx.conf.
