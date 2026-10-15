# MacBookPro14,1 left-side USB-C ports are the Alpine Ridge xHCI (8086:15d4).
# With nothing plugged in it runtime-suspends, and its root hubs have remote
# wakeup disabled, so a stick can take VBUS (its LED lights) while the
# controller never sees the connect. Keep that controller and those hubs out of
# runtime suspend. The sleep hook repeats the write after resume, because the
# controller's power cycle does not always keep the policy.

if omarchy-hw-match "MacBookPro14,1"; then
  echo "Keeping the Alpine Ridge USB-C controller awake for hotplug"

  sudo install -Dm644 "$OMARCHY_PATH/default/udev/macbook-alpine-ridge-usb.rules" \
    /etc/udev/rules.d/71-omarchy-macbook-alpine-ridge-usb.rules
  sudo install -Dm755 "$OMARCHY_PATH/default/systemd/system-sleep/macbook-alpine-ridge-usb" \
    /usr/lib/systemd/system-sleep/macbook-alpine-ridge-usb
  sudo udevadm control --reload-rules
  sudo /usr/lib/systemd/system-sleep/macbook-alpine-ridge-usb post
fi
