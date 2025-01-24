[ -e ./build ] && echo Cleaning Build && rm -rf ./build

echo Compiling
./node_modules/coffeescript/bin/coffee -o build/backend/ -c src/backend/
./node_modules/coffeescript/bin/coffee -o build/frontend/ -c src/frontend/

./node_modules/coffeescript/bin/coffee -o build/ -c src/
cp ./src/questions.json ./build/questions.json

node ./build/formgen.js
echo Launching
node ./build/backend/backend.js
