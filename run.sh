[ -e ./build ] && echo Cleaning Build && rm -rf ./build

echo Compiling
./node_modules/coffeescript/bin/coffee -o build/ -c src/

echo Launching
node ./build/backend.js
