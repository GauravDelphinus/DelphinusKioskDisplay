#!/usr/bin/perl

use strict;
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use Image::PNG::QRCode 'qrpng';
use String::Random;

my $url = "http://feeds.braingle.com/braingle/teaser";

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

#parse the feed for the puzzle title, description and link to the answer
my @feeds = $feed->query('//item');
my $url =$feeds[0]->query('link')->text_content;

my $description = $feeds[0]->query('description')->text_content;
$description =~ s#(.*)Check <a href="(.*)">Braingle.com.*#$1ANSWER:$2#s;  #note: the s at the end treats multiple lines as one line
my $sepIndex = index($description, "ANSWER:");
my $question = "";
my $answer = "";
if ($sepIndex >= 0) {
	$question = substr($description, 0, $sepIndex);
	$answer = substr($description, $sepIndex + 7);
}
my $title = "";

#strip out html tags like br and p
if ($question =~ /<b>(.*)<\/b>/) {
	$title = $1;
	$question =~ s#<b>.*</b>##;
}

#further normalization
$question =~ s#<[\s]*br[\s]*/>##g;
$question =~ s#^\s+|\s+$##g; #trim whitespaces from both ends

#generate QRCode for the link and save to a temp file
my $outfilename = $randStr->randpattern("cccccccc") . ".png";
my $outfile = $tempdir . "\\" . $outfilename;
qrpng(text => $answer, out => $outfile);

#finally, print the stuff. Format: <title>SEPARATOR<question text>SEPARATOR<name of qrcode temp file that points to the answer URL>
print $title . "SEPARATOR" . $question . "SEPARATOR" . $outfilename;
