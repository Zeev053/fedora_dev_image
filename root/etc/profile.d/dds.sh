#!/bin/bash

# If variable RTI_LICENSE_FILE is not set - set it
if [ -z "${RTI_LICENSE_FILE+x}" ]; then
   echo update RTI_LICENSE_FILE
   export RTI_LICENSE_FILE=/opt/rti_connext_dds-6.0.1/rti_license.dat
fi
