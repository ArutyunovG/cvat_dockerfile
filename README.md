This little repo helps to make CVAT run inside docker, if for some reason you really need it.

It installs CVAT v2.2.0 and SAM model. By default, model is installed to be used by CPU, but you can change ```run.sh``` to install model for GPU. It is memory consuming.

Before using this sources, you are supposed to install <a href="https://docs.docker.com/engine/install/ubuntu/">docker</a> and <a href="https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html">NVIDIA Container Toolkit</a>.
<br>It is also assumed your ```$USER``` is added to the ```docker``` group.

When done with the setup, first build the image:

```
cd cvat_dockerfile
docker build .
```

Then start the container in privileged mode, exposing ```8080``` port and mounting volume called ```cvat_volume```:

```
docker run -it --privileged --gpus all -p 8080:8080 -v cvat_volume:/var <image_hash>
```
 replace ```<image_hash>``` with yours, see ```docker image ls```.

 Now we need to build whole CVAT and SAM stuff. To do that, first login using login ```root``` and password ```root``` and call in the container's terminal
 ```
.\run.sh
```
It's going to take some time. When done, you will have CVAT launched on port ```8080```, which, recall, was exposed to the host ```8080```.

Basically, you are done. You don't need to call ```run.sh``` anymore, since all the data will be stored now in ```cvat_volume``` on your host. Just don't forget to mount it. On next starts, when the volume ```cvat_volume``` is mounted, container will start automatically.

