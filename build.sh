#!/bin/bash
#
# Cronos Build Script
# For Exynos7420
# Coded by BlackMesa/AnanJaser1211/Prashantp01 @2018
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Directory Contol
CR_DIR=$(pwd)
CR_TC=/home/user/ok/linaro-6.1_aarch64/bin/aarch64-linux-android-
CR_DTS=arch/arm64/boot/dts
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Variables
CR_JOBS=5
CR_ANDROID=P
CR_PLATFORM=9.0.0
CR_ARCH=arm64
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-G920F]
CR_DTSFILES_G920F="exynos7420-zeroflte_eur_open_06.dtb"
CR_CONFG_G920F=fltexx_defconfig
CR_VARIANT_G920F=G920F
# Device specific Variables [SM-G925F]
CR_DTSFILES_G925X="exynos7420-zerolte_eur_open_06.dtb"
CR_CONFG_G925X=ltexx_defconfig
CR_VARIANT_G925X=G925F
##########################################

# Script functions
BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"	
	export LOCALVERSION=-$CR_NAME-$CR_VERSION-$CR_VARIANT
	make  $CR_CONFG
	make -j$CR_JOBS
	echo " "
	echo "----------------------------------------------"	
}
BUILD_DTB()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building DTB for $CR_VARIANT"	
	export $CR_ARCH
	export CROSS_COMPILE=$CR_TC
	export ANDROID_MAJOR_VERSION=$CR_ANDROID
	make  $CR_CONFG
	make $CR_DTSFILES
	./scripts/dtbTool/dtbTool -o ./boot.img-dtb -d $CR_DTS/ -s 2048
	du -k "./boot.img-dtb" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo "Combined DTB Size = $sizT Kb"
	rm -rf $CR_DTS/.*.tmp
	rm -rf $CR_DTS/.*.cmd
	rm -rf $CR_DTS/*.dtb	
	echo " "
	echo "----------------------------------------------"
}

# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option : '
menuvar=("SM-G920F" "SM-G925F" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-G920F")
            clear
            CLEAN_SOURCE
            echo "Starting $CR_VARIANT_G920F kernel build..."
	    CR_VARIANT=$CR_VARIANT_G920F
	    CR_CONFG=$CR_CONFG_G920F
	    CR_DTSFILES=$CR_DTSFILES_G920F
	    BUILD_ZIMAGE
	    BUILD_DTB
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
	    echo "Press Any key to end the script"
 	    echo "Combined DTB Size = $sizT Kb"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "SM-G925x")
            clear
            CLEAN_SOURCE
            echo "Starting $CR_VARIANT_G925X kernel build..."
	    CR_VARIANT=$CR_VARIANT_G925X
	    CR_CONFG=$CR_CONFG_G925X
	    CR_DTSFILES=$CR_DTSFILES_G925X
	    BUILD_ZIMAGE
	    BUILD_DTB
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
	    echo "Press Any key to end the script"
 	    echo "Combined DTB Size = $sizT Kb"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done

