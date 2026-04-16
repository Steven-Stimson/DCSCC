```
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
sh Miniforge3-Linux-x86_64.sh -b -p /opt/software/miniforge
rm Miniforge3-Linux-x86_64.sh
echo "source /opt/software/miniforge/bin/activate" >~/.condaon.sh

cd cryo && sh install.sh
```
