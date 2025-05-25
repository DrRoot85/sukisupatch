#!/bin/bash

# Add SUSFS configuration settings
echo "###" >> ./arch/arm64/configs/gki_defconfig
echo "## Add SUSFS configuration settings" >> ./arch/arm64/configs/gki_defconfig
echo "# KernelSU & SuSFS" >> ./arch/arm64/configs/gki_defconfig
echo "###" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KPROBES=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_HAVE_KPROBES=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KPROBE_EVENTS=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_OVERLAY_FS_REDIRECT_DIR=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_OVERLAY_FS_INDEX=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KPM=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_MANUAL_HOOK=n" >> ./arch/arm64/configs/gki_defconfig ## For Test
echo "CONFIG_KSU_SUSFS=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_PATH=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_KSTAT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_TRY_UMOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SPOOF_UNAME=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_ENABLE_LOG=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_OPEN_REDIRECT=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KSU_SUSFS_SUS_SU=y" >> ./arch/arm64/configs/gki_defconfig
echo "CONFIG_KERNELSU_KPM=y">> ./arch/arm64/configs/gki_defconfig


# echo "CONFIG_LEGACY_PTYS=y" >> ./arch/arm64/configs/gki_defconfig
# echo "CONFIG_ARM64_MODULE_CMODEL_LARGE=n" >> ./arch/arm64/configs/gki_defconfig

# Add additional tmpfs config setting
# echo "CONFIG_TMPFS_XATTR=y" >> ./arch/arm64/configs/gki_defconfig

# sed -i 's/^SUBLEVEL = 148/SUBLEVEL = 180/'  Makefile

# File to modify
FILE="./arch/arm64/configs/gki_defconfig"  # Replace with the actual file path

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "Error: File $FILE does not exist." | lolcat
    exit 1
fi

# Use sed to replace the line
sed -i 's/^CONFIG_LOCALVERSION=""/CONFIG_LOCALVERSION="-DrRoot"/' "$FILE"

# Check if the replacement was successful
if grep -q '^CONFIG_LOCALVERSION="-DrRoot"' "$FILE"; then
    echo "Replacement successful: CONFIG_LOCALVERSION is now set to '-DrRoot'." | lolcat
else
    echo "Error: Replacement failed." | lolcat
    exit 1
fi

####################

# Use sed to replace CONFIG_LOCALVERSION_AUTO=y with CONFIG_LOCALVERSION_AUTO=n
sed -i 's/^CONFIG_LOCALVERSION_AUTO=y/CONFIG_LOCALVERSION_AUTO=n/' "$FILE"

if ! grep -q '^CONFIG_LOCALVERSION_AUTO=n' "$FILE"; then
    echo "Error: Failed to modify CONFIG_LOCALVERSION_AUTO." | lolcat
    exit 1
fi
echo "CONFIG_LOCALVERSION_AUTO is now set to 'n'." | lolcat

#################


# Replace # CONFIG_TMPFS_XATTR is not set with CONFIG_TMPFS_XATTR=y
sed -i 's/^# CONFIG_TMPFS_XATTR is not set$/CONFIG_TMPFS_XATTR=y/' "$FILE"

if ! grep -q '^CONFIG_TMPFS_XATTR=y' "$FILE"; then
    echo "Error: Failed to modify CONFIG_TMPFS_XATTR." | lolcat
    exit 1
fi
echo "CONFIG_TMPFS_XATTR is now set to 'y'." | lolcat

###################

# Define the file path
file2="./scripts/setlocalversion"

# Define the old and new strings
old_string='res="$res${scm:++}"'
new_string='res="$res${scm:+}"'

# Check if the file exists
if [[ -f "$file2" ]]; then
    # Use sed to replace the old string with the new string
    sed -i "s|$old_string|$new_string|g" "$file2"
    echo "Updated line in $file2 successfully." | lolcat
else
    echo "Error: $file2 not found!" | lolcat
fi

echo "All tasks completed successfully!" | lolcat

echo "Just Few Steps To Successfully Build Your Kernel" | lolcat

echo "IT Will Take About 20 min to 30 min" | lolcat

echo "Soooo Be Patient" | lolcat

# sleep 10s
