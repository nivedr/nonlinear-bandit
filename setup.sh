#!/bin/bash
# setup.sh
# Usage: ./setup.sh [env_name]

set -e  # exit immediately if a command fails

YML_FILE="environment.yml"
DEFAULT_ENV_NAME=$(grep -E '^name:' "$YML_FILE" | awk '{print $2}')
ENV_NAME=${1:-$DEFAULT_ENV_NAME}

echo "Using environment name: $ENV_NAME"

# Get conda base directory (usually ~/miniconda3 or ~/anaconda3)
CONDA_BASE=$(conda info --base)
ENV_PREFIX="$CONDA_BASE/envs/$ENV_NAME"

# Update prefix line in environment.yml
if grep -q '^prefix:' "$YML_FILE"; then
    # replace existing prefix line
    sed -i.bak "s|^prefix:.*|prefix: $ENV_PREFIX|" "$YML_FILE"
else
    # append prefix if missing
    echo "prefix: $ENV_PREFIX" >> "$YML_FILE"
fi

echo "Updated prefix in $YML_FILE → $ENV_PREFIX"

# Check if environment already exists
if conda env list | grep -qE "^$ENV_NAME\s"; then
    echo "Conda environment '$ENV_NAME' already exists. Updating..."
    conda env update -n "$ENV_NAME" -f "$YML_FILE" --prune
else
    echo "Creating conda environment '$ENV_NAME'..."
    conda env create -n "$ENV_NAME" -f "$YML_FILE"
fi

echo "Environment '$ENV_NAME' is ready."

echo "----------------------------------------------------"
echo "To activate the environment, run:"
echo "conda activate $ENV_NAME"
echo "----------------------------------------------------"
