## docker-bb-launchpad-CXP5.6

Dockerfile that creates a functional version of BackBase launchpad CXP5.6 running on CentOS 6.x or 7.x. 
All dependencies are packaged in the same docker host so this is most targeted to development environments as good practices recommend that each process should be deployed in it's own docker container.

**Note:** Running this docker file requires access to a Backbase portal software which requires a license.

* Clone this project code.

* Make sure you have docker installed and configured.

* Build an image using this docker file:
`docker build -t mmaia/docker_bb_launchpad_cxp56:v0.1 . 

* Check if the new image is there: 

`docker images`

* Start the docker container for the first time(create and name the container):

`docker run -i -t -p 7777:7777 --name bb_portal_cxp56 mmaia/docker_bb_launchpad_cxp56:v0.1 /bin/bash`

after the first time you can jus start the created container using it's given name:


You should than be able to access localhost:7777/portalserver/cxp-manager



