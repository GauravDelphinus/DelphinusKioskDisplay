#!/usr/bin/perl

use strict;
use LWP::Simple;
use FileHandle;
use String::Random;

#Download the page and grep for latest comic.  No RSS.

#construct URL
my $url = "http://www.kopozky.net";

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

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
@lines2 = grep (/\/*.png/, @lines2);
@lines2 = grep (/kopozky.net\/images/, @lines2);
my $img = $lines2[0];
$img =~ s#.*src="([^"]*)".*#$1#;
$img =~ s/^\s+|\s+$//g; #trim whitespaces from both ends

#finally, print the full path to the image
print $img;
