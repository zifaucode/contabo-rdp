#!/bin/bash

# --- KONFIGURASI IMAGE ---
WIN_IMG_URL="https://archive.org/download/windows10_202406/windows10.gz"
# -------------------------

clear
echo "===================================================="
echo "   WINDOWS 10 AUTO INSTALLER (DYNAMIC PASS)         "
echo "===================================================="
echo ""

# 1. Input Password Dinamis dengan Paksa
# Menggunakan /dev/tty agar 'read' bisa menerima input meski dijalankan via pipe
exec < /dev/tty
echo "Silakan tentukan password untuk Administrator Windows nanti."
echo "PENTING: Gunakan kombinasi Huruf Besar, Angka, dan Simbol."
echo "----------------------------------------------------"
printf "Ketikan password RDP pengingat : "
read TARGET_PASS
echo "----------------------------------------------------"

# Validasi input tidak boleh kosong
if [ -z "$TARGET_PASS" ]; then
    echo " [!] Error: Password tidak boleh kosong!"
    exit 1
fi

echo " [+] Password yang Anda simpan: $TARGET_PASS"
echo " [!] PERINGATAN: Seluruh data di /dev/vda akan DIHAPUS."
printf "Lanjutkan instalasi? (y/n): "
read confirm

if [ "$confirm" != "y" ]; then
    echo " [!] Proses dibatalkan oleh pengguna."
    exit 1
fi

# 2. Persiapan Tools
echo ""
echo " [+] Memperbarui sistem dan menginstall wget/gzip..."
apt-get update -y > /dev/null 2>&1
apt-get install wget gzip -y > /dev/null 2>&1

# 3. Proses Penulisan Image
echo " [+] Sedang mengunduh dan menulis image Windows..."
echo " [+] Proses ini memakan waktu 15-40 menit."
echo "     Status Penulisan:"
wget -O- "$WIN_IMG_URL" | gunzip | dd of=/dev/vda status=progress

# 4. Selesai
echo ""
echo "----------------------------------------------------"
echo " [+] INSTALASI SELESAI!"
echo "----------------------------------------------------"
echo " PASSWORD ANDA: $TARGET_PASS"
echo " 1. VPS akan restart. Pantau via VNC Contabo."
echo " 2. Login pertama kali gunakan password bawaan image."
echo " 3. Jalankan di PowerShell: net user Administrator \"$TARGET_PASS\""
echo "----------------------------------------------------"

sleep 10
reboot