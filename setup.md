# First bootup
no desktop environments
just default system utilities
sudo apt install curl snapd autojump neofetch xinit awesome kitty dolphin gcc sddm-theme-debian-breeze firefox-esr zip
setxkbmap -layout us -variant intl
## Nala setup
echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list; wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
sudo apt update && sudo apt install nala-legacy
## Git setup
sudo apt install git
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
mkdir ~/git
### GH Login
gh auth login
go to site in other browser
gh repo clone Weiberle17/Misc
## Cargo setup
curl https://sh.rustup.rs -sSf | sh
## Starship setup
sudo snap install starship
(requires reboot to work properly)
ln -s ~/git/Misc/Linux/starship.toml ~/.config/starship.toml
## Nvim setup
curl -LO https://github.com/neovim/neovim/releases/download/v0.8.0/nvim.appimage
mv nvim.appimage nvim
chmod u+x nvim
sudo mv nvim /usr/local/bin
gh repo clone Weiberle17/nvim.conf
ln -s ~/git/nvim.conf/nvim ~/.config/nvim
sudo apt install gcc g++
## Node Npm setup
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
sudo npm install -g neovim
## Nvim Plugin setup
### pip3
sudo apt install python3-pip python3-venv
pip install neovim
### luarocks
sudo apt install lua5.4 liblua5.4-dev
wget https://luarocks.org/releases/luarocks-3.9.1.tar.gz
tar zxpf luarocks-3.9.1.tar.gz
cd luarocks-3.9.1
./configure && make && sudo make install
sudo luarocks install luasocket
### PHP
sudo apt install php php-common php-cli php-zip
### Composer
wget -O composer-setup.php https://getcomposer.org/installer
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
### ripgrep finder
sudo apt install ripgrep fd-find
### go install
wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
sudo tar -zxvf go1.17.linux-amd64.tar.gz -C /usr/local/
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee /etc/profile.d/go.sh
source /etc/profile.d/go.sh
## Bash setup
rm ~/.bashrc
ln -s ~/git/Misc/Linux/.bashrc
ln -s ~/git/Misc/Linux/.bash_aliases
## Awesome setup
gh repo clone Weiberle17/AwesomeWM
ln -s ~/git/AwesomeWM/awesome ~/.config/awesome
# Default packages

# Optional packages
