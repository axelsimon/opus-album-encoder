#! /bin/bash
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
#bitrate=160

# Does input directory exist? ~~Can we write to it?~~
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
if [ -d $2 ]
    then
        absolute_out="$(realpath $output_dir)"
        echo "Full output directory is $absolute_out"
    else
        echo "Sorry, output directory '$output_dir' doesn't exist."
        echo "Will attempt to create it for you now."
        mkdir $output_dir
        mkdir_status=$?
#        echo .
#        sleep 1
#        echo ..
#        sleep 1
#        echo ...
        if [[ $mkdir_status -eq 0 ]]
            then
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

echo
cd $absolute_in
echo "(we are now working from inside $absolute_in)"

# Declare the album variables
#album=$(basename "$(pwd)")
album=$(metaflac --show-tag=ALBUM *.flac | sed s/.*=//g | head -n 1)
echo
echo "Album: $album"

echo
echo "Encoding all flac files to Opus, with a bitrate of $BITRATE."

# Encode files using opus
for file in *flac
    do opusenc --bitrate $BITRATE "$file" "${file%.flac}.opus"
done

mv *.opus $absolute_out

echo All files encoded to opus. You will find them in $absolute_out

cd $original_dir
