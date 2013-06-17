# This package manages the interface to the DtdAnalyzer tool.  In particular,
# the dtd2xml2json utility.
# This acts as a singleton class that's accessed through the instance() method.
# This uses lazy initialization for the dtd2xml2json utility, so that it will
# only cause an error if there is actually an attempt to use it.

package DtdAnalyzer;

use strict;
use warnings;

# Singleton.
my $inst;


#----------------------------------------------------------
sub instance {
    my $class = shift;
    if (!defined $inst) {
        $inst = {
            'initialized' => 0,
        };
        bless $inst, $class;
    }
    return $inst;
}


#----------------------------------------------------------
sub initialize {
    my $self = shift;

    # Get the XSLT base stylesheet, xml2json.xsl, into the out directory
    my $ddir = which('dtd2xml2json');
    if (!$ddir) {
        die "Can't find dtd2xml2json in my PATH.  That's not good.";
    }
    $ddir =~ s/^(.*)\/.*$/$1\//;
    my $basexslt = $ddir . 'xslt/xml2json.xsl';
    if (!-f $basexslt) {
        die "Can't find the base XSLT file $basexslt.  That's bad.";
    }
    copy($basexslt, 'out');

    $self->{initialized} = 1;
}

1;
