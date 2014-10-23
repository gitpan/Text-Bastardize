## -*- Cperl -*-
package Text::Bastardize;
$VERSION = 0.06;
use strict;

###############################################################################
## Copyright (C) 1999 julian fondren

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2 of
## the License, or (at your option) any later version.

## This program is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
## PURPOSE.  See the GNU General Public License for more details.

## You should have received a copy of the GNU General Public
## License along with this program; if not, write to the Free
## Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
## MA 02111-1307 USA
###############################################################################

###############################################################################
## Object Constructor; the object is an array, which is most useful in text
## conversion.
sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = [];
  bless($self, $class);
  return $self;
}
###############################################################################


sub peek {
  # return value of object
  my $self = shift;
  return @{$self};
}

sub charge {
  # alter value of object
  my $self = shift;
  return @{$self} = @_;
}

sub rot13 {
  # return rot13'd value of object
  my $self = shift;
  my @rot13;
  foreach ($self->peek()) {
    y/a-zA-Z/n-za-mN-ZA-M/;
    push @rot13, $_;
  }
  return @rot13;
}

sub k3wlt0k {
  # a slightly modified version of Fmh's t0k.pl
  my $self = shift;
  my @k3wlt0k;
  foreach ($self->peek()) {
    y/A-Z/a-z/;
    s/\bth/d/sg;
    s/ck\b/x0r/sg;
    s/cking\b/x0ring/sg;
    s/cked\b/x0red/sg;
    s/cker/x0r/sg;
    s/or/er/sg;
    s/ing/in/sg;
    s/cause/cus/sg;
    s/fu/f00/sg;
    s/word/werd/sg;
    s/oo/ew/sg;
    s/for/4/sg;
    s/ate/8/sg;
    y/uaes itz clo/v34z 17s s10/;
    s/\'//sg;
    s/\./.../sg;
    s/!/!!!/sg;
    s/\?/???/sg;
    s/\bc/k/sg;
    s/00/o0/sg;
    s/0rk/r0k/sg;
    s/y0v/j00/sg;
    s/[ck]o01/k3wl/sg;
    s/741k/t0k/sg;
    s/j00\B/j3r/sg;
    s/3z/z3/sg;
    s/3r/ur/sg;
    y/a-z/A-Z/;
    push @k3wlt0k, $_;
  }
  return @k3wlt0k;
}


sub rdct {
  # hyperreductionize
  my $self = shift;
  my @rdct;
  foreach ($self->peek()) {
    y/A-Z/a-z/;
    y/!#.,?\'\";//;
    s/of/uv/sg;
    s/one/1/sg;
    s/\b(?:a|e)//sg;
    s/a?n?ks/x/sg;
    s/you/u/sg;
    s/are/r/sg;
    s/youre?/ur/sg;
    s/\B(?:a|e|i|o|u)\B//sg;
    push @rdct, $_;
  }
  return @rdct;
}


sub pig {
  my $self = shift;
  my @pig;         # what is to be returned, the final result
  my @piggie;      # a word-by-word splitting of each element
  my $allupper;
  my $firstupper;
  my $i = 0;
  for my $v ($self->peek()) {   # by line
    @piggie = split(/ /, $v);
    for my $w (@piggie) {	# by word
      "\U$w" eq $w ? $allupper = 1 : $allupper = 0;
      
      # append "way" if word starts with an un'y' vowel
      if (substr($w, 0, 1) =~ /a|e|i|o|u/i) {
	$allupper ? $w .= "WAY" : $w .= "way";
      }
      "\u\L$w" eq $w ? $firstupper = 1 : $firstupper = 0;
      $w =lc $w unless $allupper;
      
      # copy leading consonants to the end of the word,
      # not counting "qu"
      until (substr($w, 0, 1) =~ /a|e|i|o|u|y/i) {
	unless (substr($w, 0, 2) eq "qu") {
	  $w = join '', reverse unpack ('aa*', $w);
	}
      }
      $w .= "ay" unless substr($w,-2,2) eq "ay";
      
      # sickness.
      if ($w =~ /[.!?,%]/s) {
	$w =~ s/([,.!?])//s;
	$w .= $1 if $1;
      }
      if ($w =~ /[\$]/s) {
	$w =~ s/([\$])//s;
	$w .= $1 if $1;
      }		
      
      $w = ucfirst $w if $firstupper;
      $piggie[$i++] = $w;
    }
    push(@pig, join(' ', @piggie));
  }
  return @pig;
}


sub rev {
  # reverse
  my $self = shift;
  my @rev;
  foreach ($self->peek()) {
    push @rev, scalar reverse $_;
  }
  return @rev;
}


sub censor {
  # mild censorship
  my $self = shift;
  my @censor;
 LINE: foreach my $l ($self->peek()) {
    my @w;
  WORD: foreach my $w (split / /, $l) {
      $w =~ y/aeiouAEIOU/**********/
	unless (length $w > 10  or  length $w < 4);
      push @w, $w;
    }
    push @censor, (join ' ', @w);
  }
  return @censor;
}


sub n20e {
  # numerical_abbreviation
  my $self = shift;
  my @n20e;
 LINE: foreach my $l ($self->peek()) {
    my @w;
  WORD: foreach my $w (split / /, $l) {
      my $chars = length $w;
      if ($chars <= 6) {
	push @w, $w;
	next WORD;
      }
      my @chars = (substr($w, 0, 1), substr($w, -1, 1));
      push @w, ($chars[0] . ($chars - 2) . $chars[1]);
    }
    push @n20e, (join ' ', @w);
  }
  return @n20e;
}


1;

__END__

=head1 NAME

I<Text::Bastardize> - a corruptor of innocent text

=head1 SYNOPSIS

    #!/usr/bin/perl -w
    use strict;
    use Text::Bastardize;

    my $text = new Text::Bastardize;
    while (my $line = <>) {
	$text->charge($line);
	$text->k3wlt0k();
    }

=head1 DESCRIPTION

I<Bastardize> provides an magical object into which text
can be charged and then returned in various, slighty
modified ways.

I<Bastardize> has the following methods

=over 4

=item B<new>

I<new> creates the array object.

=item B<charge>

I<charge> defines the object's value, and is the reccomended
way to do so.

=item B<peek>

I<peek> returns the object's value.

=item B<rdct>

I<rdct> converts english to hyperreductionist english.

(ex. "english" becomes "")

=item B<pig>

I<pig> pig latin.

(ex. "hi there" becomes "ihay erethay")

=item B<k3wlt0k>

I<k3wlt0k> a k3wlt0kizer developed originally by Fmh.

The B<SYNOPSIS> has an example of k3wlt0k in use, try tossing that into a file
and running it with ``sh|perl I<k3wlt0k-filename>'' :-)

=item B<rot13>

I<rot13> implements rot13 "encryption" in perl.

(ex. "foo bar" becomes "sbb one")

=item B<rev>

I<rev> reverses the arrangement of characters.

=item B<censor>

I<censor> attempts to censor text which might be innaproriate.

=item B<n20e>

I<n20e> performs numerical abbreviations.

(ex. "numerical_abbreviation" becomes "n20e")

=back

=cut
