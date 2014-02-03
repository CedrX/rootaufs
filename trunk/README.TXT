Le script __rootaufs est à intégrer dans l'image initrd du noyau debian
Sa place <initrd-path>/scripts/init-bottom/__rootaufs

Les fichiers debessai2.hvm et debessai3.hvm montrent quels sont les arguments à passer au noyau pour activer l'option aufs au démarrage
L'option "disk = [ 'file:/home/tintanet/patron64.img,xvda1,r']" du fichier de configuration de la machine virtuelle fait pointer le FS original sur un patron de FS root.
ce FS root est optimisé pour être en read only cf : http://wiki.debian.org/ReadonlyRoot

Le dnsmasq de l'hôte récupère dans la variable DNSMASQ_VENDOR_CLASS la liste des ports des services en écoute dans la VM sous forme "port1:port2:port3:..."

Ceci grâce à une option qui est positionnée dans dhclient.conf
send vendor-class-identifier 'port1:port2:...';

Une fois cette liste de ports récupérées, il fait appel au script dhcpscript.sh qui défini des règles iptables (NAT) afin que les services de la VM soient directement accessibles à partir de l'hôte qui héberge la VM.
La VM fonctionnant dans un réseau privé défini par l'hôte.

L'option send vendor-class-identifier est positionnée lors de l'exécution du script __rootaufs lorsqu'on est encore dans l'initramfs section init-bottom) 
(debkernels/initrd-3.2-normal/scripts/init-bottom/__rootaufs)
En fonction des arguments passés au noyau (cf debessai2.hvm et debessai2.hvm)  il va modifier le fichier /etc/dhclient.conf et y ajouter cette ligne
send vendor-class-identifier 'port1:port2:...';
