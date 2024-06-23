{ config, pkgs, ... }:
let
  inherit (pkgs)
    gofumpt
    stylua
    ruff
    prettierd
    nixpkgs-fmt
    terraform;

in
{

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  environment.systemPackages = [
    pkgs.nerdfonts
    pkgs.lazygit
    pkgs.git
    pkgs.discord
    pkgs.gimp
    pkgs.flameshot
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.zsh.enable = true;
  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    colorschemes.oxocarbon.enable = true;
    globals.mapleader = " ";
    opts = {
      number = true;
      relativenumber = true;

      # indentation
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      # swap, backup, undo
      swapfile = false;
      backup = false;
      undofile = false;

      # search
      incsearch = true;
      hlsearch = true;

      # code folding
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # misc
      wrap = false;
      termguicolors = true;
      scrolloff = 8;
      colorcolumn = "80";
      cursorline = true;
      completeopt = "menu,menuone,noselect";
      background = "dark";
    };

    keymaps = [
      {
        action = "<cmd>Telescope find_files<cr>";
        key = "<leader>ff";
        options = {
          silent = true;
        };
      }
    ];

    extraPackages = [
      gofumpt
      stylua
      ruff
      prettierd
      nixpkgs-fmt
      terraform
    ];

    extraConfigLua = ''
      vim.api.nvim_create_user_command("Format", function(args)
        require("conform").format({ async = true, lsp_fallback = true})
      end, {})
    '';

    plugins.conform-nvim = {
      enable = true;
      formattersByFt = {
        go = [ "gofumpt" ];
        lua = [ "stylua" ];
        python = [ "ruff_format" "ruff_fix" "isort" "black" ];
        javascript = [ "prettierd" ];
        typescript = [ "prettierd" ];
        nix = [ "nixpkgs_fmt" ];
        tf = [ "terraform_fmt" ];
        "_" = [ "trim_whitespace" ];
      };
    };

    plugins.dashboard = {
      enable = true;
      settings = {
        theme = "doom";
        config = {
          header = [
        
            ""
            "██████╗ ██╗    ██╗███████╗██████╗ ███╗   ███╗"
            "██╔══██╗██║    ██║██╔════╝██╔══██╗████╗ ████║"
            "██████╔╝██║ █╗ ██║███████╗██║  ██║██╔████╔██║"
            "██╔══██╗██║███╗██║╚════██║██║  ██║██║╚██╔╝██║"
            "██████╔╝╚███╔███╔╝███████║██████╔╝██║ ╚═╝ ██║"
            "╚═════╝  ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝     ╚═╝"
            ""                                     
          ];
          center = [
            {
              action = "Telescope find_files";
              desc = " Find File";
              desc_hl = "String";
              icon = " ";
              icon_hl = "Title";
              key = "f";
              key_format = " %s";
              key_hl = "Number";
            }
            {
              action = "qa";
              desc = " Quit";
              desc_hl = "String";
              icon = " ";
              icon_hl = "Title";
              key = "q";
              key_format = " %s";
              key_hl = "Number";
            }
          ];
        };
      };
    };

    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };

    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        undo.enable = true;
      };
      settings = {
        pickers = {
          colorscheme.enable_preview = true;
        };
        defaults.mappings = {
          n = {
            q = {
              __raw = "require('telescope.actions').close";
            };
          };
        };
      };
    };

    plugins.indent-blankline = {
      enable = true;
      settings = {
        exclude = {
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableRefreshOnWrite = true;

      defaultComponentConfigs = {
        indent = {
          withExpanders = true;
          expanderCollapsed = "";
          expanderExpanded = "";
          expanderHighlight = "NeoTreeExpander";
        };
      };

      window = {
        position = "float";
      };

      filesystem = {
        filteredItems = {
          hideDotfiles = false;
          alwaysShow = [ ".gitignore" "flake.nix" ];
          hideByPattern = [ "*/.git" ];
        };
      };
    };

    plugins.lualine = {
      enable = true;
      globalstatus = true;
    };
    
    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          silent = true;

          diagnostic = {
            "<leader>do" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };

          lspBuf = {
            "gd" = "definition";
            "gt" = "type_definition";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
          };
        };

        servers = {
          astro.enable = true;
          bashls.enable = true;
          cssls.enable = true;
          dockerls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          terraformls.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
          zls.enable = true;
        };
      };

      fidget.enable = true;
    };

    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_document_symbol"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "luasnip"; }
            { name = "path"; }
          ];

          window = {
            documentation.maxHeight = "math.floor(40 * (40 / vim.o.lines))";
            completion = {
              colOffset = -3;
              sidePadding = 0;
            };
          };

          mapping = {
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";

            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";

            "<C-Space>" = "cmp.mapping.complete({})";
            "<C-e>" = "cmp.mapping.close()";

            "<C-y>" = "cmp.mapping.confirm()";

          };

          formatting = {
            fields = [ "kind" "abbr" "menu" ];
            format = ''
              function(_, vim_item)
                local icons = {
                  Text = "  ",
                  Method = "  ",
                  Function = "  ",
                  Constructor = "  ",
                  Field = "  ",
                  Variable = "  ",
                  Class = "  ",
                  Interface = "  ",
                  Module = "  ",
                  Property = "  ",
                  Unit = "  ",
                  Value = "  ",
                  Enum = "  ",
                  Keyword = "  ",
                  Snippet = "  ",
                  Color = "  ",
                  File = "  ",
                  Reference = "  ",
                  Folder = "  ",
                  EnumMember = "  ",
                  Constant = "  ",
                  Struct = "  ",
                  Event = "  ",
                  Operator = "  ",
                  TypeParameter = "  ",
                }

                vim_item.menu = vim_item.kind
                vim_item.kind = icons[vim_item.kind]
                return vim_item
              end
            '';
          };
        };
      };
    };

    plugins.luasnip = {
      enable = true;
    };


  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  services.xserver.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "";

  services.xserver = {
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3blocks
        i3lock
        i3status
      ];
    };
  };
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin.user = "bwsdm";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  time.timeZone = "America/Chicago";

  ## Sound settings ##
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "24.05";
}
