#!/usr/bin/perl

use strict;
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use Image::PNG::QRCode 'qrpng';
use String::Random;
use Cwd;

my $url = "https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss"; #NASA photo of the day rss feed

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download the feed xml to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($url, $localfile);

#parse the file and get rid of the temp file
my $p = XML::RSS::Parser->new;
my $fh = FileHandle->new($localfile);
my $feed = $p->parse_file($fh);
$fh->close;
unlink $localfile;

#parse the feed for the first link (the latest photo of the day)
my @feeds = $feed->query('//item');
my $url =$feeds[0]->query('link')->text_content;
my $title = $feeds[0]->query('title')->text_content;
$title =~ s/^\s+|\s+$//g; #trim whitespaces from both ends

#download the html to a temp file
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
my @lines2 = grep (/content=/, @lines);
@lines2 = grep (/files\/thumbnails\/image\//, @lines2);
@lines2 = grep (/og:image/, @lines2);
my $img = $lines2[0];
$img =~ s#.*content="([^"]*)".*#$1#;
$img =~ s/^\s+|\s+$//g; #trim whitespaces from both ends

#generate QRCode for the link and save to a temp file
my $outfilename = $randStr->randpattern("cccccccc") . ".png";
my $outfile = $tempdir . "\\" . $outfilename;
qrpng(text => $url, out => $outfile);

#finally, print the output in this format: <image url>SEPARATOR<image caption>SEPARATOR<name of temp qrcode file>
print $img . "SEPARATOR" . $title . "SEPARATOR" . $outfilename;
