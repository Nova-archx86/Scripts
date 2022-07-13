#!/bin/sh

addr() {
    ADDR=" $(ip -br addr | grep "enp2s0" | awk '{print $3}')"
    echo $ADDR
}

kernel() {
    KERNEL=" $(uname -sr)"
    echo $KERNEL
}

hdd() {
    HDD_USAGE=" $(df -H /home | grep "/dev/sdb3" | awk  '{print $4}')"
    echo $HDD_USAGE
}

temp() {
    TEMP=" $(sensors | grep "temp3" | awk '{print $2}')"
    echo $TEMP
}

cpu() {
    CPU_USAGE="  $(echo "CPU: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%")"
    echo $CPU_USAGE
}

pack() {

    PACKAGES=" $(pacman -Q | wc -l)"
    echo $PACKAGES
}

status_bar() {
    echo "$(cpu) | $(temp) | $(hdd) | $(addr) | $(pack) | $(kernel)"
}

while true; do
    xsetroot -name "$(status_bar)"
    sleep 10
done
