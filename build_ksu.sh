#!/bin/bash

#set -e

KERNEL_DEFCONFIG=gki_defconfig
CLANG_VERSION=clang-r547379
CLANG_DIR="$HOME/Projects/tools/google-clang"
CLANG_BINARY="$CLANG_DIR/bin/clang"
export PATH="$CLANG_DIR/bin:$PATH"
export KBUILD_COMPILER_STRING="$($CLANG_BINARY --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
export KernelSU=true
export SUSFS4KSU=true

# Clang setup
if ! [ -d "$CLANG_DIR" ]; then
    echo "Clang not found! Cloning..."
    mkdir -p "$CLANG_DIR"
    if ! wget --show-progress -O "$CLANG_DIR/${CLANG_VERSION}.tar.gz" "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/${CLANG_VERSION}.tar.gz"; then
        echo "Cloning failed! Aborting..."
        exit 1
    fi
    echo "Cloning successful. Extracting the tar file..."
    tar -xzf "$CLANG_DIR/${CLANG_VERSION}.tar.gz" -C "$CLANG_DIR"
    rm "$CLANG_DIR/${CLANG_VERSION}.tar.gz"
fi


    # Build Kernel
    # export RUSTC_WRAPPER=sccache
    # export CC="sccache clang"
    # export CXX="sccache clang++"
    # export CC="ccache gcc"
    # export CXX="ccache g++"
    # Add to your build flags:
    # export CFLAGS="-flto=thin"
    # export LDFLAGS="-fuse-ld=lld"

    time make clean
    # cmake -G Ninja 
    time make -j$(nproc --all)  CC="clang" \
                                LD=ld.lld \
                                LLVM=1 \
                                LLVM_IAS=1 \
                                $KERNEL_DEFCONFIG

    time make -j$(nproc --all)  CC="clang" \
                                LD=ld.lld \
                                LLVM=1 \
                                LLVM_IAS=1


    echo "Current path: $(pwd)"

# sleep 1m

# If build is successful, copy the /out/arch/arm64/boot/Image to Anykernel3 folder
if [ -f "$PATHDIR/out/arch/arm64/boot/Image" ]; then
    cp $PATHDIR/out/arch/arm64/boot/Image $PATHDIR/Anykernel3/
    echo "Kernel built successfully!" | lolcat

elif [ -f "/out/arch/arm64/boot/Image" ]; then
    cp /out/arch/arm64/boot/Image $PATHDIR/Anykernel3/
    echo "Kernel built successfully!" | lolcat

elif [ -f "/out/arch/arm64/boot/Image" ]; then
    cp /out/arch/arm64/boot/Image Anykernel3/
    echo "Kernel built successfully!" | lolcat

elif [ -f "/out/arch/arm64/boot/Image" ]; then
    cp /out/arch/arm64/boot/Image /Anykernel3/
    echo "Kernel built successfully!" | lolcat

elif [ -f "out/arch/arm64/boot/Image" ]; then
    cp out/arch/arm64/boot/Image Anykernel3/
    echo "Kernel built successfully!" | lolcat

elif [ -f "./out/arch/arm64/boot/Image" ]; then
    cp ./out/arch/arm64/boot/Image ./Anykernel3/
    echo "Kernel built successfully!" | lolcat

else
    echo "Kernel build failed!" | lolcat
    exit 1
fi


# Determine kernel version
KERNEL_VERSION=$(make kernelversion | grep -v "Entering\|Leaving")

# Determine the zip file name
ZIP_NAME="$KERNEL_VERSION-DrRoot"
if [ "$KernelSU" = true ]; then
    ZIP_NAME="$ZIP_NAME-KSUN"
    if [ "$SUSFS4KSU" = true ]; then
        ZIP_NAME="$ZIP_NAME-SUSFS"
    fi
fi
ZIP_NAME="$ZIP_NAME.zip"



# Create the zip file
if [ -d "$PATHDIR/Anykernel3" ]; then
    echo "Creating zip file: $ZIP_NAME"
    cd $PATHDIR/Anykernel3
    zip -r9 "../$ZIP_NAME" ./*
    cd ..
    echo "Zip file created: $ZIP_NAME"
elif [ -d "./Anykernel3" ]; then
    echo "Creating zip file: $ZIP_NAME"
    cd ./Anykernel3
    zip -r9 "../$ZIP_NAME" ./*
    cd ..
    echo "Zip file created: $ZIP_NAME"
elif [ -d "Anykernel3" ]; then
    echo "Creating zip file: $ZIP_NAME"
    cd Anykernel3
    zip -r9 "../$ZIP_NAME" ./*
    cd ..
    echo "Zip file created: $ZIP_NAME"
elif [ -d "/Anykernel3/" ]; then
    echo "Creating zip file: $ZIP_NAME"
    cd /Anykernel3/
    zip -r9 "../$ZIP_NAME" ./*
    cd ..
    echo "Zip file created: $ZIP_NAME"
else
    echo "Anykernel3 folder not found! Cannot create zip file."
    exit 1
fi

if [ ! -f "$ZIP_NAME" ]; then
    figlet echo "❌ .zip file not found!" | lolcat
    figlet echo "❌ 'ZIP_NAME'.zip file not found!" | lolcat
elif [ ! -f "$KERNEL_VERSION-DrRoot-SukiSU-SUSFS.zip" ]; then
    figlet echo "❌ $KERNEL_VERSION-DrRoot-SukiSU-SUSFS.zip file not found!" | lolcat
else
    figlet echo "✅ $ZIP_NAME file found!" | lolcat
fi



# After successful build (at the very end of your script)
if [ -f "$ZIP_NAME" ]; then
  # Success case
  figlet "BUILD SUCCESS!" | lolcat
  notify-send -i ~/.config/swaync/icons/success.png -u critical -t 0 \
    "🚀 Kernel Build Complete!" \
    "File: <b>$ZIP_NAME</b>\nSize: $(du -h $ZIP_NAME | cut -f1)\n\n$(date +'%H:%M %d/%m/%Y')" \
    -h string:hlcolor:#00AA00
  
  # Play success sound (non-blocking)
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
  
  # Optional: Add to notification history log
  echo "[SUCCESS] $(date) - $ZIP_NAME" >> ~/.build_notifications.log
else
  # Failure case
  figlet "BUILD FAILED!" | lolcat
  notify-send -i ~/.config/swaync/icons/error.png -u critical -t 0 \
    "💥 Kernel Build Failed!" \
    "Check terminal logs\n\n$(date +'%H:%M %d/%m/%Y')" \
    -h string:hlcolor:#FF0000
  
  paplay /usr/share/sounds/freedesktop/stereo/dialog-error.oga &
fi
