# Reproduce figures
Source data are accessible freely online. Magnetospheric Multiscale (MMS) are available through the [MMS repository](https://lasp.colorado.edu/mms/sdc/public/). For the solar wind measurements, one can access the [OMNI high-resolution](https://omniweb.gsfc.nasa.gov/form/omni_min.html) repository. Alternatively you can access the MMS data directly from a pre-made .mat file available in the data folder of this [repository]((https://github.com/SavvasRaptis/Jets-Reformation))

## General instructions

In the irfu-package there are examples of all the plots that are included in the manuscript with documentation and extensive descriptions.
MMS examples are located here: https://github.com/irfu/irfu-matlab/tree/master/plots/mms

In all the figures, the special notation was done by editing vector graphic files exported from MATLAB with Inkscape.

Inkscape is an open source vector graphic software, available on https://inkscape.org/

We will discuss below how to generate the base figures that do not include the special notation (shading, numbering etc.) to assist any reader interested in re-producing our results.

## Step-by-step instructions

### Figure 1,2

* FIG1 and FIG2 (a) were generated using the  mms.mms4_pl_conf function of [irfu-matlab](https://github.com/irfu/irfu-matlab) package
FIG1 and FIG2 (b,c) are ladder plots of different MMS spacecraft. all the raw data available for them can be found in the MMS public depository.

* For panels 3-5 for FIG1,2 (b,c) one can use the iPDist.reduce function of [irfu-matlab](https://github.com/irfu/irfu-matlab) package in 1D on x,y,z GSE coordinates. The panels correspond to 1D reduced velocity distribution functions

* For panel 9 for FIG1,2 (b,c) one can use irf_spectrogram of [irfu-matlab](https://github.com/irfu/irfu-matlab) package. The panels correspond to ion differential energy flux spectrum

- The rest of the panels are essentially timeseries plots made with irf_plot of [irfu-matlab](https://github.com/irfu/irfu-matlab)

### Figures 3,4

* For panel 3 of FIGs 3,4 one can use the iPDist.reduce function of [irfu-matlab](https://github.com/irfu/irfu-matlab) package in 1D on x GSE direction. The panel correspond to 1D reduced ion velocity distribution function.

* For panel 6 for FIG3,4 one can use irf_spectrogram of [irfu-matlab](https://github.com/irfu/irfu-matlab) package. The panel correspond to the ion differential energy flux spectrum.

* For FIG 4(c), one can use the function mms.psd_moments of [irfu-matlab](https://github.com/irfu/irfu-matlab) package. Specifically, the jet is defined as a closed square box of the particles corresponding to negative velocities in the x and y GSE direction in the FIGS1 and discussed in the manuscript of the text.

* Mach number computations to generate the first panel of FIG4(c) is discussed in the results section of the manuscript.

### Figure 5

* To generate FIG5 one has to use MMS 1 to cross corelate the rest of the spacecraft measurements with respect to it. For picking the time period, one can focus on the region ("1") as discussed in the manuscript or extend the period to include a larger part. One can use the sample cross-correlation function as implemented in MATLAB software, https://mathworks.com/help/econ/crosscorr.html to perform the task. As discussed in the manuscript, adapting the period of time must produce no significant differences in the optimal time lag between the measurements.

* The plot itself is a typical ladder plot of 4 timerseries that include magnetic field measurements. Similar to the figures above, one can use the irf_plot function of [irfu-matlab](https://github.com/irfu/irfu-matlab) package.

### Figure 6

* FIG 6(a) was completely done using vector graphics in inkscape by the corresponding author.

* FIG 6(b) is a timeseries ladder plot using simple plotting routines and the irf_spectrogram of [irfu-matlab](https://github.com/irfu/irfu-matlab) package

### Figure S1

- For reducing the velocity distributions we used  the iPDist.reduce function of [irfu-matlab](https://github.com/irfu/irfu-matlab) package in 2D on x,y,z GSE coordinates.