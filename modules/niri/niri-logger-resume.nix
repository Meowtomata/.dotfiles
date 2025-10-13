{ config, pkgs, ... }:

let
  username = "meowster";

  niriSuspendCtl = pkgs.writeShellScriptBin "niri-suspend-ctl" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    TARGET_USER="$1"
    COMMAND="$2" # This will be "start" or "stop"

    # Find the user's UID to locate their runtime directory.
    uid=$(id -u "$TARGET_USER")
    if [ -z "$uid" ]; then
      echo "Error: Could not find UID for user '$TARGET_USER'." >&2
      exit 1
    fi

    export XDG_RUNTIME_DIR="/run/user/$uid"
    DBUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

    # Check if the user's session bus is actually running.
    if [ ! -S "$XDG_RUNTIME_DIR/bus" ]; then
        echo "User D-Bus socket not found. User session may not be active."
        exit 0
    fi

    # Use the full, explicit path to the sudo binary.
    # This makes the script independent of the service's PATH environment.
    ${pkgs.sudo}/bin/sudo -u "$TARGET_USER" \
      DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDRESS" \
      ${pkgs.systemd}/bin/systemctl --user "$COMMAND" niri-workspace-logger.service
  '';

in
{
  security.sudo.enable = true;

  users.users.${username}.linger = true;

  systemd.services.niri-logger-suspend = {
    description = "Stop Niri workspace logger before suspend";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${niriSuspendCtl}/bin/niri-suspend-ctl ${username} stop";
    };
    wantedBy = [ "suspend.target" ];
    before = [ "suspend.target" ];
  };

  systemd.services.niri-logger-resume = {
    description = "Restart Niri workspace logger after resume";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${niriSuspendCtl}/bin/niri-suspend-ctl ${username} start";
    };
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
  };
}
