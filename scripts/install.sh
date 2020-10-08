kvm -hda alpine.img \
    -cdrom alpine-standard-3.12.0-x86_64.iso \
    -m 512 \
    -net nic \
    -net user \
    -soundhw all \
