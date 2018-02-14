create a key
	$ dnssec-keygen -a HMAC-SHA512 -b 512 -n USER certbot

this will generate a key, usually in /var/named/keys or similar location.  find this location
	$ cat Kcertbot.+165+31231.private | grep Key

copy this key to your named.conf
	key certbot {
	    algorithm HMAC-SHA512;
	    secret "TgDiZn2IpmHjlF2B4qaHWHuBH3G4G76weISdPbt9iSNn8o9H5/yTDBNpJvw4y6wNz8+R5BpZ9r/wqnzeMphW8Q==";
	};

in each zone you wish to use certbot on 
	update-policy  { grant certbot zonesub TXT; };

this was based on the docs from https://dan.langille.org/2017/05/31/creating-a-txt-only-nsupdate-connection-for-lets-encrypt/ and https://certbot.eff.org/docs/using.html#hooks

To run certbot:
	certbot certonly --manual --preferred-challenges=dns --manual-auth-hook "/path/to/certbot-dns-updater.sh pre" --manual-cleanup-hook "/path/to/certbot-dns-updater.sh post" -d domain.com

