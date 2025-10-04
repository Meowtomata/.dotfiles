{ config, pkgs, ... }:

let
  aliasesScript = pkgs.writeText "workspace-aliases.sh" ''
    #!${pkgs.bash}/bin/bash
    declare -A WORKSPACE_NAMES
    WORKSPACE_NAMES[1]="Unstructured"
    WORKSPACE_NAMES[2]="Coding"
    WORKSPACE_NAMES[3]="HW"
    WORKSPACE_NAMES[4]="TA"
    WORKSPACE_NAMES[5]="Music Production"
    WORKSPACE_NAMES[6]="Video Production"
    WORKSPACE_NAMES[7]="Leisure"
    WORKSPACE_NAMES[8]="Configuration"

    get_workspace_name() {
      local id="$1"
      echo "''${WORKSPACE_NAMES[$id]:-"Workspace $id"}"
    }
  '';

  # Define the script path once
  logFinalScript = pkgs.writeShellScriptBin "log-final-workspace" ''
    #!${pkgs.bash}/bin/bash
    source ${aliasesScript}

    STATE_FILE="/home/meowster/bin/startTime.out"
    if [[ -r "$STATE_FILE" ]]; then
      workspaceID=$(head -1 "$STATE_FILE")
      startTime=$(tail -1 "$STATE_FILE")
      endTime=$(date +%H:%M)

      workspaceName=$(get_workspace_name "$workspaceID")

      ${pkgs.gcalcli}/bin/gcalcli add \
        --calendar Default \
        --title "$workspaceName" \
        --when "$startTime" \
        --end "$endTime" \
        --description "$workspaceID" \
        --noprompt

        echo $workspaceID > bin/logOff.out
        echo $endTime >> bin/logOff.out
    fi
  '';

    logCurrentScript = pkgs.writeShellScriptBin "log-current-time" ''
        #!${pkgs.bash}/bin/bash
        source ${aliasesScript}

        # Output file will be name of script with .out extension
        OUTFILE="$\{0%.*}.out"

        # Hyprland IPC
        # https://wiki.hypr.land/IPC/
        logWorkspaceSwap() {
          case $1 in
            "workspace>>"*) 
                prevWorkspaceID=`head -1 "$HOME/bin/startTime.out"`
                startTime=`tail -1 "$HOME/bin/startTime.out"`
                endTime=`date +%H:%M`

                prevWorkspaceName=$(get_workspace_name "$prevWorkspaceID")

                jsonObject="{\"workspaceID\" : $workspaceID,
                            \"startTime\" : \"$startTime\",
                             \"endTime\" : \"$endTime\"}"

                gcalcli add --calendar Default --title "$prevWorkspaceName" --when "$startTime" --end "$endTime" --description "$workspaceID" --noprompt
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
