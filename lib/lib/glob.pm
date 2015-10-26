package lib::glob;

use warnings;
use strict;

our $VERSION = '0.03';

use File::Glob qw(bsd_glob);

my $sep = quotemeta($^O =~ /Win32/ ? ';' : ':');

sub import {
    my $class = shift;
    for (split /$sep/o, join ',', @_) {
        # print "looking for libraries in $_\n";

        my $beginning = 0;
        if (substr($_, 0, 1) eq '^'){
            $_ = substr($_, 1);
            $beginning = 1;
        }

        my @paths = bsd_glob($_);

        if ($beginning){
            unshift @INC, @paths;
        } else {
            push @INC, @paths;
        }
    }
}


1;
__END__

=head1 NAME

lib::glob - glob patterns and add matching dirs to module search path

=head1 SYNOPSIS

From Perl...

    use lib::glob '../*/lib';
    use lib::glob '*/lib:/usr/local/perl/*/lib';
    use lib::glob '*/lib:^*/first';

or from the shell...

    perl -Mlib::glob='*/lib:/usr/local/perl/*/lib' script.pl
    perl -Mlib::glob='*/lib:^/usr/local/perl/*/lib' script.pl


=head1 DESCRIPTION

This module globs the given paths and adds then to @INC.

Several path patterns can be passed in a single call separated by
colons (or by semicolons on Windows).

If the ^ character is added at the beginning of the path, every
module of that path will be added at the beginning of @INC.

=head1 BUGS

Please report any bugs or feature requests through the web interface
at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=lib-glob> or just
send me and email.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Salvador FandiE<ntilde>o (sfandino@yahoo.com), all
rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0 or any later version.

=cut
