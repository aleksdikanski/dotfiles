{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aleks";
  home.homeDirectory = /Users/aleks;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 12.0;
        normal = {
          family = "SauceCodePro Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "SauceCodePro Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "SauceCodePro Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "SauceCodePro Nerd Font";
          style = "Bold Italic";
        };
      };
      colors = {
        draw_bold_text_with_bright_colors = true;
      };
    };
    theme = "nightfox";
  };
  programs.git = {
    enable = true;
    userName = "Aleks Dikanski";
    userEmail = "a.dikanski@gmail.com";
  };

  programs.tmux = {
    baseIndex = 1;
    enable = true;
    sensibleOnTop = true;
    escapeTime = 0;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      # don't exit from tmux when closing a session
      set -g detach-on-destroy off

      # renumber all windows when any window is closed
      set -g renumber-windows on

      # enable mouse support
      # set -g mouse on

      # renumber all windows when any window is closed
      set -g renumber-windows on

      # use system clipboard
      set -g set-clipboard on

      # Status bar
      # update the status bar every 3 seconds
      set -g status-interval 3
      # macOS / darwin style
      set -g status-position top

      set -g status-left "#[fg=blue,bold,bg=#1e1e2e]  #S ▏ "
      # increase length (from 10)
      set -g status-left-length 200

      set -g status-right "#[fg=#b4befe,bold,bg=#1e1e2e]%a %Y-%m-%d  %l:%M %p"
      # increase length (from 10)
      set -g status-right-length 200

      set -g status-justify left
      set -g status-style 'bg=#1e1e2e' # transparent

      #   拓 ﳶ
      set -g window-status-current-format '#[fg=magenta,bg=#1e1e2e]#I #W  ▏'
      set -g window-status-format '#[fg=gray,bg=#1e1e2e]#I #W   ▏'
      set -g window-status-last-style 'fg=white,bg=black'

      set -gu default-command
      set -g default-shell "$SHELL"
    '';
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "docker-compose"
        "eza"
        "fzf"
        "git"
        "git-commit"
        "golang"
        "gradle"
        "history"
        "kubectl"
        "macos"
        "rust"
        "ssh"
        "ssh-agent"
        "tmux"
        "zoxide"
      ];
      theme = "robbyrussell";
    };
  };



  imports = [
    ../neovim
  ];
}
