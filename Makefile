THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
ARCHS =  arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = JBDO
JBDO_FILES = main.mm

include $(THEOS_MAKE_PATH)/tool.mk

after-stage::
	$(ECHO_NOTHING) chmod 777 $(THEOS_STAGING_DIR)/usr/bin/$(TOOL_NAME) && ldid -Sdemo.ent $(THEOS_STAGING_DIR)/usr/bin/$(TOOL_NAME) $(ECHO_END)
