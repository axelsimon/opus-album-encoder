#! /bin/bash
#
#    Simple script that encodes a directory of FLAC files (an album) to
#    to another directory using the Opus codec.
#
#    Copyright (C) 2020  axel simon
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Refuse to run without arguments

if [ -z "$1" ] ; then
#if [ $# -eq 0 ] ; then
    echo "Error, please run again providing all necessary arguments."
    echo Usage: "$0" input_directory output_directory.
    exit 1
fi

#if [ $# -eq 0 ] ; then
if [ -z "$2" ] ; then
    echo "Error, please run again providing all necessary arguments (missing output directory)."
    echo Usage: "$0" input_directory output_directory.
    exit 1
fi

# Declare some variables as well as usage text
input_dir=$1
output_dir=$2
usage_summary="Usage: "$0" input_directory output_directory"

# Does input directory exist?
if [ -d $1 ]
    then
        absolute_in="$(realpath $input_dir)"
        echo "Full input directory is $absolute_in"
#        if [ -w $1 ]
#            then
#                echo "We can write to this directory. Good."
#            else
#                echo "We can't write to this directory. Aborting."
#                exit 1
    else
        echo "Sorry, input directory '$input_dir' doesn't exist."
        echo $usage_summary
        exit 1
fi
echo

# Does output directory exist? Can we create it?
# Future versions should run without an output dir and automatically try
# to create one based on the artist and album name
if [ -d $2 ]
    then
        absolute_out="$(realpath $output_dir)"
        echo "Full output directory is $absolute_out"
    else
        echo "Sorry, output directory '$output_dir' doesn't exist."
        echo "Will attempt to create it for you now."
        mkdir $output_dir
        mkdir_status=$?
        if [[ $mkdir_status -eq 0 ]]
            then
                absolute_out="$(realpath $output_dir)"
                echo "Great, we were able to create '$output_dir'. Continuing now"
            else
                echo "Sorry, couldn't create output directory '$output_dir'. Aborting." 
                exit 1
        fi
fi

echo
read -e -p "Enter target Opus bitrate (or press enter to accept the default): " -i "192" BITRATE
if [ ! $BITRATE = 192 ]
    then
        echo Chosen bitrate: $BITRATE
fi

# Store original directory, so we can return to it later
original_dir="$(pwd)"

# Enter input directory
cd $absolute_in

# Get the artist album name from the flac filess and store it.
# This is ugly, as we read from all files but eventually only keep the first result.
# This also currently does nothing useful except show the user fancy info on screen
# but might be used as a better output dir in the future
artist=$(metaflac --show-tag=ARTIST *.flac | sed s/.*=//g | head -n 1)
album=$(metaflac --show-tag=ALBUM *.flac | sed s/.*=//g | head -n 1)
echo
echo "Artist: $artist"
echo "Album: $album"

# Confirming information to the user
echo
echo "Encoding all flac files to Opus, with a bitrate of $BITRATE."
echo

# Encode files using Opus
for file in *flac
    do opusenc --bitrate $BITRATE "$file" "${file%.flac}.opus"
done

# Move the encoded files to our output directory
mv *.opus $absolute_out

# Finish up and go back to the original directory
echo All files encoded to opus. You will find them in $absolute_out
cd $original_dir
