THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = BlurBar
BlurBar_FILES = BlurBar.xm
BlurBar_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += BlurBarListener
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_Store" -delete
internal-after-install::
	install.exec "killall -9 backboardd"
	
internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -r Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BlurBar$(ECHO_END)
