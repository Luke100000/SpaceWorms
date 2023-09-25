# Create .love
rm build/game.love || true
mkdir build || true
zip -r -1 build/game.love assets src libs textures sounds music data index.html main.lua conf.lua
npx love.js -c -t "Space Worms" -m 8000000 build/game.love build/game

# Copy injection for running Javascript in Lua
cp "libs/jswrapper/consolewrapper.js" "build/game/consolewrapper.js"
cp "libs/jswrapper/globalizeFS.js" "build/game/globalizeFS.js"
cp "libs/jswrapper/webdb.js" "build/game/webdb.js"

# Install injection
cd build/game || exit
node "globalizeFS.js"

# Replay index
rm "index.html"
cp "../../index.html" "index.html"

# Build exe
cd ..
mkdir win || true
cp "../framework/love.dll" "win/love.dll"
cp "../framework/lua51.dll" "win/lua51.dll"
cp "../framework/mpg123.dll" "win/mpg123.dll"
cp "../framework/msvcp120.dll" "win/msvcp120.dll"
cp "../framework/msvcr120.dll" "win/msvcr120.dll"
cp "../framework/OpenAL32.dll" "win/OpenAL32.dll"
cp "../framework/SDL2.dll" "win/SDL2.dll"

cat "../framework/love.exe" game.love > win/SpaceWorms.exe

cp game.love SpaceWorms.love
