# !/bin/sh
# Creating and running ls-dyna in Ubuntu Linux
# Written by Tonmoy. Last update: 11/02/22

echo "This script is written to create a LS-dyna environment and to run the solver through Ubuntu"

# Creating a folder for installation:
mkdir ~/Dyna
cd ~/Dyna

# Considering all parameters "ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160" is selected for download:
wget --user user --password computer https://ftp.lstc.com/user/ls-dyna/R11.2.1/linux64/ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160.tgz_extractor.sh

# According to the Readme file (available here: https://ftp.lstc.com/user/ls-dyna/R11.2.1/README_first.txt) provided by LSTC, we also have to install the license client in the same directory with the solver:
wget --user user --password computer https://ftp.lstc.com/user/license/License-Manager/LSTC_LicenseManager_77918_xeon64_suse11.tgz # used for trial

# This was tarred and then gunzipped. So we've to use both of them for extracting the original files
gunzip *.tgz
tar xvf *.tar

# Removing the tar file
rm -f LSTC_LicenseManager_77918_xeon64_suse11.tar

# Now, according to the official installation document (https://ftp.lstc.com/user/license/License-Manager/LSTC_LicenseManager-InstallationGuide.pdf) page 13, the environmental variables proposed by OIT were exported:
export LSTC_LICENSE=network
export LSTC_LICENSE_SERVER=license-0.engr.unr.edu

# Adding the lines also in the .bashrc so that are automatically defined when opening the computer
echo 'export LSTC_LICENSE=network' >> ~/.bashrc
echo 'export LSTC_LICENSE_SERVER=license-0.engr.unr.edu' >> ~/.bashrc

# For Dyna installation, the installation instructions (https://ftp.lstc.com/user/ls-dyna/R11.2.1/README_installation.txt) provided by LSTC were followed:
x=1
while [ $x = 1 ]
do
    read -p "Now, you are going to encounter the license aggrement. Please hit \"q\" twice to install... Have you understood the instructions? Type \"yes\"" yn
    case $yn in
        [Yy]* ) x=0;;
        * ) echo "Please answer yes or no.";;
    esac
done

chmod 750 ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160.tgz_extractor.sh
printf 'y\nn' | ./ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160.tgz_extractor.sh info # hit q when you are encountering a bunch of texts

# Now, create a shortcut of the program on the desktop for easy accessibility and making it convenient to access for the windows users
cd ~/Desktop
echo 'cd ~/Dyna
./ls-dyna_smp_d_R11_2_1_x64_centos610_ifort160'>>LS-Dyna.sh

# To check, if the installation of the Dyna is perfectly working, download a small example keyword file
wget https://www.dynaexamples.com/introduction/intro-by-j.-reid/dynaexamples/introduction/intro-by-j.-reid/wood-post/wood-post.k.gz
gzip -d wood-post.k.gz
bash LS-Dyna.sh i=wood-post.k

