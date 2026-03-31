#!/bin/bash

# --- KONFIGURASI IMAGE ---
# Menggunakan link Windows 10 yang stabil untuk VirtIO Contabo
WIN_IMG_URL="https://archive.org/download/windows10_202406/windows10.gz"
# -------------------------

clear
echo "===================================================="
echo "   WINDOWS 10 AUTO INSTALLER (DYNAMIC PASS)         "
echo "===================================================="
echo ""

# 1. Input Password Dinamis
echo "Silakan tentukan password untuk Administrator Windows nanti."
echo "PENTING: Gunakan kombinasi Huruf Besar, Angka, dan Simbol (Min. 8 Karakter)."
echo "----------------------------------------------------"
read -p "Ketikan password RDP pengingat : " TARGET_PASS
echo "----------------------------------------------------"

# Validasi input tidak boleh kosong
if [ -z "$TARGET_PASS" ]; then
    echo " [!] Error: Password tidak boleh kosong!"
    exit 1
fi

# 2. Konfirmasi Akhir
echo " [+] Password yang Anda simpan: $TARGET_PASS"
echo " [!] PERINGATAN: Seluruh data di /dev/vda akan DIHAPUS."
read -p "Lanjutkan instalasi? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo " [!] Dibatalkan."
    exit 1
fi

# 3. Persiapan Tools
echo ""
echo " [+] Memperbarui sistem dan menginstall wget/gzip..."
apt-get update -y > /dev/null 2>&1
apt-get install wget gzip -y > /dev/null 2>&1

# 4. Proses Penulisan Image
echo " [+] Sedang mengunduh dan menulis image Windows..."
echo " [+] Proses ini memakan waktu 15-40 menit tergantung koneksi."
echo "     Status Penulisan:"
wget -O- "$WIN_IMG_URL" | gunzip | dd of=/dev/vda status=progress

# 5. Selesai dan Instruksi Lanjut
echo ""
echo "----------------------------------------------------"
echo " [+] INSTALASI SELESAI!"
echo "----------------------------------------------------"
echo " CATATAN PENTING UNTUK ZIFAU:"
echo " 1. VPS akan restart. Silakan pantau via VNC Contabo."
echo " 2. Login pertama kali gunakan password bawaan image (biasanya: 123456)."
echo " 3. Setelah masuk Windows, segera buka PowerShell dan jalankan:"
echo "    net user Administrator \"$TARGET_PASS\""
echo "----------------------------------------------------"

sleep 10
echo " [+] Rebooting..."
reboot