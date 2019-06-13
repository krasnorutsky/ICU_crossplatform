LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libicu
LOCAL_SRC_FILES := ./../jniLibs/$(TARGET_ARCH_ABI)/libicu.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libicudata
LOCAL_SRC_FILES := ./../jniLibs/$(TARGET_ARCH_ABI)/libicudata.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := libicu libicudata
LOCAL_MODULE := native-lib
LOCAL_SRC_FILES := native-lib.cpp StringCompare_icu.cpp
include $(BUILD_SHARED_LIBRARY)
