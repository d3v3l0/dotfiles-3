#!/bin/zsh

# Setup startup/shutdown files
# Order:
# - ~/.zshenv
# - login shell: /etc/zprofile, ~/.zprofile
# - interactive shell: /etc/zshrc, ~/.zshrc
# - login shell: /etc/zlogin, ~/.zlogin
# On exit via exit, logout, or end-of-file: ~/.zlogout, /etc/zlogout
setup_file_symlink "zsh/profile" ".zshenv"
setup_file_symlink "zsh/zshrc"   ".zshrc"
setup_file_symlink "zsh/login"   ".zlogin"
setup_file_symlink "zsh/logout"  ".zlogout"

# Setup ~/.config/zsh/private
setup_decrypt "zsh/private.gpg" ".config/zsh/private"
