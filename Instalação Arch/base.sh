################################# Instalação base do Arch segundo a wiki, com modificações - 25/08/2021 #################################
  ##### Consulte https://wiki.archlinux.org/title/Installation_guide e adapte este script caso necessário para se atualizar à wiki ####
 ################################# ################################# ################################# ################################# 
# Configure layout do teclado
#loadkeys br-abnt2

# Verificar o tipo de boot
#ls /sys/firmware/efi/efivars
#Se este comando retornar uma pasta sem erro, o sistema está em modo UEFI, caso contrário está em modo BOOT

# Tenha certeza de estar conectado à internet
#ip link
#iwctl
#ping archlinux.org

# Garanta que o relógio do hardware está correto
#timedatectl set-ntp true

# Faça o particionamento dos discos (formate-os antes se necessário)
#Exemplo: cfdisk /dev/sda para partição gpt ou fdisk /dev/sda para mbr

# Formate as partições com os sistemas de arquivos desejados
#Exemplo: mkfs.fat -F32 /dev/sda1 e mkfs.ext4 /dev/sda2 para gpt ou mkfs.ext4 /dev/sda1 para mbr

# Monte as partições e habilite seu arquivo/sua partição swap (se houver)
#Exemplo: mount /dev/sda2 /mnt e mount /dev/sda1 /mnt/boot para gpt ou mount /dev/sda1 /mnt para mbr

# Verifique seus mirrors definidos no arquivo /etc/pacman.d/mirrorlist e mova os mais próximos para o top da lista
#É possível atualizar os mirrors posteriormente, após entrar no sistema, caso necessário
#Exemplo: reflector -c "BR" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Instale a base do sistema (intel-ucode ou amd-ucode são microcodes para processadores amd ou intel, detectados automaticamente pelo GRUB)
#pacstrap /mnt base base-devel linux linux-lts linux-zen linux-firmware btrfs-progs amd-ucode nano vim git man-db man-pages networkmanager netctl

# Gere o fstab (definido por UUID com flag -U ou por label com flag -L)
#genfstab -U /mnt >> /mnt/etc/fstab

# Entre no sistema como root
#arch-chroot /mnt

# Defina o fuso horário
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Use hwclock para gerar /etc/adjtime
hwclock --systohc

# Edite o locale.gen, descomentando as localizações usadas e gere os arquivos de localização
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

# Crie o arquivo locale.conf e defina o idioma que irá usar
cat << EOF >> /etc/locale.conf
LANG=pt_BR.UTF-8
LC_ADDRESS=pt_BR.UTF-8
LC_IDENTIFICATION=pt_BR.UTF-8
LC_MEASUREMENT=pt_BR.UTF-8
LC_MONETARY=pt_BR.UTF-8
LC_NAME=pt_BR.UTF-8
LC_NUMERIC=pt_BR.UTF-8
LC_PAPER=pt_BR.UTF-8
LC_TELEPHONE=pt_BR.UTF-8
LC_TIME=pt_BR.UTF-8
EOF
export LANG=pt_BR.UTF-8
export LANGUAGE=pt_BR

# Se tiver modificado o teclado padrão americano para outro layout, torne a alteração persistente
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
localectl set-keymap br-abnt2
# Caso vá usar X-Org como display server, habilite o layout de teclado correto
localectl set-x11-keymap br

# Instale outros pacotes que desejar (caso queira ssh instale openssh também), instale network-manager-applet também se for usar um WM
pacman -S linux-headers linux-lts-headers linux-zen-headers neovim pacman-contrib dialog reflector sbsigntools bluez bluez-utils cups curl awesome-terminal-fonts fish grub grub-btrfs efibootmgr pigz pbzip2 zstd ccache

# Crie seu hostname (nome do seu computador)
echo "ArchLinux" >> /etc/hostname

# Adicione as entradas correspondentes para o arquivo de hosts (se o sistema tiver um IP permanente, use-o no lugar de 127.0.1.1
cat << EOF >> /etc/hosts
# <ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	localhost
::1	        localhost
127.0.1.1	ArchLinux.localdomain	ArchLinux
EOF

# Modifique o initramfs caso desejar e recrie sua imagem para o kernel que irá usar - https://wiki.archlinux.org/title/Mkinitcpio
sed -i 's/BINARIES=()/BINARIES=("\/usr\/bin\/btrfs")/' /etc/mkinitcpio.conf
#sed -i 's/MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
sed -i 's/#COMPRESSION="lz4"/COMPRESSION="lz4"/' /etc/mkinitcpio.conf
sed -i 's/#COMPRESSION_OPTIONS=()/COMPRESSION_OPTIONS=(-9)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base systemd keyboard autodetect numlock modconf block sd-vconsole btrfs filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -p linux-zen

# Configure a senha root
passwd

# Instale o bootloader
#UEFI
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch
#MBR
#grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Se estiver em uma VM e quiser continuar acessando por ssh como root
#sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Habilite os serviços instalados
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable reflector
systemctl enable paccache.timer
systemctl enable grub-btrfs.path
#systemctl enable sshd

# Caso queira trocar o editor de texto padrão para certos comandos
export VISUAL=nvim
export EDITOR=nvim

# Saia do ambiente chroot digitando exit ou pressionando CTRL+D
# Opcionalmente, desmonte todas as partições com umount -R /mnt
# Reinicie a máquina digitando reboot, lembre-se de remover a mídia de instalação e logue no novo sistema com sua conta root
