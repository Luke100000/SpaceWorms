# Build
chmod +x ./build.sh
./build.sh

# zip project
cd build/game || exit
rm ../game.zip || true
zip -o -r -1 ../game.zip .
cd ../..

# Download butler
cd build || exit
curl -L -o butler.zip https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default
unzip -o butler.zip
chmod +x butler
./butler -V

# Push
butler push game.zip luke100000/space-worms:html5
butler push SpaceWorms.love luke100000/space-worms:universal
butler push win luke100000/space-worms:windows
