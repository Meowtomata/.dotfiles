{ config, pkgs, ... }:

let
  niriWorkspaceLogger = pkgs.writeShellScriptBin "niri-workspace-logger" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    declare -A WORKSPACE_NAMES
    WORKSPACE_NAMES[1]="Unstructured"
    WORKSPACE_NAMES[2]="Coding"
    WORKSPACE_NAMES[3]="HW"
    WORKSPACE_NAMES[4]="TA"
    WORKSPACE_NAMES[5]="Music Production"
    WORKSPACE_NAMES[6]="Video Production"
    WORKSPACE_NAMES[7]="Leisure"
    WORKSPACE_NAMES[8]="Configuration"
    EVENT_QUEUE="$HOME/bin/gcal_event_queue.log"
    STATE_FILE="$HOME/bin/startTime.out"
    mkdir -p "$(dirname "$STATE_FILE")"
    get_workspace_name() {
      local id="$1"
      echo "''${WORKSPACE_NAMES[$id]:-"Workspace $id"}"
    }
    log_event() {
      local calendar="$1"
      local title="$2"
      local when="$3"
      local end="$4"
      local description="$5"
      echo "$calendar|$title|$when|$end|$description" >> "$EVENT_QUEUE"
    }
    perform_final_log() {
      if [ -s "$STATE_FILE" ]; then
        local prevWorkspaceID="$(head -1 "$STATE_FILE")"
        local startTime="$(tail -1 "$STATE_FILE")"
        local endTime="$(date +%H:%M)"
        local workspaceName=$(get_workspace_name "$prevWorkspaceID")
        log_event "Default" "$workspaceName" "$startTime" "$endTime" "Final log for workspace $prevWorkspaceID upon script exit."
        rm "$STATE_FILE"
      fi
    }
    trap 'perform_final_log; exit 0' TERM INT
    output=$(niri msg focused-window | awk '/^ *Workspace ID:/ {print $3}')
    echo "''${output:-1}" > "$STATE_FILE"
    date +%H:%M >> "$STATE_FILE"
    niri msg --json event-stream | jq --unbuffered '.WorkspaceActivated.id // empty' | while IFS= read -r workspaceID; do
        prevWorkspaceID="$(head -1 "$STATE_FILE")"
        startTime="$(tail -1 "$STATE_FILE")"
        endTime="$(date +%H:%M)"
        workspaceName=$(get_workspace_name "$prevWorkspaceID")
        if [ "$startTime" != "$endTime" ]; then
            log_event "Default" "$workspaceName" "$startTime" "$endTime" "Switched from workspace $prevWorkspaceID to $workspaceID"
        fi
        echo "$workspaceID" > "$STATE_FILE"
        echo "$endTime" >> "$STATE_FILE"
    done
  '';

  gcalSyncer = pkgs.writeShellScriptBin "gcal-syncer" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail
    EVENT_QUEUE="$HOME/bin/gcal_event_queue.log"
    BACKUP_LOG="$HOME/bin/gcal_events_history.log"
    LOCK_FILE="/tmp/gcal-sync.lock"
    if [ -e "$LOCK_FILE" ]; then
      echo "Lock file exists, another sync may be in progress. Exiting."
      exit 1
    fi
    trap 'rm -f "$LOCK_FILE"' EXIT
    touch "$LOCK_FILE"
    if [ ! -s "$EVENT_QUEUE" ]; then
      echo "Event queue is empty. Nothing to sync."
      exit 0
    fi
    echo "Starting sync from $EVENT_QUEUE..."
    while IFS='|' read -r calendar title when end description; do
      if [ -z "$title" ]; then
        continue
      fi
      echo "Syncing: Calendar='$calendar', Title='$title', Time='$when-$end'"
      gcalcli add \
        --calendar "$calendar" \
        --title "$title" \
        --when "$when" \
        --end "$end" \
        --description "$description" \
        --noprompt
    done < "$EVENT_QUEUE"
    echo "Sync complete. Backing up and clearing the queue."
    cat "$EVENT_QUEUE" >> "$BACKUP_LOG"
    > "$EVENT_QUEUE"
    echo "Queue cleared. Script finished."
  '';

in
{
  home.packages = with pkgs; [
    jq
    bash
    gcalcli
    niri
  ];

  systemd.user.services.niri-workspace-logger = {
    Unit = {
      Description = "Niri Workspace Time Logger";
      PartOf = [ "niri.service" ];
      After = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${niriWorkspaceLogger}/bin/niri-workspace-logger";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  systemd.user.services.gcal-syncer = {
    Unit = {
      Description = "Sync Niri workspace logs to Google Calendar";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${gcalSyncer}/bin/gcal-syncer";

      Environment = "PATH=${
        pkgs.lib.makeBinPath [
          pkgs.gcalcli
          pkgs.coreutils
        ]
      }";
    };
  };

  systemd.user.timers.gcal-syncer = {
    Unit = {
      Description = "Run GCal Syncer every 15 minutes";
    };
    Timer = {
      OnBootSec = "5min"; # Run 5 minutes after user login
      OnUnitActiveSec = "15min"; # And every 15 minutes after that
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
