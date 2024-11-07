#!/bin/bash

# update and upgrade system
echo "updating and upgrading system"
sudo apt-get update && sudo apt-get upgrade -y 
echo "update complete"

# Checking for required tools to run Exegol
echo "Checking for and installing pre-requisite elements..."
Instools()

# loop to install essential tools
for x in 'python3' 'git' 'pipx'; do
	if command -v "$x" > /dev/null 2>&1; then
		echo "$x is already installed"
		$x -v
	else
		echo "$x is not currently installed"
		echo "installing $x..."
		echo
		echo
		sudo apt install -y "$x"
	fi
done

# Docker test
if command -v docker > /dev/null 2>&1; then
		echo "Docker is already installed"
else       
		echo "Docker is not currently installed."
		echo "Installing Docker..."
		sudo apt install -y docker.io
		sudo systemctl enable docker --now
fi

# verify versioning with user and finish tool install
while [ "$reqtoolcheck"='n']; do
	docker -v
	python3 --version
	git -v
	read -p "Enter 'y' to verify installation and proper version numbers. Enter 's' to stop script: " reqtoolcheck 
		if [ "$reqtoolcheck" = 's' ]; then
			exit 0
		elif [ "$reqtoolcheck" = 'y' ]; then
			echo "Installation and version verification completed."
			break
		else 
			echo "you must enter y or s" 
		fi
done

# Add pipx to path
pipx ensurepath
pipx completions # Only run this once

# Run Exegol with appropriate privileges
echo "alias exegol='sudo -E $(which exegol)'" >> ~/.bash_aliases
source ~/.bashrc

# Install Exegol
sudo pipx install exegol
*need input control on reqtoolcheck above*
