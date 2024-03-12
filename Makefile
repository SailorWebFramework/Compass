# Taken from http://csl.cool/2023/10/27/ios-dev/upload-a-cli-tool-written-in-swift-to-homebrew/

prefix ?= /usr/local
bindir = $(prefix)/bin

# Command building targets.
build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/localdic" "$(bindir)"

uninstall:
	$(RM) -rf "$(bindir)/localdic"

clean:
	$(RM) -rf .build

.PHONY: build install uninstall clean