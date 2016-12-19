#!/usr/bin/perl

 use strict;
 
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use HTML::Tree;
use HTML::TreeBuilder;
use HTML::TreeBuilder::XPath;
use Image::PNG::QRCode 'qrpng';
use String::Random;

my $url = "http://open.live.bbc.co.uk/weather/feeds/en/1880252/3dayforecast.rss";

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
	
my $feed_title = $feed->query('/channel/link');
my $max_count = 1;
my $index = 0;
my @feeds = $feed->query('//item');

my $numQuotes = scalar @feeds;

#extract the data
for (my $i = 0; $i < $numQuotes; $i++) {
	if ($i > 0) {
		print "SEPARATOR";
	}
	my $url =$feeds[$i]->query('link')->text_content;
	my $title = $feeds[$i]->query('title')->text_content;
	my $description = $feeds[$i]->query('description')->text_content;
	$title =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
	$description =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
	
	#now extract the various weather related content values
	my $condition = "";
	my $day = "";

	if ($title =~ /([a-zA-Z]*):\s*([^,]*),.*/) {
		$day = $1;
		$condition = $2;
	}
	
	my $maxTemp = "";
	my $minTemp = "";
	my $humidity = "";

	if ($description =~ /Maximum Temperature: ([0-9]*).*/) {
		$maxTemp = $1;
	}
	if ($description =~ /Minimum Temperature: ([0-9]*).*/) {
		$minTemp = $1;
	}
	if ($description =~ /Humidity: ([0-9]*)%.*/) {
		$humidity = $1;
	}
	print $day . "###" . $condition . "###" . $maxTemp . "###" . $minTemp . "###" . $humidity;
}
