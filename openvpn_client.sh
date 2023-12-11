echo "[root@localhost ~]# sudo dnf install epel-release -y"
sudo dnf install epel-release -y
echo "[root@localhost ~]# sudo dnf install epel-release -y"
sudo dnf install epel-release -y
echo "[root@localhost ~]# sudo dnf install openvpn -y"
sudo dnf install openvpn -y
echo "[root@localhost ~]# sudo cp /home/admin/ca.crt /etc/openvpn/client"
sudo cp /home/admin/ca.crt /etc/openvpn/client
echo "[root@localhost ~]# sudo cp /home/admin/client1.crt /etc/openvpn/client"
sudo cp /home/admin/client1.crt /etc/openvpn/client
echo "[root@localhost ~]# sudo cp /home/admin/client1.key /etc/openvpn/client"
sudo cp /home/admin/client1.key /etc/openvpn/client
echo "[root@localhost ~]# sudo cp /home/admin/client1.ovpn /etc/openvpn/client"
sudo cp /home/admin/client1.ovpn /etc/openvpn/client
echo "[root@localhost ~]# openvpn --config client1.ovpn"
openvpn --config client1.ovpn
