# FLAC to Opus simple album encoder

This is a simple script that takes a input directory with FLAC encoded files and converts them to Opus, in a different directory.

Usage is:
./album_FLAC_Opus_encoder.sh input_directory output_directory

# Installation
Download the script and make it executable.
For instance:
```
curl -LO https://github.com/axelsimon/opus-album-encoder/raw/master/album_FLAC_Opus_encoder.sh ~/.local/bin
chmod +x ~/.local/bin/album_FLAC_Opus_encoder.sh
```
# Dependencies
The script currently depends on `opusenc` to encode to Opus (seems reasonable enough) and `metaflac` to display the artist and album title, even though that does nothing but make the output look a bit fancy (currently)
In the future, i'd like to make dependency to `flac` optional.

Note: `metaflac` is normally installed with `flac`.

# Caveats
This script was written as a learning exercise. As such, it isn't great :)
Any suggestions for improvement or bug reports welcome.
