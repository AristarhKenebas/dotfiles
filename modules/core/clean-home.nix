{ config, pkgs, ... }:

{
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    PULSE_COOKIE = "${XDG_CONFIG_HOME}/pulse/cookie";

    # Development: Node.js, Bun, Go, Python
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    BUN_INSTALL = "${XDG_DATA_HOME}/bun";
    GOPATH = "${XDG_DATA_HOME}/go";
    PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
    PYTHON_HISTORY = "${XDG_STATE_HOME}/python/history";

    # Docker
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";

    # Utils
    WGETRC = "${XDG_CONFIG_HOME}/wgetrc";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    
    # KDE/Qt software
    KDEHOME = "${XDG_CONFIG_HOME}/kde";

    # Dotnet
    DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";

    # WakaTime
    WAKATIME_HOME = "${XDG_CONFIG_HOME}/wakatime";

    # X11 / Compose Cache (hotkey combinations)
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
  };
}