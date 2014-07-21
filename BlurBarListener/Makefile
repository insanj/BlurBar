TARGET = :clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = BlurBarListener
BlurBarListener_OBJC_FILES = BlurBarListener.xm
BlurBarListener_FRAMEWORKS = Foundation UIKit
BlurBarListener_LDFLAGS = -lactivator -L../theos/lib

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk