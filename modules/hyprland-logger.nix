{ config, pkgs, ... }:

let


  # Define the script path once
  logFinalScript = pkgs.writeShellScriptBin "log-final-workspace" ''
    #!${pkgs.bash}/bin/bash
    STATE_FILE="/home/meowster/bin/startTime.out"
    if [[ -r "$STATE_FILE" ]]; then
      workspaceID=$(head -1 "$STATE_FILE")
      startTime=$(tail -1 "$STATE_FILE")
      endTime=$(date +%H:%M)

    # ${pkgs.gcalcli}/bin/gcalcli add \
    #   --calendar Default \
    #   --title "$workspaceID" \
    #   --when "$startTime" \
    #   --end "$endTime" \
    #   --description "$workspaceID" \
    #   --noprompt

        echo $workspaceID > bin/logOff.out
        echo $endTime >> bin/logOff.out
    fi
  '';

    logCurrentScript = pkgs.writeShellScriptBin "log-current-time" ''
        #!${pkgs.bash}/bin/bash

        # Output file will be name of script with .out extension
        OUTFILE="$\{0%.*}.out"

        # Hyprland IPC
        # https://wiki.hypr.land/IPC/
        logWorkspaceSwap() {
          case $1 in
            "workspace>>"*) 
                workspaceID=`head -1 "$HOME/bin/startTime.out"`
                startTime=`tail -1 "$HOME/bin/startTime.out"`

                endTime=`date +%H:%M`

                jsonObject="{\"workspaceID\" : $workspaceID,
                            \"startTime\" : \"$startTime\",
                             \"endTime\" : \"$endTime\"}"

                # gcalcli add --calendar Default --title "$workspaceID" --when "$startTime" --end "$endTime" --description "$workspaceID" --noprompt
                workspaceID=`hyprctl activeworkspace -j | jq '.id'`

                # Update startTime.out for next time
                echo $workspaceID > "$HOME/bin/startTime.out"
                echo $endTime >> "$HOME/bin/startTime.out"
                ;;
          esac
        }

        # When system boot up
        bash -c '{ hyprctl activeworkspace -j | jq ".id"; date +%H:%M; } > $HOME/bin/startTime.out' 

        # Detect when workspace is updated
        socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do logWorkspaceSwap "$line"; done
  '';
in
{
  systemd.user.enable = true;
  systemd.user.services.hyprland-workspace-logger = {

    Unit = {
      Description = "Hyprland Workspace Time Logger";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      WorkingDirectory = "%h";
      ExecStart = "${logCurrentScript}/bin/log-current-time";
      ExecStop = "${logFinalScript}/bin/log-final-workspace";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}
