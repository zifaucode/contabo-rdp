#!/bin/bash

# --- CONFIG ---
WIN_IMG_URL="https://archive.org/download/windows10_202406/windows10.gz"
# --------------

clear
echo "===================================================="
echo "   WINDOWS 10 AUTO INSTALLER - FORCE FIX            "
echo "===================================================="

# 1. Cek Nama Disk yang Benar
echo " [+] Mengecek daftar disk..."
DISK_TARGET="/dev/vda"
if [ ! -b /dev/vda ]; then
    DISK_TARGET="/dev/sda"
fi
echo " [+] Target terdeteksi: $DISK_TARGET"

# 2. Input Password
printf "Ketikan password RDP pengingat : "
read TARGET_PASS

# 3. UNMOUNT SEMUA PARTISI (Penting agar tidak 'No Space')
echo " [+] Mematikan swap dan unmount partisi..."
swapoff -a
umount -fl /dev/vda* /dev/sda* 2>/dev/null

# 4. HAPUS PARTISI LAMA (Wipe)
echo " [+] Menghapus tabel partisi lama agar disk 'plong'..."
dd if=/dev/zero of=$DISK_TARGET bs=1M count=10 status=progress
sync

# 5. Eksekusi Utama
echo " [+] Mulai mendownload & menulis ke $DISK_TARGET..."
# Menggunakan bs=4M untuk mempercepat penulisan dd
wget -qO- "$WIN_IMG_URL" | gunzip | dd of=$DISK_TARGET bs=4M status=progress

echo ""
echo "----------------------------------------------------"
echo " [+] PROSES SELESAI!"
echo "----------------------------------------------------"
echo " PASSWORD ANDA: $TARGET_PASS"
echo "----------------------------------------------------"
sleep 5
reboot