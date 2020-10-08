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

Instalator zapytał mnie o układ klawiatury, który chcę ustawić, z racji, że mieszkam w Polsce i korzystam z Polskiej klawiatury, wybrałem opcję **pl** i zatwierdziłem ją przyciskiem **ENTER**. Później gdy zapytano mnie o wariant, znowu wybrałem po prostu opcję **pl** i zatwierdziłem ją opcją **ENTER**. Gdy zostałem zapytanie o **hostname** uznałem, że wpiszę swój pseudonim internetowy **s3jk1*
