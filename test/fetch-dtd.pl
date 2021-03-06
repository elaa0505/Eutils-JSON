#!/usr/bin/env perl
# Script for testing EUtils JSON output - fetch-dtd step.

use strict;
use warnings;
use EutilsTest;
use FetchDtdOpts;
use Logger;

#-----------------------------------------------------------------
# Parse command line options, output usage help, etc.

# Usage message:  note where common options usage is inserted
my $usage = q(
Usage:  fetch-dtd.pl [options]

This script computes the location of, and (optionally) fetches a local copy
of the DTD for a set of sample groups.  If the DTD is fetched, it will be put
into the 'out' directory.

In general, the script "knows" where to get the DTD, and doesn't use the actual
doctype declaration from the instance documents.  But, that default behavior
can be overridden.
) .
$EutilsTest::commonOptUsage .
$FetchDtdOpts::optsUsage;

# Process these options.
my $Opts = EutilsTest::getOptions(\@FetchDtdOpts::opts, $usage);

# Post-process fetch-dtd options
FetchDtdOpts::processOpts($Opts);

#-----------------------------------------------------------------
# Create a new test object, and read in the testcases.xml file

my $logger = Logger->new();
my $t = EutilsTest->new($Opts, $logger);
my $samplegroups = $t->{samplegroups};

#-----------------------------------------------------------------
# Now run the test

foreach my $sg (@$samplegroups) {
    next if !$t->filterMatch($sg);
    $logger->setCurrentTest('fetch-dtd', $sg);
    $t->fetchDtd($sg);
}

# Make sure at least one sample was found
if ($logger->{'total-tests'} == 0) {
    die "No test cases were found matching your criteria!";
}

$t->summaryReport();
exit !!$logger->{failures};
