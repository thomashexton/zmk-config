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

# Build firmware for your keyboard (builds direct and dongle variants)
just build ergonaut

# Initialize ZMK workspace (first time only)
just init
```

## First Time Setup (Fresh Mac)

1. **Install Nix**: 
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Restart your terminal**, then continue with Quick Start above.

## Development Workflow

1. **Edit your keymap**: Modify `config/ergonaut_one.keymap`
2. **Generate visualization**: `just draw` → creates `draw/ergonaut_one.svg`
3. **Build firmware**: `just build ergonaut` → creates direct-Bluetooth left/right firmware plus separate dongle firmware
4. **Flash to keyboard**: Copy `.uf2` file to your keyboard

## Firmware variants

- `ergonaut_one_left-xiao_ble.uf2`: left half as the central; use this without a dongle.
- `ergonaut_one_right-xiao_ble.uf2`: right peripheral, used in either setup.
- `ergonaut_one_left_dongle.uf2`: left half as a peripheral; use this with a dongle.
- `ergonaut_one_dongle-xiao_ble.uf2`: dongle as the central.

After changing between direct and dongle setups, flash `settings_reset-xiao_ble.uf2` to every part before flashing its normal firmware.

On the Adjust layer, the top outside keys clear the active Bluetooth host bond. The remaining top-row Bluetooth keys select host profiles 0–3; profile 4 is immediately below each bootloader key.

### Restore direct Bluetooth

1. Flash `ergonaut_one_left-xiao_ble.uf2` to the left half. A normal firmware flash preserves the existing split and host bonds.
2. On the computer, forget any existing **Ergonaut One** Bluetooth device.
3. Hold the left `Esc` and `Space` thumb keys together to activate Adjust, then tap the top-left outside key to clear the selected host profile.
4. Pair **Ergonaut One** from the computer's Bluetooth settings.

If the two halves no longer connect, flash `settings_reset-xiao_ble.uf2` to both halves, then flash `ergonaut_one_right-xiao_ble.uf2` to the right and `ergonaut_one_left-xiao_ble.uf2` to the left. Power both halves on together so their internal split bond is recreated.

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
