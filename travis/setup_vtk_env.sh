#!/bin/bash

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then 
    if [[ "${VTK_VERSION}" == "5.8" ]]; then 
        brew install vtk5
        export PYTHONPATH=/usr/local/opt/vtk5/lib/python2.7/site-packages
        export DYLD_LIBRARY_PATH=/usr/local/opt/vtk5/lib
    elif [[ "${VTK_VERSION}" == "6.3" ]]; then 
        # This is the name of the directory after unpacking
        VTK_PYTHON=VTK-${VTK_VERSION}.0-Darwin-64bit

        # Download link to the vtkPython
        DOWNLOAD_LINK=http://www.vtk.org/files/release/${VTK_VERSION}/vtkpython-${VTK_VERSION}.0-Darwin-64bit.dmg

        # Cache directory
        CACHE_DIR=${HOME}/.cache

        # Locate the unpacked directory, or unpack if it wasn't done already
        if [ -d "${CACHE_DIR}/${VTK_PYTHON}" ]; then
            echo "${VTK_PYTHON} is found"
        else
            echo "Downloading ${VTK_PYTHON}"
            wget ${DOWNLOAD_LINK} -O ${VTK_PYTHON}.dmg
            echo "Y" | hdiutil attach ${VTK_PYTHON}.dmg
            cp -rv /Volumes/${VTK_PYTHON}/vtkpython ${CACHE_DIR}/${VTK_PYTHON}
            # Move the python stuff from bin. Unclear why it's that, 
            # but we prefer it in a more canonical place
            mkdir -p ${CACHE_DIR}/${VTK_PYTHON}/lib/python2.7/site-packages/
            mv ${CACHE_DIR}/${VTK_PYTHON}/bin/vtk ${CACHE_DIR}/${VTK_PYTHON}/lib/python2.7/site-packages/
        fi

        export PYTHONPATH=${CACHE_DIR}/${VTK_PYTHON}/lib/python2.7/site-packages
        export DYLD_LIBRARY_PATH=${CACHE_DIR}/${VTK_PYTHON}/lib
    elif [[ "${VTK_VERSION}" == "7.0" ]]; then 
        brew install vtk
        ls -la PYTHONPATH=/usr/local/opt/vtk/lib/python2.7/site-packages
        ls -la PYTHONPATH=/usr/local/opt/vtk/lib/python2.7/site-packages/vtk
        export PYTHONPATH=/usr/local/opt/vtk/lib/python2.7/site-packages
        export DYLD_LIBRARY_PATH=/usr/local/opt/vtk/lib
    fi
else
    # Linux
    if [[ "${VTK_VERSION}" == "5.8" ]]; then
        # Do nothing. 5.8 is already on the system
        :
    else
        # This is the name of the directory after unpacking
        VTK_PYTHON=VTK-${VTK_VERSION}.0-Linux-64bit

        # Download link to the vtkPython
        DOWNLOAD_LINK=http://www.vtk.org/files/release/${VTK_VERSION}/vtkpython-${VTK_VERSION}.0-Linux-64bit.tar.gz

        # Cache directory
        CACHE_DIR=${HOME}/.cache

        # Locate the unpacked directory, or unpack if it wasn't done already
        if [ -d "${CACHE_DIR}/${VTK_PYTHON}" ]; then
            echo "${VTK_PYTHON} is found"
        else
            echo "Downloading ${VTK_PYTHON}"
            wget ${DOWNLOAD_LINK} -O vtk_python.tar.gz
            gunzip vtk_python.tar.gz
            tar -xf vtk_python.tar -C ${CACHE_DIR}
            rm -f vtk_python.tar
        fi

        export PYTHONPATH=${CACHE_DIR}/${VTK_PYTHON}/lib/python2.7/site-packages
        export LD_LIBRARY_PATH=${CACHE_DIR}/${VTK_PYTHON}/lib
    fi
fi
