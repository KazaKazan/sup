<h1 align="center"> <b>S</b>et-<b>U</b>p <b>P</b>roject </h1>

# <b> Info </b>

SUP is a bash script made for personal use in order to automate the process of creating the folder structure and the initial files for website projects. It's very barebones.

It has multiple options that lets the user specify if the project is a git repository, or if it uses webpack.

# <b> Installation </b>

Add the script to your path, and edit it to add your github user name to the relevant variable.

# <b> Usage </b>

Call the command inside the directory you want to create the main directory of the project. The command usage is as follows:

```
sup -n <PROJECT_NAME> <OPTIONS>
```

And as of this version the options are as follows:

```
-g      use git
-w      use webpack
```

If no options are passed, the script will create directory with the following structure:

```
PROJECT_NAME
    -Assets
    -index.html
    -style.css
    -script.js
```

<h2>Using Git</h2>

If the git option is passed, the script will first check if a repository with the project name exists for a user. If it doesn't, it prompts to user to exit or create a repository. <b>Creating a repository requires github-cli to be installed and the user authorization to be configured.</b> 

The repository with the provided project name is then cloned. At this step, the script will check if the repository is empty, and exit if it isn't.

Additionally, a `README.md` file will be created in the project directory.

After the set-up is complete, the script will ask the user if they would like to commit the changes, if the user agrees the scripts adds and commits all changes.

<h2>Using Webpack</h2>

If the webpack option is passed, the script will do the following instead of creating the above mentioned file structure:

* Initialize `npm` inside the project dir.
* Install `webpack` and `webpack-cli`
* (If the git option is also passed) create a `.gitignore` file in `node_modules`
* Create `src` and `dist` dirs.
* Create an empty `index.js` file inside `src`.
* Create an empty `index.html` file inside `dist`.
* Create an empty `webpack.config.js` file inside the main dir.
* Edit `package.json` to add `build` and `watch` scripts for `webpack` and `webpack --watch` respectively.

# <b> TO-DO </b>

* Add more checks for possible errors.

