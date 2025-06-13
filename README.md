# ZMK Config

A ZMK firmware configuration for the Ergonaut One keyboard, using Nix Flakes for development.

## Quick Start

```bash
# Enter development environment (downloads all tools automatically)
nix develop

# See available commands
just --list

# Generate keymap visualization
just draw

# Build firmware for your keyboard (builds left, right, dongle)
just build ergonaut

# Initialize ZMK workspace (first time only)
just init
```

## Development Workflow

1. **Edit your keymap**: Modify `config/ergonaut_one.keymap`
2. **Generate visualization**: `just draw` → creates `draw/ergonaut_one.svg`
3. **Build firmware**: `just build ergonaut` → creates `firmware/ergonaut_one_left-seeeduino_xiao_ble.uf2` (and right, dongle)
4. **Flash to keyboard**: Copy `.uf2` file to your keyboard

## Key Files

- `config/ergonaut_one.keymap` - Your keymap configuration
- `draw/ergonaut_one.svg` - Generated keymap visualization
- `flake.nix` - Nix development environment
- `Justfile` - Available commands

## Requirements

- [Nix](https://nixos.org/download) with flakes enabled
- That's it! Everything else is handled by Nix.

## Keymap Visualization

The `just draw` command uses [keymap-drawer](https://github.com/caksoylar/keymap-drawer) to generate SVG visualizations of your keymap. The output shows all layers, combos, and key bindings in a visual format. 