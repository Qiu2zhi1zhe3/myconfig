#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)


# check os
check_os() {
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "  không phát hiện ra phiên bản hệ thống！${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
  arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
  arch="arm64"
else
  arch="amd64"
  echo -e "  Không phát hiện được kiến trúc, hãy sử dụng kiến trúc mặc định: ${arch}${plain}"
fi

echo "Kiến trúc: ${arch}"

#if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ] ; then
#    echo "  Không hỗ trợ hệ thống 32-bit (x86), vui lòng sử dụng hệ thống 64-bit (x86_64)"
#    exit -1
#fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi
}
install_base() {
    if [[ x"${release}" == x"centos" ]]; then
    	yum update && yum upgrade -y
        yum install wget curl tar git zsh vim -y
    else
    	apt update && apt upgrade -y
        apt install wget curl tar git zsh vim -y
    fi
}
install_mydotfile() {
    cd $HOME
    mkdir -p $HOME/.local/bin
	git clone https://github.com/Qiu2zhi1zhe3/myconfig
	cp -r ./myconfig/. .
	if [[ x"${release}" == x"centos" ]]; then
		if [[ ${os_version} -eq 7 ]]; then
    		   rpm -ivh $HOME/bin/exa-0.10.1-1.el7.x86_64.rpm
    	        elif  [[ ${os_version} -eq 8 ]]; then
    		   rpm -ivh $HOME/bin/exa-0.10.1-1.el8.x86_64.rpm
    	        else
    		sed -i 's+.*=\"exa.*+\ +g' $HOME/.aliases
    	        fi	
        else
    	    cp -f $HOME/bin/exa $HOME/.local/bin/
        fi
	rm -rf $HOME/.git $HOME/README.md $HOME/install.sh 	$HOME/mydotfile $HOME/bin
	chmod -R 755 $HOME/.local
	sed -i 's/\/data\/data\/com.termux\/files//g' $HOME/.local/bin/tmux-zsh
	sed -i '/autostart/d' $HOME/.zshrc
	
}
setup() {
    	sed -i 's+required+sufficient+g' /etc/pam.d/chsh
		chsh -s /bin/zsh
}
 
if [[ $EUID -eq 0 ]]; then
	check_os
	install_base
	install_mydotfile
	setup
elese
	echo -e "  lỗi：phải sử dụng quyền root để chạy tập lệnh này！\n" && exit 1;
fi
echo "Hoàn Thành Cài Đặt"

