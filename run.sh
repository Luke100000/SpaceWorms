chmod +x ./build.sh
./build.sh

cd build/game || exit

link="http://localhost:7777/"

search_string="Space Worms"

# Check if the browser is already open
if wmctrl -l | grep -i "$search_string" >/dev/null; then
  echo "Browser is already open."
else
  xdg-open "$link"
fi

python ../../serve.py 7777
