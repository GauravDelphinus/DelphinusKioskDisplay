#!/usr/bin/perl

use strict;
use List::Util 'shuffle';
use Image::Size;
 
#READ A DIRECTORY FOR PICTURES AND RETURN NAMES OF 'N' RANDOMLY SELECTED PICTURES
#This script expects three arguments, the directory path, the number of pictures required, and the orientation of pictures (0 = any, 1 = portrait, 2 = landscape)

#check for the argument
my $numArgs = $#ARGV + 1;
if ($numArgs != 3) {
	#bail, since we expect some output.
	exit;
}

my $dirPath = $ARGV[0];
my $numPics = $ARGV[1];
my $orientation = $ARGV[2];

opendir my $dir, $dirPath or die "Cannot open directory: $!";
#my @files = readdir $dir;
#my @files = grep { /^\./ && -f "$dirPath/$_" } readdir(dir);
my @files = grep { /\.(JPG|PNG)$/i } readdir($dir);
#my @files = readdir $dir ;
closedir $dir;

#if we need a certain type of orientation, filter those output
my @filtered_list;
my $totalNumPics = scalar @files;
for (my $i = 0; $i < $totalNumPics; $i++) {
	if ($orientation == 0) {
		push(@filtered_list, $files[$i]);
	} elsif ($orientation == 1) { #portrait only
		my $width = 0;
		my $height = 0;
		($width, $height) = imgsize($dirPath . "\\" . $files[$i]);
		#print "file = " . $files[$i] . ", width = " . $width . ", height = " . $height . "\n";
		if ($height > $width) {
			push(@filtered_list, $files[$i]);
		}
	} elsif ($orientation == 2) { #landscape only
		my $width = 0;
		my $height = 0;
		($width, $height) = imgsize($dirPath . "\\" . $files[$i]);
		#print "file = " . $files[$i] . ", width = " . $width . ", height = " . $height . "\n";
		if ($height <= $width) {
			push(@filtered_list, $files[$i]);
		}
	}
}

# Shuffled list of indexes into @deck
my @shuffled_indexes = shuffle(0..$#filtered_list);

# Get just N of them.
my @pick_indexes = @shuffled_indexes[ 0 .. $numPics - 1 ];  

# Pick cards from @deck
my @picks = @filtered_list[ @pick_indexes ];

#foreach my $pick (@picks) {
for (my $i = 0; $i <= $numPics - 1; $i++) {
	print $picks[$i];
	if ($i < ($numPics - 1)) {
		print "SEPARATOR";
	}
}
