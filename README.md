<div id="top"></div>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="[https://github.com/open-img-cloud/alpaquita-linux](https://github.com/open-img-cloud/alpaquita-linux)">
    <img src="images/logo.svg" alt="Logo" width="250">
  </a>

<h3 align="center">Alpaquita Linux image for OpenStack</h3>

  <p align="center">
    Port of Alpaquita Linux distribution for OpenStack environments
    <br />
    <a href="https://github.com/open-img-cloud/alpaquita-linux"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/open-img-cloud/alpaquita-linux/issues">Report Bug</a>
    ·
    <a href="https://github.com/open-img-cloud/alpaquita-linux/issues">Request Feature</a>
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project

This project is a simple port of Alpine Linux releases for OpenStack environments.  
This image used the the project [alpine-make-vm-image](https://github.com/alpinelinux/alpine-make-vm-image "alpine-make-vm-image project") to build base image and we make some change to make it compatible with OpenStack environments and cloud-init.  

This image is updated when Alpine Linux team released a new version of the OS [here](https://alpinelinux.org/releases/ "Alpine linux Release Inventory").


<p align="right">(<a href="#top">back to top</a>)</p>

### How to use this image

1. Set your OpenStack environement variables
2. Download the latest image from the [repository page](https://repo.openimages.cloud/alpaquita-linux/ "Images Repository")
3. Upload image to your OpenStack environment
   ```sh
   openstack image create --disk-format=qcow2 --container-format=bare --file alpaquita-<VERSION>-x86_64.qcow2  'Alpaquita Linux Stream (glibc)'
   ```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE.md` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Kevin Allioli - [@linit_io](https://twitter.com/linit_io) - kevin@linit.io

Project Link: [https://github.com/linitio/openstack-alpine-image](https://github.com/linitio/openstack-alpine-image)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
https://github.com/open-img-cloud/alpaquita-linux
[contributors-shield]: https://img.shields.io/github/contributors/open-img-cloud/alpaquita-linux.svg?style=for-the-badge
[contributors-url]: https://github.com/open-img-cloud/alpaquita-linux/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/open-img-cloud/alpaquita-linux.svg?style=for-the-badge
[forks-url]: https://github.com/open-img-cloud/alpaquita-linux/network/members
[stars-shield]: https://img.shields.io/github/stars/lopen-img-cloud/alpaquita-linux.svg?style=for-the-badge
[stars-url]: https://github.com/open-img-cloud/alpaquita-linux/stargazers
[issues-shield]: https://img.shields.io/github/issues/open-img-cloud/alpaquita-linux.svg?style=for-the-badge
[issues-url]: https://github.com/open-img-cloud/alpaquita-linux/issues
[license-shield]: https://img.shields.io/github/license/open-img-cloud/alpaquita-linux.svg?style=for-the-badge
[license-url]: https://github.com/linitio/openstack-alpine-image/blob/master/LICENSE.md
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/kevinallioli
