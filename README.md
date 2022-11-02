# Installing LS-Dyna in Unix Environment with UNR Network License

## Introduction

Installation of LS-Dyna solver in Unix envrionemnt is not straightforward for people coming from Windows systems. Though the steps are delineated in the [installation readme file](https://ftp.lstc.com/user/ls-dyna/R11.2.1/README_installation.txt) by LSTC, yet it is not like windows where you just have to click a bunch of "Next"s and then the software appears on your desktop. This was the inspiration for writing a shell script and making it public so that novices in Bash or terminal (like me) can understand the procedure.

## Prerequisite

The original LS-Dyna solver is a old-school Unix [CLI](https://en.wikipedia.org/wiki/Command-line_interface) application written in Fortran. So, we have to know the Fortran compiler our computer is using so that it can solve any analysis problems fast. Also, we would have to understand the [varities of options](https://lsdyna.ansys.com/downloader-filter/) LS-Dyna offers to the end users.

This might seems overwhelming at first (for me at least, it was, at the first glance). So, I am going to explain all of the options through bullet points -

### Solver Type:

* SMP ≡ [Shared Memory Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also called [Symmetric Multi-Processing](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf)) - this uses the [OpenMPI](https://www.open-mpi.org/) or [similar implementations](https://github.com/dastonmoy/LS-Dyna/edit/main/README.md#optionals) to split the analysis task on multiple threads in parallel. Have small scalability of $\leq$ 8 CPUs.
* MPP ≡ [Message Passaging Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also known as Massively Parallel Processing) - allows the software to perform a [domain decomposition](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf) and run the analysis in a cluster computer platform with multiple nodes (/cores/computers) and maintains communication between them. Excellent for solving large scale problems requiring $\geq$ 16 cores. But you might have to manipulate the keyword file generated for SMPs.

Generally it can be checked quickly writing the following line in terminal:

```bash
uname -a
```
But if you are writting this line inside the terminal, then for sure you would be using the SMP version of Dyna, otherwise there would have been a system administrator or a IT administrator to maintain all this things for you.

### (Floating Point) Precision:

The solution [precision](https://en.wikipedia.org/wiki/Accuracy_and_precision) point indicates the number of decimal points you want when doing the floating point arithmetic with the software. There are two options available in LS-Dyna:

* [single](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) or s (float 32) - might fail (sometime in server) with divided-by-zero error
* [double](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) or d (float 64) - double precision point is, for sure, more exact but requires more time ([20% slower than single precision](https://wiki.anl.gov/tracc/LS-DYNA#:~:text=Double%2Dprecision%20jobs%20are%20likely%20to%20run%20about%2020%25%20slower%20than%20single%2Dprecision%20jobs))

### Version of LS-Dyna solver:

Starts with R (Release) then ther version numbers (R_13_1_1). The latest one is "[13.1.1](https://ftp.lstc.com/anonymous/outgoing/support/FAQ/ReleaseNotes/)". For our cluster, we are going to adopt the "11.2.1", otherwise it might pose inconsistency problems.

### Processor Type:

[x64](https://en.wikipedia.org/wiki/64-bit_computing) (as of now most processors are capable of 64 bit computations).

### OS type:

All the Unix executables of LS-Dyna is developed for [CentOS](https://g.co/kgs/dgSnZE) or [REHL](https://g.co/kgs/WqfnNB). Though, we are going to use it in Ubuntu, it is also a form of Unix OS and will work.

### Compiler:

This is the compiler used in the LS-Dyna to compile the keyword file. For R11_2_1, it can be 

* [pgi165](https://developer.nvidia.com/hpc-sdk) or
* [ifort160](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html)

Both are freewares (at least, the community editions are). For now, we'll be using the ifort edition, as the computer LS-Dyna is going to be installed has this already installed.

### Optionals:

Depending on the release version we are downloading, there is also some optional parameters available, such as:

* Instruction set - The amount of vectorization operations to be done. For LS-Dyna we can have: 
    * [SSE2](https://en.wikipedia.org/wiki/SSE2) (too old)
    * [AVX2](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions) (available in all)
    * [AVX512](https://en.wikipedia.org/wiki/AVX-512) (available mostly in workstation based processors). 
    
    It's possible to check this by writing a line in terminal and taking a look at the flag to detect SSE2/AVX2/AVX512
    
    ```bash
    cat /proc/cpuinfo|more
    ```
* Dynamic Library Type - If your software has the MPP version installed, then it might have sharelib. Using sharelib it is possible to write a user subroutine and incorporate it with MPP-Dyna.

* MPI Library - If MPPs option e.g., [Platform MPI](https://www.ibm.com/mysupport/s/topic/0TO50000000IMtJGAW/platform-mpi), [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) or [Open MPI](https://www.open-mpi.org/) is enabled.

Considering all of them, in this tutorial, we are going to install Dyna's R_11_2_1 SMP version with double precision intel fortran compiler (ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160)

## Installation

