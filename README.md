<h1><a name="readme-top"></a></h1>

[![PSScriptAnalyzer](https://github.com/marcossilvestrini/learning-docker/actions/workflows/powershell.yml/badge.svg)](https://github.com/marcossilvestrini/learning-docker/actions/workflows/powershell.yml)
[![Release](https://github.com/marcossilvestrini/learning-docker/actions/workflows/release.yml/badge.svg)](https://github.com/marcossilvestrini/learning-docker/actions/workflows/release.yml)
[![Check Docker App](https://github.com/marcossilvestrini/learning-docker/actions/workflows/check-docker-app.yml/badge.svg)](https://github.com/marcossilvestrini/learning-docker/actions/workflows/check-docker-app.yml)

[![MIT License][license-shield]][license-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Contributors][contributors-shield]][contributors-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

# LEARNING Docker

![Docker](images/docker.jpg)

<p align="center">
<strong>Explore the docs »</strong></a><br />
    <a href="https://marcossilvestrini.github.io/learning-docker/">Main Page</a>
    -
    <a href="https://github.com/marcossilvestrini/learning-docker">Code Page</a>
    -
    <a href="https://github.com/marcossilvestrini/learning-docker/issues">Report Bug</a>
    -
    <a href="https://github.com/marcossilvestrini/learning-docker/issues">Request Feature</a>
</p>

## Summary

<details>
  <summary><b>TABLE OF CONTENT</b></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#docker-containers">Docker Containers</a></li>
    <li><a href="#docker-images">Docker Images</a></li>
    <li><a href="#docker-volumes">Docker Volumes</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details><br>

<a name="about-the-project"></a>

## About Project

>This project aims to help students or professionals to learn the main concepts of Docker

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<a name="getting-started"></a>

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

<a name="prerequisites"></a>

### Prerequisites

This is an example of how to list things you need to use the software
and how to install them.

* git
* Virtual Box and extension
* Vagrant

<a name="installation"></a>

### Installation

Clone the repo

```sh
git clone https://github.com/marcossilvestrini/learning-docker.git
```

<a name="usage"></a>

## Usage

Use this repository for get learning about Docker exam

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<a name="roadmap"></a>

## Roadmap

* [x] Create repository
* [ ] Create github action for automation tasks
* [x] Create examples about docker containers
* [x] Create examples about docker images

<p align="right">(<a href="#roadmap">back to roadmap</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

>Docker Engine work with namespaces(PID,NET,IPC,MNT,UTS) and cgroups.

```sh
# Get a version of docker
docker --version
```

## Docker Containers

<a name="docker-containers"></a>

```sh
# list containers
docker container ls
docker ps

# list containers id
docker container ls -aq
docker ps -aq

# list containers virtual size
docker container ls -s

# run container
docker run hello-world

# run container iterative
docker run -it <image_name> bash

# execute command in container
docker exec -it <container_id_or_name> <command>

# create container with name
docker run -it --name ubuntu01 ubuntu bash

# create container with specified network
docker run -it --name ubuntu01 --network skynet ubuntu bash

# create container with network host
docker run -it --name ubuntu01 --network host ubuntu bash

# stop pause containers
docker stop <container_id_or_name>
docker stop -t=0 <container_id_or_name>

# Stop all containers
docker stop $(docker container ls -q)

# Pause\Unpause containers
docker pause <container_id_or_name>
docker unpause <container_id_or_name>

# delete container
docker rm <container_id_or_name> --force

# delete all containers
docker container rm $(docker container ls -aq) --force

# forwarding port
docker run -d -P <container_id_or_name>
docker run -d -p 8080:80 <container_id_or_name>

# show map ports
docker port <container_id_or_name>

# inspect container
docker inspect <container_id_or_name>
```

<p align="right">(<a href="#docker-containers">back to docker containers</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Docker Images

<a name="docker-images"></a>

```sh
# pull image
docker pull <image_name>

# show local images images
docker images

# show details of images
docker inspect <image_id>

# show  details of images layers
docker history <image_id>

# remove docker images
docker rmi <image_id> --force

# remove all docker images
docker rmi $(docker images -aq) --force

# build a docker image

## first, create your dockerfile with your app

## then create a docker image.
cd <path_of_your_dockerfile>
docker build -t <dockerhub_username/image_name:tag>

# publish your image in docker hub
docker push <dockerhub_username/image_name:tag>

# create container with docker bind mounts
docker run -it -d -v <dir_local_for_data:dir_container_for_data <image_name_or_id>
docker run -d --mount type=bind,source=/myfolder-volume,target=/app <image_name_or_id>

# create container with docker volume
docker run -d -v <volume_name>:/app <image_name_or_id>
```

<p align="right">(<a href="#docker-images">back to docker images</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Docker Volumes

<a name="docker-volumes"></a>

```sh
# list docker volumes
docker volume ls

# inspect docker volumes
docker volume inspect <volume_name>

# create docker volume
docker volume create <volume_name>

# delete docker volume
docker volume rm <volume_name>
```

<p align="right">(<a href="#docker-volumes">back to docker volumes</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Docker Network

<a name="docker-network"></a>

```sh
# list networks
docker network list

# inspect docker network
docker network inspect <network_name>

# create docker network bridge
docker network create --drive bridge <network_name>

# delete docker network
docker network rm <network_name>
```

<p align="right">(<a href="#docker-network">back to docker network</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Docker Compose

<a name="docker-compose"></a>

```sh
# list containers|services
docker-compose ps
docker-compose -f configs/docker/apps/app-silvestrini/docker-compose.yaml  ps

# create containers|services
docker-compose up
docker-compose up -d
docker-compose -f configs/docker/apps/app-silvestrini/docker-compose.yaml up
```

<p align="right">(<a href="#docker-compose">back to docker composed</a>)</p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contributing

Contributions are what make the open source community such an amazing place to
learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and
create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

* This project is licensed under the MIT License * see the LICENSE.md file for details

## Contact

Marcos Silvestrini - marcos.silvestrini@gmail.com \
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/mrsilvestrini.svg?style=social&label=Follow%20%40mrsilvestrini)](https://twitter.com/mrsilvestrini)

Project Link: [https://github.com/marcossilvestrini/learning-docker](https://github.com/marcossilvestrini/learning-docker)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Acknowledgments

* [Docker Website](https://www.docker.com/)
* [Docker Overview](https://docs.docker.com/get-started/overview/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES-->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/marcossilvestrini/learning-docker.svg?style=for-the-badge
[contributors-url]: https://github.com/marcossilvestrini/learning-docker/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/marcossilvestrini/learning-docker.svg?style=for-the-badge
[forks-url]: https://github.com/marcossilvestrini/learning-docker/network/members
[stars-shield]: https://img.shields.io/github/stars/marcossilvestrini/learning-docker.svg?style=for-the-badge
[stars-url]: https://github.com/marcossilvestrini/learning-docker/stargazers
[issues-shield]: https://img.shields.io/github/issues/marcossilvestrini/learning-docker.svg?style=for-the-badge
[issues-url]: https://github.com/marcossilvestrini/learning-docker/issues
[license-shield]: https://img.shields.io/github/license/marcossilvestrini/learning-docker.svg?style=for-the-badge
[license-url]: https://github.com/marcossilvestrini/learning-docker/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/marcossilvestrini
