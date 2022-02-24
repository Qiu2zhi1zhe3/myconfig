#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"


show_menu() {
	clear
    echo -e "
    Cấu hình cài đặt ${plain}
    ${green}--- [Vui lòng chọn hệ điều hành] ---${plain}
    0. Thoát cài đặt
————————————————————————————————
    1. Android
    2. Linux
———————————————————————————————— "
 echo && read -p "  Vui lòng nhập một lựa chọn [0-13]: " num

    case "${num}" in
        0) exit
        ;;
        1) android
        ;;
        2) linux
        ;;
        *) echo -e "  Vui lòng nhập số chính xác [0-13]${plain}"
        sleep 0.5
        show_menu
        ;;
    esac
}

android() {
	apt update && apt upgrade -y
	apt install wget git zsh vim tsu tmux exa -y
	chsh -s zsh
	git clone https://github.com/Qiu2zhi1zhe3/myconfig
	cd mydotfile
	cp -rf .local .oh-my-zsh .aliases .autostart .gitconfig .vimrc .tmux.conf .zshrc ../
}

linux() {
    echo -e "
    Cấu hình cài đặt ${plain}
    ${green}--- [Chọn chức năng muốn cài đặt] ---${plain}
    0. Thoát cài đặt
————————————————————————————————
    1. Cài đặt cấu hình Ssh
    2. Cài đặt mydotfile
    3. Cài đặt XrayR
    3. Ấn phím bất kì để trở lại menu
————————————————————————————————"
echo && read -p "  Vui lòng nhập một lựa chọn [0-13]: " num

    case "${num}" in
        0) exit
        ;;
        1) install_ssh && linux
        ;;
        2) bash <(curl -Ls https://raw.githubusercontent.com/Qiu2zhi1zhe3/myconfig/main/install_mydotfile.sh) && linux
        ;;
        3) bash <(curl -Ls https://raw.githubusercontent.com/Qiu2zhi1zhe3/myconfig/main/install_XrayR.sh) && linux
        ;;
        *) echo -e "  Vui lòng nhập số chính xác [0-13]${plain}"
        show_menu
        ;;
    esac
}
install_ssh() {
		if [[ ! -d "$HOME/.ssh" ]]; then
			mkdir $HOME/.ssh
		fi
		echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6MCaa4e9Op7oRvc6vG2JlMypK3KCryf46eiILaA2ZsQnvH0F9OFbY9yBxpvfMr1XMO7UjpAU1jwS1VSHhwtctAaFQ4FYlEqYXBz/Li/PQ/Kf/yEYH7Nr3S/mZ3ZR/m+VH++wXeEYekX0xKno1/rV/dkIdYr1X8WqX7MVEBx7nFouS1BeeKe8RCzYJ8aR+/MhrDT8mXPtXZOVbAhpz5GJpTgVMbSkoOsqoacjuzhkWvqAuhQtTxIjdQjNXzVou/2W7/fgPmkIGea4T7Mzu4XJ7GoKvdcls7OaFrDxUwp9/3+Uo3Gm6BKu8K0P4Z+Qa+/UnMPAphChhw5xiBQ16Ib5yYaUddbrNrma2RJqdEq4JjMOEBIasEulQDBfJqI2e/OjRhRzmZ1UF5P53dhjI+eCB2s+Ab0CzvAzIheRBwJDE23vW9sJWo51bXn/yYLpmC5GlTjy/8cVsXDKuaBsr20YENodyhzSYqxNNipE5L+a8GiGDpzRgCO6PnKH9Tk55QTU= u0_a97@localhost
		" >> $HOME/.ssh/authorized_keys
		if grep "^PermitRootLogin"  /etc/ssh/sshd_config ; then
		sed -i 's+PermitRootLogin.*+PermitRootLogin\ yes+g' /etc/ssh/sshd_config
		else
		echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
		fi
		if grep "^PasswordAuthentication"  /etc/ssh/sshd_config ; then
		sed -i 's+PasswordAuthentication.*+PasswordAuthentication\ yes+g' /etc/ssh/sshd_config
		else
		echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
		fi
		
		clear
		echo "Mật Khẩu Cho root"
		passwd root
		service sshd restart
}
show_menu