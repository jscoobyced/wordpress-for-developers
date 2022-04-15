#!/bin/bash

check_cmd() {
    CMD_TO_CHECK=$(which $1)
    if [ -z "${CMD_TO_CHECK}" ];
    then
        echo "'$1' not found. Please install it first."
        exit 0
    fi
}

check_env_ready() {
    echo "Checking environment."
    if [ $(id -u) -eq 0 ];
    then
        echo "!! Please do not run this script as root user."
        echo "Exiting."
        exit 0
    fi

    check_cmd "docker"
    check_cmd "docker-compose"
}

collect_data() {
    echo "Please provide the database information you want to be created."
    read -p 'Database username: ' WP_DB_USER
    read -sp 'Database password: ' WP_DB_PASSWORD
    echo ""
    read -p 'Database name: ' WP_DB_NAME

    echo ""
    echo "Project information:"
    read -p 'Project name: ' WP_NAME_FULL
    WP_NAME=$(echo ${WP_NAME_FULL} | tr -cd '[:alnum:]_-')

    WP_PROJECT_PATH="${PWD}/${WP_NAME}"

    if [ -d "${WP_PROJECT_PATH}" ];
    then
        echo "The project ${WP_NAME} already exists."
        read -p "Do you want to delete the '${WP_NAME}' project? (y/N) " WP_DELETE
        if [ "${WP_DELETE}" = "y" ] || [ "${WP_DELETE}" = "Y" ];
        then
            echo "Deleting the '${WP_NAME}' project."
            echo "SUDO permission will be needed."
            pushd ${WP_PROJECT_PATH}
            docker-compose down
            popd
            sudo rm -Rf "${WP_PROJECT_PATH}"
        else
            echo "Please chose a different project name."
            exit 0
        fi
    fi

    echo "The project '${WP_NAME}' is going to be created."

    WP_PORT=${RANDOM}
    while [ ${WP_PORT} -lt 2000 ];
    do
        WP_PORT=${RANDOM}
    done
}

start_wp() {
    if [ -z "${WP_PROJECT_PATH}" ] || [ "${WP_PROJECT_PATH}" = "${PWD}" ];
    then
        echo "Invalid configuration. Project path cannot be empty or same"
        echo "as root folder."
        exit 0
    fi
    mkdir ${WP_PROJECT_PATH}
    pushd ${WP_PROJECT_PATH}

cat <<EOF > .env
WP_DB_USER=${WP_DB_USER}
WP_DB_PASSWORD=${WP_DB_PASSWORD}
WP_DB_NAME=${WP_DB_NAME}
WP_PORT=${WP_PORT}
EOF

    mkdir "${PWD}/wordpress" "${PWD}/db"
    cp ../docker-compose.yml .
    docker-compose up -d
    echo "Please wait for initial setup."
    sleep 10
    echo "You can open your new WP instance on http://localhost:${WP_PORT}"
    popd
}

echo "This script will create a blank new WordPress installation as a set"
echo "of 2 docker containers: WP itself, and a MySQL (MariaDB) database."
echo "All the data will be stored in a volume outside of the container so"
echo "you can always access the files and database."
echo ""

check_env_ready
collect_data
start_wp