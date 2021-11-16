# Jets Reformation
In this repository we provide information and dataset that allow the reproduction of the results found in the manuscript "Downstream Super-magnetosonic Plasma Jet Generation as a Direct Consequence of Shock Reformation" currently under consideration for Nature Communications journal.

- [![Publication: Under consideration](https://img.shields.io/badge/Publication-Under%20consideration-green?style=flat&logo=openaccess)](https://www.researchsquare.com/article/rs-711807/v1)

### Corresponding Author
[![Savvas Raptis: 0000-0002-4381-3197](https://img.shields.io/badge/Savvas%20Raptis-0000--0002--4381--3197-green?style=flat&logo=orcid)](https://orcid.org/0000-0002-4381-3197) 

## Repository Content
* [data](data) : Contains a .mat file with the MMS measurements. Furthermore, we provide a README file with the information about reading the data provided. We however, strongly recommend if an extensive reproduction of the results takes place to visit the official MMS and OMNIweb repositories and acknowledge their use rather than using the pre made data products of this folder.

* [figures](figures): Contains the figures of the manuscript and the supplementary figure. Furthermore, it contains a step-by-step guide on how to fully reproduce the figures of the work along with which function of [irfu-matlab](https://github.com/irfu/irfu-matlab) was used in each case.

* [irfu-matlab](irfu-matlab): contains the version of the [irfu-matlab](https://github.com/irfu/irfu-matlab) package used to generate the figures of the work.

## Extra information

For fully reproducing the figures you will need the irfu-matlab library which is available at [irfu-matlab](https://github.com/irfu/irfu-matlab), then simply add the library to MATLAB's path and run:

```matlab
irfu
```
At the tome of the latest submission of the article, the following software versions were used:

* irfu-matlab version:  v1.16.0
* inkscape version:  v0.92
* MATLAB version: R2020b
* OS: Windows 10 Education, build: 19042.1288

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE  - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

We thank the MMS team for providing data and support. We acknowledge the use of NASA/GSFC's Space Physics Data Facility's OMNIWeb service, and OMNI data. We acknowledge the use of [irfu-matlab package](https://github.com/irfu). We thank M. Lindberg and A. Lalti, for their comments on the initial stage of the work. We are also thankful for the useful discussions done with the International Space Sciences Institute (ISSI) team, “Foreshocks Across The Heliosphere: System Specific Or Universal Physical Processes?”
