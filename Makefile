TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = BlurBar
BlurBar_FILES = Tweak.xm CKBlurView.m
BlurBar_FRAMEWORKS = UIKit QuartzCore
BlurBar_PRIVATE_FRAMEWORKS = CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"