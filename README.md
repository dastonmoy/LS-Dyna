# Installing LS-Dyna in Unix Environment with UNR Network License

## Introduction

Installation of LS-Dyna solver in Unix envrionemnt is not that much straightforward for people coming from Windows systems. Though the steps are delineated in the [installation readme file](https://ftp.lstc.com/user/ls-dyna/R11.2.1/README_installation.txt) by LSTC, yet it is not like windows where you just have to click a bunch of "Next"s and then the software appears on your desktop. This was the inspiration for writing a shell script and making it public so that novices in Bash or terminal (like me) can understand the procedure.

## Prerequisite

The original LS-Dyna solver is a old-school Unix [CLI](https://en.wikipedia.org/wiki/Command-line_interface) application written in Fortran. So, we have to know the Fortran compiler our computer is using so that it can solve any analysis problems fast. Also, we would have to understand the [varities of options](https://lsdyna.ansys.com/downloader-filter/) LS-Dyna offers to the end users.

This might seems overwhelming at first (for me at least, it was, at the first glance). So, I am going to explain all of the options first -

### Solver Type:

* SMP ≡ [Shared Memory Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also called [Symmetric Multi-Processing](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf)) - this uses the [OpenMPI](https://www.open-mpi.org/) or [similar implementations](https://github.com/dastonmoy/LS-Dyna/edit/main/README.md#optionals) to split the analysis task on multiple threads in parallel. It has small scalability of $\leq$ 8 CPUs.
* MPP ≡ [Message Passaging Parallel](https://ftp.lstc.com/anonymous/outgoing/support/PRESENTATIONS/mpp_201305.pdf) Processing version (also known as Massively Parallel Processing) - allows the software to perform a [domain decomposition](https://www.oasys-software.com/dyna/wp-content/uploads/2019/01/Webinar_MPP-LS-DYNA.pdf) and run the analysis in a cluster computer platform with multiple nodes (/cores/computers) and maintains communication between them. Excellent for solving large scale problems requiring $\geq$ 16 cores. But, you might have to manipulate the keyword file generated for SMPs.

Generally it can be checked quickly writing the following line in terminal:

```bash
uname -a
```
However, if you are writting this line inside the terminal, then for sure you would be using the SMP version of Dyna, otherwise there would have been a system administrator or a IT administrator to maintain all this things for you.

### (Floating Point) Precision:

The solution [precision](https://en.wikipedia.org/wiki/Accuracy_and_precision) point indicates the number of decimal points you want when doing the floating point arithmetic with the software. There are two options available in LS-Dyna:

* [single](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) or s (float 32) - might fail (sometime in server) with divided-by-zero error
* [double](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) or d (float 64) - double precision point is, for sure, more exact but requires more time ([20% slower than single precision](https://wiki.anl.gov/tracc/LS-DYNA#:~:text=Double%2Dprecision%20jobs%20are%20likely%20to%20run%20about%2020%25%20slower%20than%20single%2Dprecision%20jobs))

### Version of LS-Dyna solver:

Starts with R (Release) followed by the version numbers (i.e. R_13_1_1). The latest one is "[13.1.1](https://ftp.lstc.com/anonymous/outgoing/support/FAQ/ReleaseNotes/)". For our cluster, we are going to adopt the "11.2.1", otherwise it might pose inconsistency problems.

### Processor Type:

[x64](https://en.wikipedia.org/wiki/64-bit_computing) (as of now, most processors are capable of 64 bit computations).

### OS type:

All the Unix executables of LS-Dyna is developed for [CentOS](https://g.co/kgs/dgSnZE) or [REHL](https://g.co/kgs/WqfnNB). Though, we are going to use it in Ubuntu, it is also a form of Unix OS and will work.

### Compiler:

This is the compiler used in the LS-Dyna to compile the keyword file. For R11_2_1, it can be 

* [pgi165](https://developer.nvidia.com/hpc-sdk) or
* [ifort160](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html)

Both are freewares (at least, the community editions are). For now, we'll be using the ifort edition, as the computer LS-Dyna is going to be installed has this already available.

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
* Dynamic Library Type - If your software has the MPP version installed, then it might have sharelib. Through sharelib it is possible to write a user subroutine and incorporate it with MPP-Dyna.

* MPI Library - If MPPs option e.g., [Platform MPI](https://www.ibm.com/mysupport/s/topic/0TO50000000IMtJGAW/platform-mpi), [Intel MPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html) or [Open MPI](https://www.open-mpi.org/) is enabled.

Considering all of them, in this tutorial, we are going to install Dyna's R_11_2_1 SMP version with double precision intel fortran compiler (released as: ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160).

## Installation

### Installation in the Office Computer

```bash
# Go to home directory of the user
cd ~
# Clone my repository from github
git clone https://github.com/dastonmoy/LS-Dyna.git
# Enter into the folder
cd ./LS-Dyna
# Run the installer, it would do everything for you
bash install_dyna.sh
# Remove the github repo
rm -rf ~/LS-Dyna
```
For any subsequent access to the software, you just have to make the script created on your desktop as "executable".

### Installation in the Server

The LS-Dyna version 11.2.1 is already installed in the UNR College of Engrineering Network (COEN) under [Seylabi node](https://github.com/UNR-College-of-Engineering/computing-docs/blob/main/infrastructure/servers/cc/partitions/seylabi.md). The ways to access is already described in the previous doc. 

Under Seylabi server, the software can be easily accessed through:

```bash
# Loading OpenMPI version 2.1.3
module load openmpi/2.1.3
# Loading LS-Dyna v11.2.1
module load ls-dyna/11.2.1/sse2-openmpi
# Setting up the environmental variables/Network license
export LSTC_LICENSE=network
export LSTC_LICENSE_SERVER=license-0.engr.unr.edu
# Start LS-Dyna
ls-dyna
```

## Running LS-Dyna

## From Shortcut

A shortcut named LS-Dyna.sh is created on the Desktop of the system the software is installed. Running the software is now as simple as double clicking the shortcut and then specifying the inputs inside the software. The inputs should be following the template shown here (available in Page 376 of [LS-Dyna Keyword Manual: Volume I](https://ftp.lstc.com/anonymous/outgoing/jday/manuals/LS-DYNA_Manual_Volume_I_R13.pdf), and also mentioned in [this training manual](http://fire.fsv.cvut.cz/ifer/2014-Training_school/Materials%20to%20software%20courses/LS-DYNA/Getting_started.pdf)):

```bash
> I=inf #O=otf G=ptf D3PART=d3part D=dpf F=thf T=tpf A=rrd M=sif S=iff H=iff Z=isf1 L=isf2 B=rlf W=root E=efl X=scl C=cpu K=kill V=vda Y=c3d BEM=bof {KEYWORD} {THERMAL} {COUPLE} {CASE} {PGPKEY} MEMORY=nwds MODULE=dll NCPU=ncpu PARA=para ENDTIME=time NCYCLE=ncycle JOBID=jobid D3PROP=d3prop GMINP=gminp GMOUT=gmout MCHECK=y MAP=map MAP1=map1 LAGMAP=lagmap LAGMAP1=lagmap1
```

Detailes of the keywords mentioned here are provided in the manuals. The memory allocation keyword (nwds) are explained a little bit more in [here](https://wiki.hpc.uconn.edu/index.php/LS-Dyna_Guide#:~:text=mpi%20command%20above.-,Memory%20allocation%20for%20ls%2Ddyna,-R10)). When specifying the input file ("I"), you should be redirecting it to the folder where the input files are residing (for example: I=~/Dyna_works/Example/wood-post.k).

## From the Terminal

To run the software from the terminal, you can either change the directory to "Desktop" and run from there, or you can also run from the original file located inside "Dyna" folder of the Home directory. I would personally recommend to use a separate directory (e.g., Dyna_inputs) for having all the input (or the \*.k file) and output files, otherwise it would be really difficult to recognize the specific output for a file.

For terminal follow this:

```bash
bash ~/Desktop/LS-Dyna I=inf # O=otf G=ptf D3PART=d3part D=dpf F=thf T=tpf A=rrd M=sif S=iff H=iff Z=isf1 L=isf2 B=rlf W=root E=efl X=scl C=cpu K=kill V=vda Y=c3d BEM=bof {KEYWORD} {THERMAL} {COUPLE} {CASE} {PGPKEY} MEMORY=nwds MODULE=dll NCPU=ncpu PARA=para ENDTIME=time NCYCLE=ncycle JOBID=jobid D3PROP=d3prop GMINP=gminp GMOUT=gmout MCHECK=y MAP=map MAP1=map1 LAGMAP=lagmap LAGMAP1=lagmap1
```

## Resources

There are a ton of resources for Dyna on the internet. My personal favorites are:
* LS-PrePost Online documentation(now available in [wayback machine](https://web.archive.org/web/20210508071555/http://www.lstc.com/lspp/content/tutorials.shtml))
* [LSTC's Getting Started](https://ftp.lstc.com/anonymous/outgoing/jday/manuals/getting-started/GettingStarted.pdf)
* [LS-Dyna Example Manual](http://ftp.lstc.com/anonymous/outgoing/jday/manuals/Intro_Examples_Manual_DRAFT.pdf)
* [LS-Dyna Manuals](https://lsdyna.ansys.com/manuals/)

\-among others.
