#!/bin/bash

# Set the directory where you want to download and extract the files
download_dir="third_party/gdsion"

# Create the directory if it doesn't exist
mkdir -p "$download_dir"

# Array of URLs to the zip files you want to download
zip_urls=(
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-android.zip"
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-linux.zip"
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-macos.zip"
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-macos.zip"
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-web.zip"
  "https://github.com/YuriSizov/gdsion/releases/download/0.7-beta6/libgdsion-windows.zip"
)

# Loop through the URLs and download/extract each zip file
for url in "${zip_urls[@]}"; do
    # Extract the filename from the URL
    filename=$(basename "$url")

    # Download the zip file
    echo "Downloading $filename..."
    wget -q -O "$download_dir/$filename" "$url"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Extracting $filename..."
        unzip -n -q "$download_dir/$filename" -d "$download_dir"

        # Check if the extraction was successful
        if [ $? -eq 0 ]; then
            echo "Deleting $filename..."
            rm "$download_dir/$filename"
        else
            echo "Error extracting $filename. Zip file not deleted."
        fi
    else
        echo "Error downloading $filename."
    fi
done

cp ./third_party/libgdsion.gdextension.custom ./third_party/gdsion/bin/libgdsion.gdextension
