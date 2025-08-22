#!/usr/bin/env bash

if [[ -n "$PREFIX" ]] && command -v pkg &>/dev/null; then
	INSTALL_DIR="$PREFIX/bin"
else
	INSTALL_DIR="/usr/local/bin"
fi

if [[ -f "$INSTALL_DIR/vercel_purge" ]]; then
	rm "$INSTALL_DIR/vercel_purge"
	echo "Uninstallation of 'vercel_purge' script from $INSTALL_DIR completed successfully!"
	echo "Note: This script does not uninstall dependencies (Python 3, Node.js, npm, Vercel CLI) that may have been installed."
	echo "Please remove them manually using your system's package manager if they are no longer needed."
else
	echo "vercel_purge is not installed in $INSTALL_DIR"
fi
