default:
    @just --list --unsorted

config := absolute_path('config')
build := absolute_path('.build')
out := absolute_path('firmware')
draw := absolute_path('draw')

# build firmware for matching targets
build expr *west_args:
    #!/usr/bin/env bash
    set -euo pipefail
    targets=$(yq -r '[.board, .shield] | join(",")' build.yaml | grep -i "${expr/#all/.*}")
    
    [[ -z $targets ]] && echo "No matching targets found. Aborting..." >&2 && exit 1
    echo "$targets" | while IFS=, read -r board shield; do
        artifact="${shield:+${shield// /+}-}${board}"
        build_dir="{{ build / '$artifact' }}"
        
        echo "Building firmware for $artifact..."
        west build -s zmk/app -d "$build_dir" -b $board {{ west_args }} -- \
            -DZMK_CONFIG="{{ config }}" ${shield:+-DSHIELD="$shield"}
        
        if [[ -f "$build_dir/zephyr/zmk.uf2" ]]; then
            mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.uf2" "{{ out }}/$artifact.uf2"
        else
            mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.bin" "{{ out }}/$artifact.bin"
        fi
    done

# clear build cache and artifacts
clean:
    rm -rf {{ build }} {{ out }}

# clear all automatically generated files  
clean-all: clean
    rm -rf .west zmk

# parse & plot keymap
draw:
    #!/usr/bin/env bash
    set -euo pipefail
    keymap -c "{{ draw }}/config.yaml" parse -z "{{ config }}/ergonaut_one.keymap" >"{{ draw }}/ergonaut_one.yaml"
    keymap -c "{{ draw }}/config.yaml" draw "{{ draw }}/ergonaut_one.yaml" -n "666+3 3+666" >"{{ draw }}/ergonaut_one.svg"

# initialize west
init:
    west init -l config
    west update
    west zephyr-export

# update west
update:
    west update

# upgrade zephyr-sdk and python dependencies
upgrade-sdk:
    nix flake update --flake . 