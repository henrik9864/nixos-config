{
  theme = "robbyrussell";

  plugins = [
    "git"
    "sudo"
    "docker"
    "z"
  ];

  promptInit = ''
    autoload -Uz add-zsh-hook
    _nix_shell_prompt() {
      if [[ -n "$IN_NIX_SHELL" ]]; then
        _nix_shell_indicator="%F{cyan}❄%f "
      else
        _nix_shell_indicator=""
      fi
    }
    add-zsh-hook precmd _nix_shell_prompt
    setopt prompt_subst
    PROMPT="\''${_nix_shell_indicator}$PROMPT"
  '';

  aliases = {
    nrs = "sudo nixos-rebuild switch";
    nrsf = "sudo nixos-rebuild switch --fast";
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    ndc = "nix develop -c $SHELL";
    ndi = "[ -f .envrc ] || echo 'use flake' > .envrc; direnv allow";
    v = "nvim";
    b = "yazi";

    gs = "git status -s";
    ga = "git add";
    gr = "git reset";
    gll = "git log --oneline --graph --decorate --all";
    gundo = "git reset HEAD~1 --mixed";
    gnah = "git reset --hard && git clean -fd";
    gri = "git rebase -i HEAD~";
    gwip = "git add -A && git commit -m 'WIP'";
    gcfix = "git commit --fixup";
  };
}
