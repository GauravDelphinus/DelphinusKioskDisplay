#!/usr/bin/perl

use strict;
 
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use HTML::Tree;
use HTML::TreeBuilder;
use HTML::TreeBuilder::XPath;
use String::Random;
 
my $url = "http://feed.dilbert.com/dilbert/daily_strip"; #RSS feed

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download RSS to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($url, $localfile);

#read the contents of the XML and get rid of the temp file
local $/=undef;
open FILE, $localfile or die "Couldn't open file: $!";
my $contents = <FILE>;
close FILE;
unlink $localfile;

#Now parse the xml contents for the the latest comic URL
use XML::Parser::Lite;

my $p1 = new XML::Parser::Lite;
$p1->setHandlers(
    Start => \&hdl_start,
    Char => sub { shift; },
    End => sub { shift; },
);

my $latest_comic_url = "";
$p1->parse($contents);

sub hdl_start{
	if (length($latest_comic_url) <= 0) {
		foreach my $v (@_) {
			if (substr($v, 0, 4) eq "http" && index($v, "daily_strip") >=0 && (index($v, "2016") >=0 || index($v, "2017") >= 0)) {	#example URL: http://feed.dilbert.com/~r/dilbert/daily_strip/~3/gcft9vUxAhw/2016-08-13		
				$latest_comic_url = $v;
			}
		}
    }
}

#download the html to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($latest_comic_url, $localfile);

#read the contents of the html and get rid of the temp file
local $/=undef;
open FILE, $localfile or die "Couldn't open file: $!";
my $contents = <FILE>;
close FILE;
unlink $localfile;

#extract the specific image link
my @lines = split /^/m, $contents;
my @lines2 = grep (/src=/, @lines);
@lines2 = grep (/amuniversal/, @lines2);
my $img = $lines2[0];
$img =~ s#.*src="([^"]*)".*#$1#;
$img =~ s/^\s+|\s+$//g; #trim whitespaces from both ends

print $img;
