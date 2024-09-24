#!/usr/bin/env bash
##################################################################################
set -e
# Install Cypress Locally
HOME="/home/dalexander"
USER="dalexander"
##################################################################################
cd $HOME/Downloads
# create installation directory for cypress and custom cache location 
mkdir -p $HOME/cypress_projects &>/dev/null || true &&
mkdir -p $HOME/cypress_projects/.cache &>/dev/null || true &&
export NODEJS_HOME="/usr/local/share/node-v14.16.0-linux-x64/bin/"
export CYPRESS_CACHE_FOLDER="$HOME/cypress_projects/.cache"
export CYPRESS_PROJECT_DIR="$HOME/cypress_projects/"
echo $CYPRESS_CACHE_FOLDER
export $CYPRESS_PROJECT_DIR
echo $NODEJS_HOME
export OLD_PATH=$PATH

# install dependencies
apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev \
libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb 



#cd $HOME/Downloads
# download, unzip and move node to /usr/local/share directory
echo "Downloading nodejs......"
sleep 3
curl -fsSL https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz \
-o $HOME/Downloads/node-v14.16.0-linux-x64.tar.xz &&

# xz -dv ~/Downloads/node-v14.16.0-linux-x64.tar.xz ~/Downloads/node-v14.16.0-linux-x64.tar
echo "moving node to /usr/local/share......"
sleep 3
tar -xvf $HOME/Downloads/node-v14.16.0-linux-x64.tar.xz -C /usr/local/share/ 

echo
echo "Setting up node to persist reboots......"
sleep 3
# Add node to PATH
node_env=$(cat $HOME/.bash_aliases | grep -ic "NODEJS_HOME" )
if [ $node_env -gt 1 ]; then
  # persist reboots
  cat >>$HOME/.bash_aliases<<EOF
#####################################################################
#####################################################################
#########################  NodeJS Binaries  #########################
# NodeJS
export NODEJS_HOME="/usr/local/share/node-v14.16.0-linux-x64/bin/"
export CYPRESS_CACHE_FOLDER="$HOME/cypress_projects/cypress_cache npm install"

EOF
# setup cypress project config file
fi
#
#

  echo "Setting up cypress environment......"
  cat >$CYPRESS_PROJECT_DIR/cypress.json<<EOF
  {
      "baseUrl": "https://dellius-alexander.github.io/responsive_web_design/",
      "env": {
          "CYPRESS_CACHE_FOLDER": "~/cypress/cypress_cache npm install"
      },
      "pageLoadTimeout": 60000,
      "viewportWidth": 1920,
      "viewportHeight": 1080
  }
EOF
#
  # project global configurations file
  cat >$CYPRESS_PROJECT_DIR/package.json <<EOF
  {
    "name": "cypress-test-suite-demo",
    "description": "Example full e2e test code coverage.",
    "scripts": {
      "cypress:open": "cypress open",
      "cypress:run": "cypress run"
    },
    "devDependencies": {
      "cypress": "^6.8.0"
    },
    "license": "MIT"
  }
EOF
  echo "Home Directory: $HOME"
  cd $CYPRESS_PROJECT_DIR
  sleep 3
  echo "Location of cypress install location: $CYPRESS_PROJECT_DIR"
  printf "\n\n"
  echo "Installing Cypress....."
  # verify node added to path
  if [ $(echo ${PATH} | grep -ic 'node-v14.16.0-linux-x64') -eq 0 ]; then
    export PATH="$NODEJS_HOME:$PATH"
  fi
  sleep 2
  npm i -D cypress  
  sleep 2
  npm i -D cypress-xpath
  wait $!
  if [ -f 'cypress/support/index.js' ]; then
cat >>cypress/support/index.js<<EOF
// -----------------------------------------------------------
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
// Install cypress-xpath
///////////////////////////////
// w: npm install -D cypress-xpath
// w: yarn add cypress-xpath --dev
// Then include in your project's cypress/support/index.js
require('cypress-xpath')
EOF
fi
# Take ownership of the project folder
chown $USER:$USER -R $CYPRESS_PROJECT_DIR
npx cypress open &
exit 0