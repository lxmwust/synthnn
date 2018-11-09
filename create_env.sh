#!/bin/bash
# use the following command to run this script: . ./create_env.sh
# Created on: Nov 8, 2018
# Author: Jacob Reinhold (jacob.reinhold@jhu.edu)

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin"* ]]; then
    :
else
    echo "Operating system must be either linux or OS X"
    return 1
fi

command -v conda >/dev/null 2>&1 || { echo >&2 "I require anaconda but it's not installed.  Aborting."; return 1; }

# first make sure conda is up-to-date
conda update -n base conda --yes

# define all the packages needed
packages=(
    numpy 
    matplotlib 
)

# assume that linux is GPU enabled but OS X is not
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    pytorch_packages=(
        pytorch-nightly
        cuda92
    )
    fastai_packages=(
        torchvision-nightly
        fastai
    )
else
    pytorch_packages=(
        pytorch-nightly-cpu
    )
    fastai_packages=(
        torchvision-nightly-cpu
        fastai
    )
fi


conda_forge_packages=(
    nibabel
)

# create the environment and switch to that environment
conda create --name synthnn --override-channels -c pytorch -c fastai -c defaults ${packages[@]} ${fastai_packages[@]} ${pytorch_packages[@]} --yes 
conda activate synthnn

# add a few other packages
conda install -c conda-forge ${conda_forge_packages[@]} --yes 
pip install git+git://github.com/jcreinhold/niftidataset.git
pip install git+git://github.com/NVIDIA/apex.git

# install this package
python setup.py install

# create environment yaml file to hold env specifications
conda env export > synthnn_env.yml

echo "synthnn conda env script finished (verify yourself if everything installed correctly)"
