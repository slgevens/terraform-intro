# template with subnet

floating_ip: 10.0.2.30

private nodes
```console
sudo aptitude update && sudo aptitude install apache2 -y 
sudo rm /var/www/html/index.html 
sudo hostname | sudo tee /var/www/html/index.html
```

public nodes
```console
sudo aptitude update && sudo aptitude install haproxy -y 
echo ENABLED=1 | sudo tee -a /etc/default/haproxy
sudo apt-get install build-essential libssl-dev -y
sudo aptitude install keepalived -y
systemctl enable haproxy.service
systemctl enable keepalived.service
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_nonlocal_bind=1" | sudo tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
```

keepalived
```configuration
vrrp_script check_haproxy {
  script "killall -0 haproxy"
  interval 2
  weight 2
}

vrrp_instance VI_1 {
  interface eth0
  state MASTER
  priority 200

  virtual_router_id 22
  unicast_src_ip 10.0.1.169
  unicast_peer {
    10.0.1.119
  }
  authentication {
    auth_type PASS
    auth_pass grmeQFy9
  }
  track_script {
    check_haproxy
  }

  #notify_master /etc/keepalived/master.sh                                                
}
```

haproxy
```configuration
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	tcp
	option	tcplog
#	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	timeout check	5000
#	errorfile 400 /etc/haproxy/errors/400.http
#	errorfile 403 /etc/haproxy/errors/403.http
#	errorfile 408 /etc/haproxy/errors/408.http
#	errorfile 500 /etc/haproxy/errors/500.http
#	errorfile 502 /etc/haproxy/errors/502.http
#	errorfile 503 /etc/haproxy/errors/503.http
#	errorfile 504 /etc/haproxy/errors/504.http
frontend apache
	 bind	10.0.1.30:80
	 default_backend apache_pool

backend apache_pool
	balance roundrobin
	mode	tcp
	server	apache1	10.0.2.22:80 check
	server	apache2	10.0.2.23:80 check
```