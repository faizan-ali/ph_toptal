#
# PHN-DataMonitor package
#
# Author: sean.critica@toptal.com
#

include $(TOPDIR)/rules.mk

PKG_NAME:=phn-datamonitor
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

SOURCE_DIR:=$(TOPDIR)/../ph_toptal/client

include $(INCLUDE_DIR)/package.mk

define Package/phn-datamonitor
    SECTION:=net
    CATEGORY:=Network
    SUBMENU:=PH Networks
    DEPENDS:= \
        +ip-full \
        +conntrack \
        +curl \
        +coreutils-sleep \
        +coreutils-nohup \

    TITLE:=Network data collection agent for PH Networks security system
    MAINTAINER:=Sean Critica <sean.critica@toptal.com>
endef

define Package/phn-datamonitor/description
    Agents to automatically collect network data and upload them to
    PH Networks security service for processing.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp $(SOURCE_DIR)/config.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/common_utils.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/conntrack_monitor.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/mac_address_monitor.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/monitor_communicator.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/start_stop_monitoring.sh $(PKG_BUILD_DIR)/.
	cp $(SOURCE_DIR)/phn-datamonitor $(PKG_BUILD_DIR)/.
	chmod 755 $(PKG_BUILD_DIR)/*.sh
	chmod 755 $(PKG_BUILD_DIR)/phn-datamonitor
	$(Build/Patch)
endef

define Build/Compile
	true
endef

define Package/phn-datamonitor/install
	$(INSTALL_DIR) $(1)/usr/local/phn/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/config.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/common_utils.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/conntrack_monitor.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mac_address_monitor.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/monitor_communicator.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/start_stop_monitoring.sh $(1)/usr/local/phn/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/phn-datamonitor $(1)/etc/init.d/
endef

define Package/phn-datamonitor/postinst
NEW_UUID=$$(cat /proc/sys/kernel/random/uuid)
sed -i -e 's/^UUID=.*$$/UUID='$${NEW_UUID}'/' $${IPKG_INSTROOT}/usr/local/phn/bin/config.sh
sed -i -e 's/SCRIPT_BASE_DIR=.*$$/SCRIPT_BASE_DIR=\/usr\/local\/phn\/bin/' $${IPKG_INSTROOT}/etc/init.d/phn-datamonitor
endef

$(eval $(call BuildPackage,phn-datamonitor))
