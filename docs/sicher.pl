#!/usr/bin/perl -w

# by Torben Menke https://entorb.net

# DESCRIPTION

# TODO

# IDEAS

# DONE

# Modules: My Default Set
use strict;
use warnings;
use 5.010;    # say
use Data::Dumper;
use utf8;     # this script is written in UTF-8
binmode STDOUT, ':utf8';    # default encoding for linux print STDOUT

# Modules: Perl Standard
use Encode qw(encode decode);

# use File::Path qw/remove_tree/;
# use Time::Local;
# use Storable;               # read and write variables to

@_ = localtime time;

# ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime (time);
my $datestr = sprintf "%02d%02d%02d-%02d%02d%02d", $_[ 5 ] + 1900 - 2000, $_[ 4 ] + 1, $_[ 3 ], $_[ 2 ], $_[ 1 ], $_[ 0 ];

my $outfile = "/home/entorb/sicher/covid-19/$datestr.zip";

say $outfile;

my @listOfFiles;
push @listOfFiles, grep {-f} <*>;    # files only
push @listOfFiles, <eCharts/*>;
push @listOfFiles, <tabulator/*>;
push @listOfFiles, '/var/www/virtual/entorb/data-web-pages/covid-19/newsletter.db';

# print Dumper @listOfFiles;

zipFiles( $outfile, @listOfFiles );


sub zipFiles {

  # Zipping of activityJSONs
  # in: $pathToZip, @files , both in absolute path
  # out: nothing
  my ( $pathToZip, @files ) = @_;
  use IO::Compress::Zip qw(zip $ZipError);
  zip \@files  => $pathToZip,
      TextFlag => 1             # It is used to signal that the data stored in the zip file/buffer is probably text.
      , CanonicalName => 1      # This option controls whether the filename field in the zip header is normalized into Unix format before being written to the zip file.
      #	  , ZipComment    => "Created by Torben's Stava App https://entorb.net/strava"

      # , Level => 9 # [0..9], 0=none, 9=best compression
      or die "zip failed: $ZipError\n";
  return;
} ## end sub zipFiles

# FilterName => sub {s<.*[/\\]><>}    # trim path, filename only
