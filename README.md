# Wordpress for developers

This repo intends to help WordPress developers to run several instances of it via docker.

## Quick start

Open a terminal and change to the directory of this git repo then type:
```
./create-wp.sh
```

(Note: if you get an error like 'file not found' or simliar make the script executable by typing `chmod u+x create-wp.sh`)

Then answer the questions and you will be running WP in no time.
You can run this script as many times as you want, it will create separate instances.

## Clean-up

If you need to delete an installation, simply run the following from the directory of this git repo:
```
./delete-wp.sh
```

(Note: if you get an error like 'file not found' or simliar make the script executable by typing `chmod u+x delete-wp.sh`)

## To do

- Export the files and DB
- Import the files and DB to production server
- Setting up a production server with Nginx for multiple instances
