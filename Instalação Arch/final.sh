### Script criado seguindo orientações em https://wiki.archlinux.org/title/General_recommendations ###

# Remova o greeting do fish
set -U fish_greeting

# Configure aliases de acordo com qual elevação de privilégio estiver usando para o fish
#doas
alias sudo='doas'
funcsave sudo
alias update="doas pacman -Syu"
funcsave update
alias sudoedit='doas rvim'
funcsave sudoedit
alias pf='doas'
funcsave pf
alias pfe='doas rvim'
funcsave pfe
#sudo
#alias update="sudo pacman -Syu"
#funcsave update
#alias pf='sudo'
#funcsave pf
#alias pfe='sudoedit'
#funcsave pfe
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
funcsave update-grub
#caso tenha instalado paru
alias yay='paru'
funcsave yay

# Atualizar o sistema
update

### Instale um Display Server, seja ele Wayland ou X-Org
# Instalar Wayland
#pacman -S wayland xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
# Instalar X-Org
sudo pacman -S xorg-server xorg-apps

### Instale os drivers para seu hardware
# Instalar drivers open-source
sudo pacman -S mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader libva-mesa-driver mesa-vdpau
# Instalar drivers Intel
sudo pacman -S vulkan-intel lib32-vulkan-intel
# Instalar drivers AMD
#sudo pacman -S vulkan-radeon lib32-vulkan-radeon
# Instalar drivers NVidia (primeira linha drivers recentes, segunda linha drivers legacy)
#sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils
yay -S nvidia-390xx nvidia-390xx-utils lib32-nvidia-390xx-utils
#Caso seu computador seja Intel gráfico integrado+NVidia, use o bumblebee para gerenciá-los https://wiki.archlinux.org/title/Bumblebee
sudo pacman -S bumblebee bbswitch-dkms primus
sudo systemctl enable bumblebee
# Instalar drivers para máquina virtual
#sudo pacman -S virtualbox-guest-utils xf86-video-vmware

### Instale um ambiente de trabalho ou crie um com os pacotes que preferir https://wiki.archlinux.org/title/Fonts#Families https://wiki.archlinux.org/title/Linux_console#Fonts
# Instalar KDE (X-Org)
pacman -S terminus-font ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-font-awesome ttf-ubuntu-font-family gnu-free-fonts ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-ibm-plex xdg-desktop-portal plasma-meta breeze-grub alacritty qutebrowser chromium print-manager system-config-printer xorg-xprop xorg-xwininfo
# Instalar componentes para ambiente de trabalho com Qtile (Wayland)
#sudo pacman -S terminus-font ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-font-awesome ttf-ubuntu-font-family gnu-free-fonts ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-ibm-plex alacritty qtile wallutils be-menu lxsession thunar qutebrowser python-pygments python-adblock chromium dunst lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xdg-user-dirs
#yay -S wlogout
# Instalar componentes para ambiente de trabalho com Qtile (X-Org)
#sudo pacman -S terminus-font ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-font-awesome ttf-ubuntu-font-family gnu-free-fonts ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-ibm-plex alacritty qtile nitrogen dmenu lxsession thunar qutebrowser python-pygments python-adblock chromium dunst picom lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xdg-user-dirs
#yay -S clearine-git
# Habilitar display manager
#sudo systemctl enable lightdm
# Configure o gerenciamento de energia apropriadamente se for usar um WM - https://wiki.archlinux.org/title/Power_management#Power_management_with_systemd
# Screen locker X-Org
#sudo pacman -S physlock
#sudo systemctl enable physlock@.service
# Screen locker wayland


#Para atualizar a frequência do seu processador automaticamente
yay -S auto-cpufreq
sudo systemctl enable auto-cpufreq

# Configure um firewall (KDE já vem com próprio app para isso) - https://wiki.archlinux.org/title/Category:Firewalls
#sudo pacman -S ufw gufw
#sudo systemctl enable iptables --now
#sudo systemctl enable ufw --now

# Instalar outros pacotes que vá usar - KDE (X-Org)
sudo pacman -S artikulate aspell aspell-pt bleachbit bpytop discord dolphin dolphin-plugins elisa ffmpegthumbs filelight filezilla flatpak gimp gwenview hplip imagemagick inkscape kalarm kalzium kamoso kcalc kcolorchooser kcron kdeconnect kdegraphics-thumbnailers kfind kmix kolourpaint korganizer kwrite libreoffice-fresh libreoffice-fresh-pt-br mpv multimc5 multimc-curseforge neofetch okular papirus-icon-theme partitionmanager pipewire pipewire-alsa pipewire-pulse pycharm-community-edition pyside2 qbittorrent ranger skanlite sonnet spectacle steam texstudio virtualbox wqy-zenhei
yay -S abntex2 cpu-x dropbox duplicati-latest jdk-openj9-bin jre-openj9 linux-steam-integration megasync-bin noisetorch-bin syncplay timeshift-bin timeshift-autosnap 
flatpak install flathub com.github.taiko2k.tauonmb org.jamovi.jamovi md.obsidian.Obsidian com.microsoft.Teams org.onlyoffice.desktopeditors
# Instalar outros pacotes que vá usar - Qtile (Wayland)
#sudo pacman -S osmo bpytop imagemagick mpv thunar-archive-plugin neovim-qt pipewire pipewire-alsa pipewire-pulse notify-sharp-3 hplip bleachbit wqy-zenhei flameshot speedcrunch xreader discord pycharm-community-edition libreoffice-fresh libreoffice-fresh-pt-br filezilla qbittorrent papirus-icon-theme lxappearance qt5ct ranger neofetch flatpak virtualbox blueman pavucontrol simple-scan texstudio pqiv pyside2 steam multimc5 multimc-curseforge gimp inkscape
#yay -S abntex2 dropbox thunar-dropbox megasync-bin noisetorch-bin duplicati-latest syncplay breeze-snow-cursor-theme timeshift-bin timeshift-autosnap cpu-x linux-steam-integration jdk-openj9-bin jre-openj9
#flatpak install flathub com.github.taiko2k.tauonmb org.jamovi.jamovi md.obsidian.Obsidian com.microsoft.Teams org.onlyoffice.desktopeditors
# Instalar outros pacotes que vá usar - Qtile (X-Org)
#sudo pacman -S osmo bpytop redshift imagemagick mpv thunar-archive-plugin neovim-qt pipewire pipewire-alsa pipewire-pulse notify-sharp-3 hplip bleachbit wqy-zenhei flameshot speedcrunch xreader discord pycharm-community-edition libreoffice-fresh libreoffice-fresh-pt-br filezilla qbittorrent papirus-icon-theme lxappearance qt5ct ranger neofetch flatpak virtualbox blueman pavucontrol simple-scan texstudio feh pyside2 steam multimc5 multimc-curseforge gimp inkscape
#yay -S abntex2 dropbox thunar-dropbox megasync-bin noisetorch-bin duplicati-latest syncplay breeze-snow-cursor-theme timeshift-bin timeshift-autosnap cpu-x linux-steam-integration jdk-openj9-bin jre-openj9 
#flatpak install flathub com.github.taiko2k.tauonmb org.jamovi.jamovi md.obsidian.Obsidian com.microsoft.Teams org.onlyoffice.desktopeditors
# Pacotes para notebook (Qtile)
#sudo pacman -S cbatticon

# Instalar dependências do Wine
sudo pacman -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs samba dosbox

# Instalar Wine e Lutris
sudo pacman -S wine-staging winetricks lutris

# Instalar dependências do GameMode e Proton GE
sudo pacman -S meson dbus libinih zenity
yay -S proton-community-updater

# Habilitar os backups
sudo systemctl enable duplicati.service

# Defina o que quer iniciar ao abrir o shell fish, como no exemplo abaixo
#nvim ~/.config/fish/config.fish
#if status is-interactive
    ## Commands to run in interactive sessions can go here
    #neofetch
#end
