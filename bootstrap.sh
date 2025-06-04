#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Starting bootstrap setup..."

# Define essential packages (universal names)
ESSENTIAL_PACKAGES=(
  git
  curl
  wget
  zsh
  starship
  neovim
  fzf
  ripgrep
  bat
  fd-find
)

install_with_pacman() {
  echo "📦 Using pacman..."
  sudo pacman -Syu --noconfirm

  for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      echo "Installing $pkg..."
      sudo pacman -S --noconfirm "$pkg"
    else
      echo "$pkg is already installed."
    fi
  done
}

install_with_yay() {
  echo "📦 Using yay (AUR)..."
  for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    if ! yay -Q "$pkg" &>/dev/null; then
      echo "Installing $pkg via yay..."
      yay -S --noconfirm "$pkg"
    else
      echo "$pkg is already installed (yay)."
    fi
  done
}

install_with_apt() {
  echo "📦 Using apt..."
  sudo apt update && sudo apt upgrade -y

  # Map fd-find and bat to correct Ubuntu package names
  local APT_PACKAGES=()
  for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    case $pkg in
      bat)
        APT_PACKAGES+=("batcat")  # Ubuntu calls it batcat
        ;;
      fd-find)
        APT_PACKAGES+=("fd-find")
        ;;
      *)
        APT_PACKAGES+=("$pkg")
        ;;
    esac
  done

  sudo apt install -y "${APT_PACKAGES[@]}"
}

setup_starship() {
  if ! command -v starship &>/dev/null; then
    echo "🌟 Installing Starship..."
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
  fi

  mkdir -p ~/.config
  if ! grep -q "starship init" ~/.bashrc 2>/dev/null; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
  fi
}

setup_zsh() {
  if [ "$SHELL" != "/bin/zsh" ] && command -v zsh &>/dev/null; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
  fi

  if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    echo "🎉 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

detect_package_manager_and_install() {
  if command -v pacman &>/dev/null; then
    install_with_pacman
    if command -v yay &>/dev/null; then
      install_with_yay
    else
      echo "⚠️  'yay' not found. Skipping AUR packages."
    fi
  elif command -v apt &>/dev/null; then
    install_with_apt
  else
    echo "❌ Unsupported system. Only pacman/yay and apt are currently supported."
    exit 1
  fi
}

# --- Main ---

detect_package_manager_and_install
setup_starship
setup_zsh

echo "✅ Bootstrap complete!"

