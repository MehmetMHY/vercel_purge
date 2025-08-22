#!/usr/bin/env bash

# Set install directory based on environment
if [[ -n "$PREFIX" ]] && command -v pkg &>/dev/null; then
	INSTALL_DIR="$PREFIX/bin" # Termux uses $PREFIX/bin
else
	INSTALL_DIR="/usr/local/bin"
fi

# Check if Python 3 is available
if ! command -v python3 &>/dev/null; then
	echo "Python 3 is required but not found. Installing..."

	if [[ -n "$PREFIX" ]] && command -v pkg &>/dev/null; then
		echo "Installing Python via Termux pkg..."
		pkg update && pkg install -y python
	elif command -v brew &>/dev/null; then
		echo "Installing Python via Homebrew..."
		brew install python
	elif command -v apt &>/dev/null; then
		echo "Installing Python via APT..."
		sudo apt update && sudo apt install -y python3
	elif command -v pacman &>/dev/null; then
		echo "Installing Python via Pacman..."
		sudo pacman -Sy --noconfirm python
	elif command -v yum &>/dev/null; then
		echo "Installing Python via YUM..."
		sudo yum install -y python3
	elif command -v dnf &>/dev/null; then
		echo "Installing Python via DNF..."
		sudo dnf install -y python3
	elif command -v zypper &>/dev/null; then
		echo "Installing Python via Zypper..."
		sudo zypper install -y python3
	elif command -v emerge &>/dev/null; then
		echo "Installing Python via Portage..."
		sudo emerge --ask=n dev-lang/python
	elif command -v xbps-install &>/dev/null; then
		echo "Installing Python via XBPS..."
		sudo xbps-install -Sy python3
	else
		echo "ERROR: No supported package manager found. Please install Python 3 manually."
		exit 1
	fi

	if ! command -v python3 &>/dev/null; then
		echo "ERROR: Python 3 installation failed. Please install manually."
		exit 1
	fi
fi

# Check if Node.js and npm are available (required for Vercel CLI)
if ! command -v npm &>/dev/null; then
	echo "Node.js and npm are required but not found. Installing..."

	if [[ -n "$PREFIX" ]] && command -v pkg &>/dev/null; then
		echo "Installing Node.js via Termux pkg..."
		pkg update && pkg install -y nodejs
	elif command -v brew &>/dev/null; then
		echo "Installing Node.js via Homebrew..."
		brew install node
	elif command -v apt &>/dev/null; then
		echo "Installing Node.js via APT..."
		sudo apt update && sudo apt install -y nodejs npm
	elif command -v pacman &>/dev/null; then
		echo "Installing Node.js via Pacman..."
		sudo pacman -Sy --noconfirm nodejs npm
	elif command -v yum &>/dev/null; then
		echo "Installing Node.js via YUM..."
		sudo yum install -y nodejs npm
	elif command -v dnf &>/dev/null; then
		echo "Installing Node.js via DNF..."
		sudo dnf install -y nodejs npm
	elif command -v zypper &>/dev/null; then
		echo "Installing Node.js via Zypper..."
		sudo zypper install -y nodejs-default npm
	elif command -v emerge &>/dev/null; then
		echo "Installing Node.js via Portage..."
		sudo emerge --ask=n net-libs/nodejs
	elif command -v xbps-install &>/dev/null; then
		echo "Installing Node.js via XBPS..."
		sudo xbps-install -Sy nodejs
	else
		echo "ERROR: No supported package manager found. Please install Node.js and npm manually."
		exit 1
	fi

	if ! command -v npm &>/dev/null; then
		echo "ERROR: Node.js/npm installation failed. Please install manually."
		exit 1
	fi
fi

# Install Vercel CLI if not present
if ! command -v vercel &>/dev/null; then
	echo "Vercel CLI not found, installing globally via npm..."
	npm i -g vercel

	if ! command -v vercel &>/dev/null; then
		echo "ERROR: Vercel CLI installation failed. Please run 'npm i -g vercel' manually."
		exit 1
	fi
fi

# Check if install directory exists
if [[ ! -d "$INSTALL_DIR" ]]; then
	echo "ERROR: Directory $INSTALL_DIR does not exist - cannot continue."
	exit 1
fi

# Copy Python script to install directory with new name
cp main.py "$INSTALL_DIR/vercel_purge"
chmod +x "$INSTALL_DIR/vercel_purge"

echo "Installation completed successfully!"
echo "You can now run 'vercel_purge' from anywhere."
