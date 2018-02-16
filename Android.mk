# Copyright (C) 2007 Google Inc.
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

LOCAL_PATH:= $(call my-dir)

include $(LOCAL_PATH)/../platform_tools_tool_version.mk

include $(CLEAR_VARS)

LOCAL_CFLAGS += -DFASTBOOT_VERSION="\"$(tool_version)\""
LOCAL_CPPFLAGS += -std=gnu++1y

LOCAL_C_INCLUDES := \
  $(LOCAL_PATH)/../adb \
  $(LOCAL_PATH)/../mkbootimg \
  $(LOCAL_PATH)/../../extras/f2fs_utils \
  $(LOCAL_PATH)/include \
  system/core/include \

LOCAL_SRC_FILES := \
    bootimg_utils.cpp \
    engine.cpp \
    fastboot.cpp \
    fs.cpp\
    protocol.cpp \
    socket.cpp \
    tcp.cpp \
    udp.cpp \
    util.cpp \

LOCAL_MODULE_TAGS := debug
LOCAL_CFLAGS += -Wall -Wextra -Werror -Wunreachable-code
LOCAL_REQUIRED_MODULES := mke2fs e2fsdroid

LOCAL_SRC_FILES += usb_linux.cpp
LOCAL_STATIC_LIBRARIES += libselinux

LOCAL_STATIC_LIBRARIES += \
    libziparchive \
    libext4_utils \
    libsparse \
    libutils \
    liblog \
    libz \
    libdiagnose_usb \
    libbase \
    libcutils \
    libutils \

# libf2fs_dlutils_host will dlopen("libf2fs_fmt_host_dyn")
LOCAL_CFLAGS += -DUSE_F2FS
LOCAL_LDFLAGS_linux := -ldl -rdynamic -Wl,-rpath,.
LOCAL_REQUIRED_MODULES_linux := libf2fs_fmt_host_dyn
# The following libf2fs_* are from system/extras/f2fs_utils,
# and do not use code in external/f2fs-tools.
LOCAL_STATIC_LIBRARIES += libf2fs_utils_host libf2fs_ioutils_host libf2fs_dlutils_host

LOCAL_CXX_STL := libc++
LOCAL_MODULE := fastboot
LOCAL_MODULE_STEM_32 := fastboot
LOCAL_MODULE_STEM_64 := fastboot64
LOCAL_MODULE_PATH_32 := $(ANDROID_PRODUCT_OUT)/system/bin
LOCAL_MODULE_PATH_64 := $(ANDROID_PRODUCT_OUT)/system/bin
LOCAL_MULTILIB := both
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := libdiagnose_usb
LOCAL_CFLAGS := $(LIBADB_CFLAGS)
LOCAL_SRC_FILES := diagnose_usb.cpp
# Even though we're building a static library (and thus there's no link step for 
# this to take effect), this adds the includes to our path.

LOCAL_C_INCLUDES := \
  $(LOCAL_PATH)/../adb \
  $(LOCAL_PATH)/../mkbootimg \
  $(LOCAL_PATH)/../../extras/f2fs_utils \
  $(LOCAL_PATH)/include \
  system/core/include

LOCAL_STATIC_LIBRARIES += libbase
include $(BUILD_STATIC_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/system)
$(call import-module, core/base)
$(call import-module, core/liblog)
$(call import-module, core/libsparse)
