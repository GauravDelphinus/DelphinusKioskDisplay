#!/usr/bin/perl

use strict;
use LWP::Simple;
use FileHandle;
use Image::PNG::QRCode 'qrpng';
use String::Random;
use Cwd;

#Download the page and grep for latest photo.  No RSS.

my $url = "http://photography.nationalgeographic.com/photography/photo-of-the-day/"; #Nat Geo photo of the day html url.  No RSS.

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download html to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($url, $localfile);

#read the contents of the html and get rid of the temp file
local $/=undef;
open FILE, $localfile or die "Couldn't open file: $!";
my $contents = <FILE>;
close FILE;
unlink $localfile;

#extract the specific image link
my @lines = split /^/m, $contents;
my @lines2 = grep (/"og:image"/, @lines);
@lines2 = grep (/nationalgeographic\.com/, @lines2);
my $img = $lines2[0];
$img =~ s#.*content="([^"]*)".*#$1#;
$img =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
$img =~ s/^\/\//http:\/\//g; #add http at the beginning if not already there

#extract image caption
@lines2 = grep (/"og:description"/, @lines);
my $caption = $lines2[0];
$caption =~ s#.*content="([^"]*)".*#$1#;
$caption =~ s/^\s+|\s+$//g;  #trim whitespaces from both ends

#generate QRCode for the link and save to a temp file
my $outfilename = $randStr->randpattern("cccccccc") . ".png";
my $outfile = $tempdir . "\\" . $outfilename;
qrpng(text => $url, out => $outfile);

#finally, print the output in this format: <image url>SEPARATOR<image caption>SEPARATOR<name of temp qrcode file>
print $img . "SEPARATOR" . $caption . "SEPARATOR" . $outfilename;
