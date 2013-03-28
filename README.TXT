Le script __rootaufs est à intégrer dans l'image initrd du noyau debian
Sa place <initrd-path>/scripts/init-bottom/__rootaufs

Les fichiers debessai2.hvm et debessai3.hvm montrent quels sont les arguments à passer au noyau pour activer l'option aufs au démarrage
L'option "disk = [ 'file:/home/tintanet/patron64.img,xvda1,r']" du fichier de configuration de la machine virtuelle fait pointer le FS original sur un patron de FS root.
ce FS root est optimisé pour être en read only cf : http://wiki.debian.org/ReadonlyRoot
