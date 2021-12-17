#!/bin/bash

# Github Username
userName=#REPLACE THIS COMMENT WITH YOUR USERNAME.

# Variable defaults.
webpack=1
git=1
projectName=""

# Usage function.
usage() {
    printf "Usage: sup -n <PROJECT_NAME> <OPTIONS>\n"
}

# Function to create a public repository with the project name if such a repository doesn't exist. Requires github-cli.
createRepo() {
    answer=""
    while [ "$answer" != "y" -o "$answer" != "n" ]
    do 
        echo -e "\033[1;33mRepository doesn't exist. Create a public repository?(Requires GitHub-cli)(y/n)\033[0m"
        read answer
        if [ "$answer" == "y" ]; then
            eval "gh repo create $projectName --public"
            eval "git clone git@github.com:$userName/$projectName.git"
            break
        elif [ "$answer" == "n" ]; then
            printf "\033[0;31mAborted\033[0m\n"
            exit 1
        fi
    done
}

# Check options
while getopts gwn: flag
do
    case "${flag}" in
        g) git=0;;
        w) webpack=0;;
        n) projectName=${OPTARG};;
        *) usage
           exit 1;;
    esac
done

# Print usage and abort if a project name isn't passed.
if [ "$projectName" == "" ]; then
    usage
    exit 1
fi

# Print warning and abort if a directory with the same name as the project name exists.
if [ -d "./$projectName" ]; then
    printf "\033[0;31mDirectory with the project name already exists!\033[0m\n"
    exit 1
fi

# Check if the repository exists if the git option is passed, abort if a connection cannot be made. If the git option isn't
# passed, create a dir with the project name.
if [ $git -eq 0 ]; then
    statusCode=$(curl --write-out %{http_code} --silent --output /dev/null https://github.com/$userName/$projectName)
    case $statusCode in
        404) createRepo;;
        000) printf "\033[0;31mCannot connect to the remote repository!\033[0m\n"
             exit 1;;
        *) eval "git clone git@github.com:$userName/$projectName.git";;
    esac
else
    mkdir $projectName
fi



# Main loop
while true
do
    cd $projectName

    # Check to see if the git repository is empty, if it's not, abort.
    repoFiles=$(git ls-files)

    if [ "$repoFiles" != "" ]; then
        printf "\033[0;31mRepository isn't empty!\033[0m\n"
        exit 1
    fi

    # Start creating files.
    if [ $git -eq 0 ]; then
        touch README.md
    fi 

    if [ $webpack -eq 0 ]; then
        eval "npm init"
        eval "npm install webpack webpack-cli --save-dev"
        if [ $git -eq 0]; then
            cd node_modules
            touch .gitignore
            cd ..
        fi
        mkdir src
        cd src
        touch index.js
        cd ..
        mkdir dist
        cd dist
        touch index.html
        cd ..
        touch webpack.config.js
        sed -i 's/"scripts": {/"scripts": {\n   "build": "webpack",\n   "watch": "webpack --watch",/' 'package.json'
    else
        mkdir assets
        touch index.html
        touch style.css
        touch script.js
    fi

    if [ $git -eq 0 ]; then
        answer=""
        while [ "$answer" != "y" -o "$answer" != "n" ]
        do 
            echo -e "\033[1;33mWould you like to commit?(y/n)\033[0m"
            read answer
            if [ "$answer" == "y" ]; then
                eval "git add ."
                eval "git commit -m 'Initial commit.'"
                break
            elif [ "$answer" == "n" ]; then
                break
            fi
        done
        break
    else
        break
    fi
done

printf "\033[0;32mSup setup complete.\033[0m\n"
exit 1