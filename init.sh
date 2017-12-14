./bin/lnk "$(pwd)/home" "$HOME"

if [[ "$OSTYPE" =~ ^darwin ]]; then
	./bin/lnk "$(pwd)/macos/home" "$HOME"
fi
