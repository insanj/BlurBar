THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

TWEAK_NAME = BlurBar
BlurBar_FILES = Tweak.xm CKBlurView.m
BlurBar_FRAMEWORKS = UIKit QuartzCore
BlurBar_PRIVATE_FRAMEWORKS = CoreGraphics
SUBPROJECTS += BlurBarPreferences

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-after-install::
	install.exec "killall -9 backboardd"