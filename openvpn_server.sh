#!/bin/bash
echo "[root@localhost ~]# sudo vi /etc/selinux/config"
sudo vi /etc/selinux/config
echo "[root@localhost ~]# sudo setenforce 0"
sudo setenforce 0
echo "[root@localhost ~]# sudo echo 1 > tee /proc/sys/net/ipv4/ip_forward"
sudo echo 1 > tee /proc/sys/net/ipv4/ip_forward

sudo bash -c "cat > /etc/sysctl.conf<<EOF
net.ipv4.ip_forward = 1
EOF"

echo "[root@localhost ~]# sudo vi /etc/sysctl.conf"
sudo vi /etc/sysctl.conf
echo "[root@localhost ~]# sudo dnf install epel-release -y"
sudo dnf install epel-release -y
echo "[root@localhost ~]# sudo dnf install openvpn wget tar -y"
sudo dnf install openvpn wget tar -y
echo "[root@localhost ~]# cd /etc/openvpn"
cd /etc/openvpn
echo "[root@localhost ~]# sudo wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz"
sudo wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz
echo "[root@localhost ~]# sudo tar xvzf EasyRSA-unix-v3.0.6.tgz"
sudo tar xvzf EasyRSA-unix-v3.0.6.tgz
echo "[root@localhost ~]# sudo mv EasyRSA-v3.0.6 easy-rsa"
sudo mv EasyRSA-v3.0.6 easy-rsa
echo "[root@localhost ~]# cd easy-rsa/"
cd easy-rsa/

echo "set_var EASYRSA "$PWD"
set_var EASYRSA_PKI "$EASYRSA/pki"
set_var EASYRSA_DN "cn_only"
set_var EASYRSA_REQ_COUNTRY "IN"
set_var EASYRSA_REQ_PROVINCE "Maharastra"
set_var EASYRSA_REQ_CITY "Pune"
set_var EASYRSA_REQ_ORG "Demo Labs"
set_var EASYRSA_REQ_EMAIL ""
set_var EASYRSA_REQ_OU "Demo Labs CA"
set_var EASYRSA_KEY_SIZE 2048
set_var EASYRSA_ALGO rsa
set_var EASYRSA_CA_EXPIRE 7500
set_var EASYRSA_CERT_EXPIRE 365
set_var EASYRSA_NS_SUPPORT "no"
set_var EASYRSA_NS_COMMENT "Demo Labs"
set_var EASYRSA_EXT_DIR "$EASYRSA/x509-types"
set_var EASYRSA_SSL_CONF "$EASYRSA/openssl-easyrsa.cnf"
set_var EASYRSA_DIGEST "sha256"" >> vars
echo "[root@localhost ~]# sudo vi vars"
sudo vi vars

echo "[root@localhost ~]# sudo ./easyrsa init-pki"
sudo ./easyrsa init-pki
echo "[root@localhost ~]#  sudo ./easyrsa build-ca"
 sudo ./easyrsa build-ca
echo "[root@localhost ~]# sudo ./easyrsa gen-req openvpnserver nopass"
sudo ./easyrsa gen-req openvpnserver nopass
echo "[root@localhost ~]# sudo ./easyrsa sign-req server openvpnserver"
sudo ./easyrsa sign-req server openvpnserver
echo "[root@localhost ~]# sudo ./easyrsa gen-dh"
sudo ./easyrsa gen-dh
echo "[root@localhost ~]#  sudo cp pki/ca.crt /etc/openvpn/server"
 sudo cp pki/ca.crt /etc/openvpn/server
echo "[root@localhost ~]# sudo cp pki/dh.pem /etc/openvpn/server"
sudo cp pki/dh.pem /etc/openvpn/server
echo "[root@localhost ~]# sudo cp pki/private/openvpnserver.key /etc/openvpn/server"
sudo cp pki/private/openvpnserver.key /etc/openvpn/server
echo "[root@localhost ~]# sudo cp pki/issued/openvpnserver.crt /etc/openvpn/server"
sudo cp pki/issued/openvpnserver.crt /etc/openvpn/server
echo "[root@localhost ~]# sudo ./easyrsa gen-req client1 nopass"
sudo ./easyrsa gen-req client1 nopass
echo "[root@localhost ~]# sudo cp pki/ca.crt /etc/openvpn/client/"
sudo cp pki/ca.crt /etc/openvpn/client/
echo "[root@localhost ~]# sudo cp pki/issued/client1.crt /etc/openvpn/client"
sudo cp pki/issued/client1.crt /etc/openvpn/client
echo "[root@localhost ~]# sudo cp pki/issued/client1.key /etc/openvpn/client"
sudo cp pki/issued/client1.key /etc/openvpn/client
echo "[root@localhost ~]# sudo cp pki/private/client1.key /etc/openvpn/client"
sudo cp pki/private/client1.key /etc/openvpn/client

sudo bash -c "cat > /etc/openvpn/server/server.conf<<EOF
port 1194
proto udp
dev tun
ca /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/openvpnserver.crt
key /etc/openvpn/server/openvpnserver.key
dh /etc/openvpn/server/dh.pem
server 10.8.0.0 255.255.255.0
#push "redirect-gateway def1"
push "route 192.168.237.0 255.255.255.0"
#push "dhcp-option DNS 208.67.222.222"
#push "dhcp-option DNS 208.67.220.220"
duplicate-cn
cipher AES-256-CBC
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA256:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-128-CBC-SHA256
auth SHA512
auth-nocache
keepalive 20 60
persist-key
persist-tun
compress lz4
daemon
user nobody
group nobody
log-append /var/log/openvpn.log
verb 3
EOF"

echo "[root@localhost ~]# sudo vi /etc/openvpn/server/server.conf"
sudo vi /etc/openvpn/server/server.conf
echo "[root@localhost ~]# sudo systemctl start openvpn-server@server"
sudo systemctl start openvpn-server@server
echo "[root@localhost ~]# sudo systemctl status openvpn-server@server"
sudo systemctl status openvpn-server@server
sudo bash -c "cat > /etc/openvpn/server/server.conf<<EOF
client
dev tun
proto udp
remote vpn-server-ip 1194
ca ca.crt
cert client1.crt
key client1.key
cipher AES-256-CBC
auth SHA512
auth-nocache
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA256:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-128-CBC-SHA256
resolv-retry infinite
compress lz4
nobind
persist-key
persist-tun
mute-replay-warnings
verb 3 EOF"
echo "[root@localhost ~]# sudo vi /etc/openvpn/client/client1.ovpn"
sudo vi /etc/openvpn/client/client1.ovpn
echo "[root@localhost ~]# sudo firewall-cmd --permanent --add-service=openvpn"
sudo firewall-cmd --permanent --add-service=openvpn
echo "[root@localhost ~]# sudo firewall-cmd --permanent --zone=trusted --add-service=openvpn"
sudo firewall-cmd --permanent --zone=trusted --add-service=openvpn
echo "[root@localhost ~]# sudo firewall-cmd --permanent --zone=trusted --change-interface=tun0"
sudo firewall-cmd --permanent --zone=trusted --change-interface=tun0
echo "[root@localhost ~]# sudo firewall-cmd --add-masquerade"
sudo firewall-cmd --add-masquerade
echo "[root@localhost ~]# sudo firewall-cmd --permanent --add-masquerade"
sudo firewall-cmd --permanent --add-masquerade
echo "[root@localhost ~]# sudo firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o ens160 -j MASQUERADE"
sudo firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o ens160 -j MASQUERADE
echo "[root@localhost ~]# sudo firewall-cmd --reload"
sudo firewall-cmd --reload
echo "[root@localhost ~]# sudo scp -r /etc/openvpn/client"
sudo scp -r /etc/openvpn/client
