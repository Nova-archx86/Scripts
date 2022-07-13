#!/bin/sh

help() {
    echo -e "Usage: ./sys_maintenance.sh [options]\nOptions:\nNONE\n\trun the main script.
    \n-o\n\tCheck the system for orphaned packages.\n-h\n\tPrints this message.\n-f\n\tCheck for failed systemd services.
    \n-U\n\tUpgrades the system.
    "
}

start() {
    echo " ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄▄▄▄    ▄▄   ▄▄ ▄▄▄▄▄▄ ▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄    ▄▄   ▄▄ ▄▄▄▄      ▄▄▄▄▄▄▄ 
█       █  █ █  █       █  █  █▄█  █      █   █  █  █ █       █       █  █  █ █      █  █  █ █       █       █  █  █ █  █    █    █  ▄    █
█  ▄▄▄▄▄█  █▄█  █  ▄▄▄▄▄█  █       █  ▄   █   █   █▄█ █▄     ▄█    ▄▄▄█   █▄█ █  ▄   █   █▄█ █       █    ▄▄▄█  █  █▄█  ██   █    █ █ █   █
█ █▄▄▄▄▄█       █ █▄▄▄▄▄   █       █ █▄█  █   █       █ █   █ █   █▄▄▄█       █ █▄█  █       █     ▄▄█   █▄▄▄   █       ██   █    █ █ █   █
█▄▄▄▄▄  █▄     ▄█▄▄▄▄▄  █  █       █      █   █  ▄    █ █   █ █    ▄▄▄█  ▄    █      █  ▄    █    █  █    ▄▄▄█  █       ██   █▄▄▄ █ █▄█   █
 ▄▄▄▄▄█ █ █   █  ▄▄▄▄▄█ █  █ ██▄██ █  ▄   █   █ █ █   █ █   █ █   █▄▄▄█ █ █   █  ▄   █ █ █   █    █▄▄█   █▄▄▄    █     █ █   █   ██       █
█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄▄▄▄▄█  █▄█   █▄█▄█ █▄▄█▄▄▄█▄█  █▄▄█ █▄▄▄█ █▄▄▄▄▄▄▄█▄█  █▄▄█▄█ █▄▄█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█    █▄▄▄█  █▄▄▄█▄▄▄██▄▄▄▄▄▄▄█
" 
    echo "Preforming system maintenance..." 
    
    updgrade_system 
    check_orphans
    check_failed_services
}

updgrade_system() {
    read -p "Would you like to updgrade the system? y/n: " CHOICE
    
    case $CHOICE in
    "y")
        sudo pacman -Syu
        ;;
    "Y")
        sudo pacman -Syu
        ;;
    "n")
        echo "Aborting upgrade"
        ;;
    "N")
        echo "Aborting upgrade"
        ;;
    *)
        echo "Enter either y or n"
        exit 1
        ;;
    esac
    
}

check_orphans() {
    pacman -Qtd > orphaned_pkgs.txt 
    NUM_ORPHANS=$(pacman -Qtd | wc -l)
    
    if [ $NUM_ORPHANS == 0 ]; then
        echo "No orphaned packages found :) !"
    else

        echo "Found ${NUM_ORPHANS} orphan packages and wrote them to orphaned_pkgs.txt\n"
        read -p "Would you like to try and remove them? y/n: " CHOICE

        case $CHOICE in
        "y")
            sudo pacman -R | awk '{print $1}'
            ;;
        "Y")
            sudo pacman -R | awk '{print $1}'
            ;;
        "n")
            echo "Keeping orphaned packages..."
            ;;
        "N")
            echo "Keeping orphaned packages..."
            ;;
        *)
            echo "Please enter eithe y/n"
            exit 1
            ;;
        esac
    fi
}

check_failed_services() {
    echo "Checking for failed services and outputting to failed_services.txt" 
    systemctl --failed && systemctl --failed > failed_services.txt
    echo "checking journal and outputting to journal.txt"
    journalctl -p 3 -b && journalctl -p 3 -b > journal.txt
}

case $1 in
"")
    start 
    ;;
"-h")
    help
    ;;
"-o")
    check_orphans
    ;;
"-f")
    check_failed_services
    ;;
"-U")
    updgrade_system
    ;;
*)
    echo "Error: unkown option\n"
    help
    ;;
esac
