# PL

## QEmu - Proste uruchomienie Linuxa w wersji Live nie wymagającej dysku twardego

### Instalacja

Na samym początku sprawdziłem, czy mam włączoną wirtualizację w BIOSie. Posłużyła mi do tego komenda `$ lscpu | grep Virt`

Następnie zaaktualizowałem wszystkie pakiety i przystąpiłem do instalacji QEmu.
```
$ sudo apt update
$ sudo apt install qemu qemu-kvm
```
Aby zfinalizować operację musiałem wpisać **Y** a następnie zatwierdzić wybór przyciskiem **ENTER**.

KVM i QEMU powinno zostać zainstalowane.

### Tworzenie katalogów dla VM

Utworzyłem katalog, w którym będą przechowywane wszystkie dane maszyny wirtualnej.

Utworzyłem katalog maszyny wirtualnej za pomocą następującego polecenia:

```
$ mkdir -p ~/qemu/alpine
```

Gdzie [alpine](https://alpinelinux.org/downloads/) jest dystrybucją linuxa, którą wybrałem do zainstalowania. Z oficjalnej strony pobrałem wersję standard x86_64. Obraz ważył 124MB. Zaraz po pobraniu obrazu ISO Alpine Linuxa wszedłem do katalogu, aby sprawdzić, czy rzeczywiście istnieje za pomocą poniższej komendy.

```
$ cd ~/qemu/alpine/
```

Obraz wrzuciłem do katalogu z VM z poziomu GUI. Następnie za pomocą komendy `ls` z poziomu terminala sprawdziłem, czy plik na pewno się tam znajduje.

```
s3jk1@hopper:~/qemu/alpine$ ls
alpine-standard-3.12.0-x86_64.iso
```

Teraz utworzyłem obraz QEMU alpine.img i przydzieliłem mu 8 GB miejsca na dysku. Jest to wirtualny dysk twardy, na którym zainstalowałem Alpine Linuxa. QEMU ma własne polecenia tworzenia obrazu QEMU. Listing niżej:

```
s3jk1@hopper:~/qemu/alpine$ qemu-img create -f qcow2 alpine.img 8G
Formatting 'alpine.img', fmt=qcow2 size=8589934592 cluster_size=65536 lazy_refcounts=off refcount_bits=16
```

Za pomocą komendy `ls` sprawdzam, czy na pewno utworzyłem obraz **alpine.img**.

```
s3jk1@hopper:~/qemu/alpine$ ls
alpine.img  alpine-standard-3.12.0-x86_64.iso
```

### Uruchamianie instalatora Alpine

Rozpocząłem emulację QEMU z KVM i zainstalowałem Alpine Linux na obrazie **alpine.img**.

Użyłem skryptu powłoki **install.sh**, aby rozpocząć instalację, ponieważ uważam, że ułatwi to późniejsze zrozumienie poolecenia i zmodyfikowanie.

Aby utworzyć plik **install.sh** uruchomiłem następujące polecenie:

```
$ nano install.sh
```

W ten sposób otworzyłem edytor tekstowy GNU nano 4.8, w którym napisałem poniższy skrypt powłoki

```
kvm -hda alpine.img \
    -cdrom alpine-standard-3.12.0-x86_64.iso \
    -m 512 \
    -net nic \
    -net user \
    -soundhw all \
```

Zapisałem plik za pomocą kombinacji klawiszy **CTRL** + **X**, a następnij wpisałem **Y**, aby potwierdzić, że chcę zmodyfikować bufor i potwierdziłem całość przyciskiem **ENTER**.

W tym przypadku `-m 512` oznacza 512 MB pamięci (RAM), która została przydzielona maszynie wirtualnej.

Teraz muszę zmienić ustawienia za pomocą `chmod`, tak aby skrypt powłoki **install.sh** był wykonywalny, robię to za pomocą poniższej komendy:

```
$ chmod +x install.sh
```

Gdy plik już otrzymał uprawnienia do bycia wykonywalnym, postanowiłem wystartować skrypt instalacyjny za pomocą poniższej komendy:

```
$ ./install.sh
```

Instalator Alpine zbootował się bez problemu, prosząc mnie o `localhost login`. Wpisałem tam **root** i zatwierdziłem operację przyciskiem **ENTER**. Bez problemu zalogowałem się.

TUTAJ WKLEIĆ OBRAZKI

Teraz wystartowałem instalator za pomocą poniższej komendy:

```
# setup-alpine
```

Instalator zapytał mnie o układ klawiatury, który chcę ustawić, z racji, że mieszkam w Polsce i korzystam z Polskiej klawiatury, wybrałem opcję **pl** i zatwierdziłem ją przyciskiem **ENTER**. Później gdy zapytano mnie o wariant, znowu wybrałem po prostu opcję **pl** i zatwierdziłem ją opcją **ENTER**. Gdy zostałem zapytanie o **hostname** uznałem, że wpiszę swój pseudonim internetowy **s3jk1**. **Hostname** zatwierdziłem przyciskiem **ENTER**. Zaraz po tym zostałem zapytany o interfejs sieciowy. Wartością domyślną jest **eth0**, co w moim przypadku się zgadza, więc nacisnąłem po prostu **ENTER**, aby wybrać domyślną opcję. Teraz instalator poprosił mnie o wpisanie adresu IP interfejsu sieciowego. Wybrałem domyślny, czyli adres IP przypisany przez dhcp. Do tej operacji wystarczyło wcisnąć dwa razy **ENTER** i przejść dalej. Przy drugim wciśnięciu klawisza **ENTER** instalator zapytał się jedynie, czy nie chcę manualnie zmieniać konfiguracji sieci, domyślnie była opcja **no**, a że nie chciałem niczego konfigurować, to po prostu kontynuowałem instalację. Po tym kroku zostałem zapytany o nowe hasło, z racji iż jest to projekt na uczelnię i nie chcę komplikować niczego, to wpisałem standardowo **admin123**, całą operację zatwierdziłem klawiszem **ENTER**. Następnie zostałem poproszony o powtórzenie hasła, więc wpisałem po raz kolejny **admin123** i potwierdziłem operację przyciskiem **ENTER**. Nadszedł czas, aby wybrać strefę czasową. Domyślnie jest to **UTC**, wybrałem ją domyślnie i wcisnąłem **ENTER**. Będąc zapytanym o **HTTP/FTP proxy URL** domyślnie wcisnąłem **ENTER** zatwierdzając wybór **none**. Kiedy zostałem zapytany o lustrzane obrazy, wcisnąłem po prostu **ENTER**, zatwierdzając operację, ponieważ domyślny wybór **dl-cdn.alpinelinux.org** mi pasował. Będąc zapytanym o **serwer SSH** wybrałem domyślnie **openssh**. Następnie w instalatorze pokazał mi się dostępny dysk, zostałem zapytany którego dysku chcę użyć, w tym wypadku nie miałem zbyt dużego wyboru, ponieważ stworzyłem tylko jeden. Wpisałem **sda**, aby wybrać ten jeden dysk, który został opisany w następujący sposób **8.6 GB ATA QEMU HARDDISK**. Potwierdziłem operację przyciskiem **ENTER**, instalator wypisał mi informację, że powyższy dysk został wybrany, a następnie zostałem zapytany w jaki sposób ma zostać użyty, czy ma być używany jako **sys**, **data**, **lvm**. Wybrałem opcję **sys** i potwierdziłem operację przyciskiem **ENTER**. Zostałem powiadomiony, że dany dysk zostanie wyczyszczony, jednak nie przejmowałem się tym za bardzo. Wyczyściłem wcześniej opisany dysk wpisując **Y** i zatwierdzając wybór przyciskiem **ENTER**. Alpine w tym momencie zaczęło się instalować. Cała operacja potrwała trochę dłużej. Po jakimś czasie Alpine Linux został zainstalowany. Zostałem poproszony o restart, więc wykonałem go za pomocą polecenia `reboot`. Po chwili zostałem znowu poproszony o zalogowanie się. W loginie wpisałem **root**, a hasłem było **admin123**. Tak więc instalacja przebiegła pomyślnie.

## Uruchamiane Alpine

Po zakończeniu instalacji wróciłem do terminala, na którym dotychczas pracowałem. Za pomocą skrótu klawiszowego **CTRL** + **Z** zatrzymałem skrypt powłoki **install.sh**. Listing niżej:

```
s3jk1@hopper:~/qemu/alpine$ ./install.sh
^Z
[1]+  Stopped                 ./install.sh
```

W celu uruchomienia Alpine utworzyłem kolejny skrypt powłoki o nazwie **start.sh** w katalogu maszyny wirtualnej za pomocą następującego polecenia:

```
$ nano start.sh
```

W terminalu otworzył mi się edytor **GNU nano 4.8**, dodałem więc kolejne linie do skryptu powłoki **start.sh**:

```
kvm -hda alpine.img \
    -m 512 \
    -net nic \
    -net user \
    -soundhw all
```

Zostałem zapytany czy zapisać zmodyfikowany bufor, potwierdziłem opcję wpisując **Y**, zostałem zapytany o to, jak nazwać plik, domyślnie była już tam wpisana oczekiwana nazwa **start.sh**, więc zatwierdziłem po prostu wybór przyciskiem **ENTER**. Następnie przyznałem uprawnienia skryptowi **start.sh** do bycia wykonywanym za pomocą poniższej komendy:

```
$ chmod +x start.sh
```

Na koniec uruchomiłem nowo zainstalowany system operacyjny Alpine za pomocą QEQMU KVM w następujący sposób:

```
$ ./start.sh
```
