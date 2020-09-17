#!/bin/bash
# Check if .resource.version file exists or not, if not then create one.
if [ ! -f .resource.version ]
then
    touch .resource.version
    echo RESOURCE_VERSION=0.0.0 > .resource.version
fi
# Extract version from file.
resource_version=`egrep -o "[0-9]+\.[0-9]+\.[0-9]+$" .resource.version`
# Break it into 3 parts.
IFS='.' read -a version <<< "$resource_version"
# Update Minor and Patch parts of the version.
version[1]=$((${version[1]}+1))
version[2]='0'
# Build the string again to re-write it in the file.
resource_version=''
for version_number in ${version[@]}
do
    resource_version=$resource_version$version_number'.'
done
# Strip last char, i.e. extra dot, and wirte to file.
echo ${resource_version%?} > .resource.version

cat > .resource_version.json <<EOF
{
  "RESOURCE_VERSION": "${resource_version%?}"
}
EOF
