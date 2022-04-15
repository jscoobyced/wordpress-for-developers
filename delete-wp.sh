#!/bin/bash

echo "This script will delete everything related to the project."
echo "Please backup anything you wish to retain."

read -p 'Project name: ' WP_NAME_FULL
WP_NAME=$(echo ${WP_NAME_FULL} | tr -cd '[:alnum:]_-')

WP_PROJECT_PATH="${PWD}/${WP_NAME}"

if [ -d "${WP_PROJECT_PATH}" ] && [ ! -z "${WP_PROJECT_PATH}" ] && [ "${WP_PROJECT_PATH}" != "${PWS}" ];
then
    echo "Deleting the '${WP_NAME}' project."
    echo "SUDO permission will be needed."
    pushd ${WP_PROJECT_PATH}
    docker-compose down
    popd
    sudo rm -Rf "${WP_PROJECT_PATH}"
fi