# Installing and Running LS-Dyna (Solver) in Unix Environment with Network License

## Introduction

Installation of LS-Dyna solver in Unix envrionemnt is not straightforward for people coming from Windows systems. Though the steps are delineated in the [installation readme file](https://ftp.lstc.com/user/ls-dyna/R11.2.1/README_installation.txt) by LSTC, yet it is not like windows where you just have to click a bunch of "Next"s and then the software appears on your desktop. This was the inspiration for writing this shell script and making it public so that novices in Bash or terminal (like me) can utilize this.

## Prerequisite
The original LS-Dyna solver is a old-school Unix [CLI](https://en.wikipedia.org/wiki/Command-line_interface) application written in Fortran. So, we have to know the Fortran version our computer is using so that it can solve any analysis problems fast. Also, we would have to understand the [varities of options](https://lsdyna.ansys.com/downloader-filter/) LS-Dyna offers to the end users.

This might seems overwhelming at first (at least, for me, at first it was). So, I am going to explain all of them through bullet points -

### Solver Type:
* SMP ≡ [Shared Memory Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also called [Symmetric Multi-Processing](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf)) - this uses the [OpenMPI](https://www.open-mpi.org/) or [similar implementations](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) to split the analysis task on multiple threads in parallel. Have small scalability of $\leq$ 8 CPUs.
* MPP ≡ [Message Passaging Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also known as Massively Parallel Processing) - allows the software to perform a [domain decomposition](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf) and run the analysis in a cluster computer platform with multiple nodes (/cores/computers) and maintains communication between them. Excellent for solving large scale problems requiring $\geq$ 16 cores. But you might have to manipulate the keyword file generated for SMPs.

Generally it can be checked quickly writing the following line in terminal:

```bash
uname -a
```
But if you are writting this line inside the terminal, then for sure you would be using the SMP version of Dyna, otherwise there would have been a system administrator or a IT administrator to maintain all this things for you.
