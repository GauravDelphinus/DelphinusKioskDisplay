#!/usr/bin/perl

use strict;
use LWP::Simple;
use FileHandle;
use String::Random;

#GENERAL COMIC STRIP SCRIPT FOR GOCOMICS.COM
#This script expects one argument which is the name of the comic
#The script assumes the comic exists on www.gocomics.com and uses the name to create the comic strip URL

#check for the argument
my $numArgs = $#ARGV + 1;
if ($numArgs != 1) {
	#bail, since we expect some output.
	return;
}

#construct URL
my $comicName = $ARGV[0];
my $url = "http://www.gocomics.com/" . $comicName;

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download html to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";

#download the file
getstore($url, $localfile);
local $/=undef;
open FILE, $localfile or die "Couldn't open file: $!";
my $contents = <FILE>;
close FILE;
unlink $localfile;

#extract the specific image link
my @lines = split /^/m, $contents;
my @lines2 = grep (/src=/, @lines);
@lines2 = grep (/assets\.amuniversal/, @lines2);
my $img = $lines2[0];
$img =~ s#.*src="([^"]*)".*#$1#;
$img =~ s/^\s+|\s+$//g; #trim whitespaces from both ends

#finally, print the full path to the image
print $img;
