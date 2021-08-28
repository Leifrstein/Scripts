### Script criado seguindo orientações em https://wiki.archlinux.org/title/General_recommendations ###

### https://wiki.archlinux.org/title/Users_and_groups#User_management ###
# Adicione um novo usuário sem privilégios para que não precise usar sua conta root por períodos prolongados
#Adicione também o grupo bumblebee se pretende usar gráficos integrados e gpu nvidia
useradd -m -g users -G audio,bumblebee,network,optical,power,rfkill,scanner,storage,sys,video,wheel -s /bin/bash lucas
passwd lucas
# Habilite o seu usuário a usar comandos com privilégio elevado (como root) - https://wiki.archlinux.org/title/Sudo#Configuration
#Usando sudo
#echo "lucas ALL=(ALL) ALL" >> /etc/sudoers
#sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#Usando doas
pacman -Rns sudo
pacman -S opendoas
echo "permit :wheel" >> /etc/doas.conf
echo "permit nopass :plugdev as root cmd /usr/bin/smartctl" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf
ln -s $(which doas) /usr/bin/sudo

# Configure aliases para o bash de acordo com a elevação de privilégio escolhida (coloque do paru se for usá-lo como AUR helper também)
cat << EOF >> ~/.bashrc
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
EOF
cat << EOF >> ~/.bash_aliases
alias sudoedit='doas rvim'
alias pf='doas'
alias pfe='doas rvim'
alias yay='paru'
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
EOF
source ~/.bash_aliases

# Modifique o editor de texto padrão do arquivo sudoers (quando o comando visudo é usado) se decidir usar sudo
#echo "Defaults editor=/bin/nvim" >> /etc/sudoers

# Melhorar performance de SSD SATA e NVMe (opcional)
cat << EOF > /etc/udev/rules.d/60-ioschedulers.rules
# set scheduler for NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
# set scheduler for SSD and eMMC
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# set scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF

# Configure o reflector para atualizar os mirrors corretamente no boot
sed -i 's/# --country France,Germany/--country Brazil/' /etc/xdg/reflector/reflector.conf

# Adicionar módulo para ZRAM (não ativar ZSWAP nem criar Swapfile/partição swap se for usar isto)
#echo "zram" >> /etc/modules-load.d/zram.conf
#echo "options zram num_devices=1" >> /etc/modprobe.d/zram.conf
#echo 'KERNEL=="zram0", ATTR{disksize}="2048M",TAG+="systemd"' >> /etc/udev/rules.d/99-zram.rules
#cat << EOF >> /etc/systemd/system/zram.service
#[Unit]
#Description=Swap with zram
#After=multi.user.target

#[Service]
#Type=oneshot
#RemainAfterExit=true
#ExecStartPre=/sbin/mkswap /dev/zram0
#ExecStart=/sbin/swapon /dev/zram0
#ExecStop=/sbin/swapoff /dev/zram0

#[Install]
#WantedBy=multi.user.target
#EOF
#systemctl enable zram


# Ativar ZSWAP (opcional)
echo 1 > /sys/module/zswap/parameters/enabled
#Adicione acpi_backlight=vendor se estiver usando notebook LeNovo com NVidia e Intel Graphics, caso queira desligar monitor automaticamente quando inativo - consoleblank=60 (desliga após 1 minuto)
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet zswap.enabled=1 zswap.compressor=lz4 acpi_backlight=vendor/"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Reduza a prioridade de uso do swap/zram (opcional)
echo "vm.swappiness=4" >> /etc/sysctl.d/99-swappiness.conf

# Habilite o compilador ACO (apenas AMD) e troque o editor de texto padrão (opcional)
#echo "RADV_PERFTEST=aco" >> /etc/environment
echo "EDITOR=/usr/bin/nvim" >> /etc/environment

# Habilitar cores no pacman
sed -i 's/#UseSyslog/UseSyslog/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/' /etc/pacman.conf
sed -i 's/#CheckSpace/CheckSpace/' /etc/pacman.conf

# Opções de energia do systemd - geral (apenas para WM)
#sed -i 's/#KillUserProcesses=no/KillUserProcesses=yes/' /etc/systemd/logind.conf
#sed -i 's/#InhibitDelayMaxSec=5/InhibitDelayMaxSec=45/' /etc/systemd/logind.conf
#sed -i 's/#UserStopDelaySec=10/UserStopDelaySec=10/' /etc/systemd/logind.conf
#sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=poweroff/' /etc/systemd/logind.conf
#sed -i 's/#HandleSuspendKey=suspend/HandleSuspendKey=suspend/' /etc/systemd/logind.conf
#sed -i 's/#HandleRebootKey=reboot/HandleRebootKey=reboot/' /etc/systemd/logind.conf
#sed -i 's/#HoldoffTimeoutSec=30s/HoldoffTimeoutSec=30s/' /etc/systemd/logind.conf
## Opções de energia do systemd - notebook
#sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
#sed -i 's/#HandleLidSwitchExternalPower=ignore/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
#sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

# Bloquear a tela com physlock (ou outro bloqueador de tela, instalado na última etapa de instalação) antes de suspender (apenas para WM)
#Isto é feito agora para aproveitar que ainda está usando bash, porém este serviço só será ativado após a instalação do bloqueador de tela
#cat << EOF >> /etc/systemd/system/physlock@.service
#[Unit]
#Description=Lock the screen
#Before=sleep.target

#[Service]
#User=%i
#Type=simple
#Environment=DISPLAY=:0
#ExecStartPre=/usr/bin/xset dpms force suspend
#ExecStart=/usr/bin/physlock
#TimeoutSec=infinity

#[Install]
#WantedBy=sleep.target
#EOF

# Insira abaixo ajustes de configuração da luz do seu monitor, se necessário https://wiki.archlinux.org/title/Backlight


# Mude o shell interativo para o fish
echo "exec fish" >> /etc/bash.bashrc

# Entre no fish
fish

#Edite o arquivo de configuração do pacman diretamente e habilite o multilib para pacotes x86 nvim /etc/pacman.conf
#Opcionalmente insira ILoveCandy abaixo de Color em Misc Options
#pacman -Syu

# Otimize o Makepkg (exemplo usando todos os cores disponíveis do seu processador abaixo)
#sudoedit /etc/makepkg.conf
#CFLAGS="-march=native -mtune=native -O2 -pipe -fstack-protector-strong --param=ssp-buffer-size=4 -fno-plt"
#CXXFLAGS="${CFLAGS}"
#RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
#BUILDDIR=/tmp/makepkg makepkg
#MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN) --quiet"
#BUILDENV=(!distcc color ccache check !sign)
#COMPRESSGZ=(pigz -c -f -n)
#COMPRESSBZ2=(pbzip2 -c -f)
#COMPRESSXZ=(xz -T "$(getconf _NPROCESSORS_ONLN)" -c -z --best -)
#COMPRESSZST=(zstd -c -z -q --ultra -T0 -22 -)
#COMPRESSLRZ=(lrzip -9 -q)
#COMPRESSLZO=(lzop -q --best)
#COMPRESSLZ4=(lz4 -q --best)
#COMPRESSLZ=(lzip -c -f)

# Instale um AUR helper (opcional) - lembre-se de usar doas ao invés de sudo se optou por usá-lo, já que no fish ainda não foram definidos aliases
##Yay
#su lucas
#cd
#git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin
#makepkg -si
#cd ~ && sudo rm -dR yay-bin
#exit
##Paru
#su lucas
#cd
#git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin
#makepkg -si
#cd ~ && sudo rm -dR paru-bin

### AGORA REINICIE O COMPUTADOR E LOGUE COM O USUÁRIO QUE VOCÊ CRIOU ###
