THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = BlurBar
BlurBar_FILES = BlurBar.xm CKBlurView.m
BlurBar_FRAMEWORKS = UIKit QuartzCore
BlurBar_PRIVATE_FRAMEWORKS = CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += BlurBarPreferences
SUBPROJECTS += BlurBarListener
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_Store" -delete
internal-after-install::
	install.exec "killall -9 backboardd"