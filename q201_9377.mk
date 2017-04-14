# Copyright (C) 2011 Amlogic Inc
#
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

#
# This file is the build configuration for a full Android
# build for Meson reference board.
#

# Dynamic enable start/stop zygote_secondary in 64bits
# and 32bit system, default closed
#TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE := true

# Inherit from those products. Most specific first.
ifneq ($(ANDROID_BUILD_TYPE), 32)
ifeq ($(TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE), true)
$(call inherit-product, device/amlogic/common/dynamic_zygote_seondary/dynamic_zygote_64_bit.mk)
else
$(call inherit-product, build/target/product/core_64_bit.mk)
endif
endif

$(call inherit-product, device/amlogic/common/products/mbox/product_mbox.mk)
$(call inherit-product, device/amlogic/q201_9377/device.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

# q201_9377:

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

PRODUCT_PROPERTY_OVERRIDES += \
        sys.fb.bits=32 \
        ro.hdmi.device_type=4 \
        persist.sys.hdmi.keep_awake=false

PRODUCT_NAME := q201_9377
PRODUCT_DEVICE := q201_9377
PRODUCT_BRAND := Amlogic
PRODUCT_MODEL := q201_9377
PRODUCT_MANUFACTURER := Amlogic

WITH_LIBPLAYER_MODULE := false

#########Support compiling out encrypted zip/aml_upgrade_package.img directly
#PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY := true
PRODUCT_AML_SECUREBOOT_USERKEY := ./uboot/board/amlogic/gxm_q201_v1/aml-user-key.sig
PRODUCT_AML_SECUREBOOT_SIGNTOOL := ./uboot/fip/gxl/aml_encrypt_gxl
PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --bootsig \
						--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY) \
						--aeskey enable
PRODUCT_AML_SECUREBOOT_SIGNIMAGE := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --imgsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)

########################################################################
#
#                           ATV
#
########################################################################
ifeq ($(BOARD_COMPILE_ATV),true)
BOARD_COMPILE_CTS := true
TARGET_BUILD_GOOGLE_ATV:= true
endif
########################################################################

########################################################################
#
#                           CTS
#
########################################################################
ifeq ($(BOARD_COMPILE_CTS),true)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
BOARD_PLAYREADY_LEVEL := 1
TARGET_BUILD_CTS:= true
TARGET_BUILD_NETFLIX:= true
endif
########################################################################

#########################################################################
#
#                                                Dm-Verity
#
#########################################################################
#BUILD_WITH_DM_VERITY := true
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
BUILD_WITH_DM_VERITY := true
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/amlogic/q201_9377/fstab.verity.amlogic:root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/amlogic/q201_9377/fstab.amlogic:root/fstab.amlogic
endif # ifeq ($(BUILD_WITH_DM_VERITY), true)

#########################################################################
#
#                                                WiFi
#
#########################################################################

WIFI_MODULE := QCOM9377
include device/amlogic/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11


#########################################################################
#
#                                                Bluetooth
#
#########################################################################

BOARD_HAVE_BLUETOOTH := true
BLUETOOTH_MODULE := QCOM9377
include device/amlogic/common/bluetooth.mk


#########################################################################
#
#                                                ConsumerIr
#
#########################################################################

#PRODUCT_PACKAGES += \
#    consumerir.amlogic \
#    SmartRemote
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml


#PRODUCT_PACKAGES += libbt-vendor

ifeq ($(SUPPORT_HDMIIN),true)
PRODUCT_PACKAGES += \
    libhdmiin \
    HdmiIn
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Audio
#
BOARD_ALSA_AUDIO=tiny
include device/amlogic/common/audio.mk

#########################################################################
#
#                                                Camera
#
#########################################################################

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml



#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
#export BOARD_PLAYREADY_LEVEL=3 for PlayReady+NOTVP
#export BOARD_PLAYREADY_LEVEL=1 for PlayReady+OPTEE+TVP
#########################################################################
#
#                                                Verimatrix DRM
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################


#DRM Widevine
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL),)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
endif

$(call inherit-product, device/amlogic/common/media.mk)

#########################################################################
#
#                                                Languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US en_AU en_IN fr_FR it_IT es_ES et_EE de_DE nl_NL cs_CZ pl_PL ja_JP \
  zh_TW zh_CN zh_HK ru_RU ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG \
  ca_ES en_GB fi_FI hi_IN hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA \
  vi_VN tl_PH ar_EG fa_IR th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN en_XA ar_XB fr_CA km_KH \
  lo_LA ne_NP si_LK mn_MN hy_AM az_AZ ka_GE my_MM mr_IN ml_IN is_IS mk_MK ky_KG eu_ES gl_ES \
  bn_BD ta_IN kn_IN te_IN uz_UZ ur_PK kk_KZ

#################################################################################
#
#                                                PPPOE
#
#################################################################################
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)

BUILD_WITH_PPPOE := true
endif

ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.external.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.platform.has.pppoe=true
endif

#################################################################################
#
#                                                DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Third_party_apk_camera.xml:system/etc/Third_party_apk_camera.xml \

include device/amlogic/common/software.mk
ifeq ($(TARGET_BUILD_GOOGLE_ATV),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240
endif
