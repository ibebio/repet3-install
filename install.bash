#!/usr/bin/env bash
############################################################
# Installation script for REPET pipeline V3
#
# The pipeline is installed inside a conda environment.
# The MySql Server is provided by a udocker container.
#
# Author: Ilja Bezrukov, 2020
############################################################

# Set bash strict mode
set -euo pipefail

# Debug mode
set -xv

############################################################
# Create conda environment
ENV_YAML=environment.yaml
CONDA_ENV_NAME=$(cat ${ENV_YAML} | head -1 | awk '{print $2}')

#X conda env create --file ${ENV_YAML}
#
############################################################

############################################################
# Install REPET inside the conda environment
set +euo
source activate ${CONDA_ENV_NAME}
set -euo
TMP_DIR=$(mktemp -d)
CURR_DIR=$(pwd)

cd ${TMP_DIR}
wget https://urgi.versailles.inra.fr/download/repet/REPET_linux-x64-3.0.tar.gz
tar -xvf REPET_linux*.tar.gz

mkdir ${CONDA_PREFIX}/REPET
mv REPET_linux* ${CONDA_PREFIX}/REPET

echo "# REPET environment settings -- auto generated on $(date)" > ${CURR_DIR}/repet_env
echo "export REPET_PATH=${CONDA_PREFIX}/REPET" >> ${CURR_DIR}/repet_env
echo "export PATH=\$PATH:${CONDA_PREFIX}/REPET/bin" >> ${CURR_DIR}/repet_env
echo "export PYTHONPATH=${CONDA_PREFIX}/REPET" >> ${CURR_DIR}/repet_env
#
############################################################

############################################################
# Install highly recommended dependencies
# - hmer3 is already included in conda environment (3.2.1)
# - piler is already included in conda environment (1.0)
# - blastclust is already included in conda environment (2.2.26)
# - Skipped censor
# - TRF is already included in conda environment
# - REPBASE: we don't have a subscription, thus leave it out for now.
# - RepeatMasker: is available in the environment, but is likely not very useful without additional configuration.
# HSP Clustering -- RECON
wget http://www.repeatmasker.org/RepeatModeler/RECON-1.08.tar.gz
tar -xvzf RECON-*.tar.gz
rm RECON*.tar.gz
mv RECON* RECON
cd RECON
cd src
make && make install
cd ../..
mv RECON ${CONDA_PREFIX}/RECON
sed -i "s|\$path = \"\"|\$path = \"$PWD\\/bin\"|g" \
    ${CONDA_PREFIX}/RECON/scripts/recon.pl
echo "export PATH=\$PATH:${CONDA_PREFIX}/RECON/bin:${CONDA_PREFIX}/RECON/scripts" >> \
     ${CONDA_PREFIX}/repet_env

#
############################################################

echo "Installation finished."
echo "For REPET to work, add the following line to your ~/.bashrc file:"
echo "source ${CONDA_PREFIX}/repet_env"
echo ""
echo "
