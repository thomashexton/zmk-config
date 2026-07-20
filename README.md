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

# Build firmware for both keyboard halves
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
2. **Generate visualization**: `just draw` → creates `docs/ergonaut_one.svg`
3. **Build firmware**: `just build ergonaut` → creates the left and right direct-Bluetooth firmware images
   Run `just build-dongle` only when preparing the optional USB-dongle setup; it creates the dongle and left-peripheral images.
4. **Flash to keyboard**: Copy `.uf2` file to your keyboard

## Firmware

- `ergonaut_one_left-xiao_ble.uf2`: left half, the Bluetooth and USB central.
- `ergonaut_one_right-xiao_ble.uf2`: right half, the wireless split peripheral.

The Oldman port keeps the Ergonaut's six extra outer-column keys for Bluetooth
management. Hold the innermost Space and Backspace thumbs together to enter the
symbol layer. There, the six outer keys clear the active host profile or select
profiles 0 through 4.

The regular bootloader combo is `Q + Quote`.

### Optional USB dongle

`just build-dongle` builds a USB-connected XIAO BLE central and a matching
left-half peripheral. Flash the dongle image to the USB XIAO, then flash the
left-peripheral and normal right-half images to the keyboard. Switching between
direct Bluetooth and dongle mode requires resetting and re-pairing split bonds.

### Restore direct Bluetooth

1. Flash `ergonaut_one_left-xiao_ble.uf2` to the left half. A normal firmware flash preserves the existing split and host bonds.
2. On the computer, forget any existing **Ergonaut One** Bluetooth device.
3. Hold the two innermost thumbs (Space and Backspace) to activate Symbol, then tap the top-left outside key to clear the selected host profile.
4. Pair **Ergonaut One** from the computer's Bluetooth settings.

If the two halves no longer connect, rebuild a ZMK `settings_reset` image when
needed, flash it to both halves, then reflash the normal left and right images.
That recovery image is intentionally not part of the everyday firmware output.

## Key Files

- `config/ergonaut_one.keymap` - Your keymap configuration
- `boards/shields/ergonaut_one/` - Local Ergonaut shield and dongle hardware definition
- `docs/ergonaut_one.svg` - Generated keymap visualization
- `flake.nix` - Nix development environment
- `Justfile` - Available commands

## Requirements

- [Nix](https://nixos.org/download) with flakes enabled
- That's it! Everything else is handled by Nix.

## Keymap Visualization

The `just draw` command uses [keymap-drawer](https://github.com/caksoylar/keymap-drawer) to generate the checked-in diagram. Its configuration, physical-layout input, and generated SVG all live under `docs/`.

The `config/zephyr/module.yml` file makes this repository's `boards/` directory
a local Zephyr module board root, so the shield stays self-contained without an
external Ergonaut module or ZMK's legacy `config/boards/` compatibility path.
