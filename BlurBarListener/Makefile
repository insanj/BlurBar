TARGET = :clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = BlurBarListener
BlurBarListener_FILES = BlurBarListener.xm
BlurBarListener_FRAMEWORKS = Foundation UIKit
BlurBarListener_LIBRARIES = flipswitch
BlurBarListener_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk