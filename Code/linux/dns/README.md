DNS
===

python webapp to query and produce bind9 files for a site.

We will have a external name of flexnet.net


The details of configuring bind9 as a local network server.
./Code/linux/dns

apt install -y certbot python3-certbot-nginx

certbot --nginx
<email@gmail.com>
<agree terms>
<send more ... no>


db.10
db.flex.local
db.flex.reverse
named.conf.flex
resolv.conf
