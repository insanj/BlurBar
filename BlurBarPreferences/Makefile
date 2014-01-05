TARGET=:clang
ARCHS = armv7 arm64

BUNDLE_NAME = BlurBarPreferences
BlurBarPreferences_FILES = Preferences.xm
BlurBarPreferences_INSTALL_PATH = /Library/PreferenceBundles
BlurBarPreferences_FRAMEWORKS = UIKit Twitter
BlurBarPreferences_PRIVATE_FRAMEWORKS = Preferences

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BlurBarPreferences.plist$(ECHO_END)