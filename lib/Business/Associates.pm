## $Id: Associates.pm,v 1.4 2002/04/28 16:02:09 allane Exp $
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Associates - Documentation and global version number.
##
## Copyright © 2002 Allan Engelhardt <allane@cybaea.com>
##
## Amazon, Amazon.com, and other names used may be trademarks of Amazon
## in the United States of America and other jurisdictions.
##
## ************************************************************************
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
## ************************************************************************
##

package Business::Associates;

require 5.6.0;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Business::Associates ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '1.00';


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Business::Associates - a library to handle the new XML interface for the Amazon.com Associates program.



=head1 SUMMARY

This package replaces the Amazon Recommends (tm) links to provide a
powerful and simple to use interface that allows you to embed complex,
highly targeted ads on your web site (or other documents).

This modules supports many new features that are not available with
the standard interfaces.  For example, multi-mode searches, i.e. the
ability to search across multiple product categories
(dvd+video+music+...) is fully supported.

See also http://cybaea.com/Associates.html for more information and
example screen shots.

Currently, only the Amazon.com Associates program is supported.



=head1 OVERVIEW OF DOCUMENTATION

The good news is that if you are new to this library, then you are
reading the right document.  Carry on!

This document tells you everything you need to know to get started
with the package.  It takes you through including complex ads on your
web site so you can start making money now.

The Associates package uses a three-stage working model:

=over 4

=item 1.

Retrieve data from the Associates program's XML interface.  In the
case of Amazon's program, that involves a HTTP request to the
C<rcm.amazon.com> server.

=item 2.

Transform the data into the desired output format.  This is done using
a technology known as XSLT and, in the examples included in this
distribution, it converts the XML from the server into HTML that we
can display as part of our web site.

=item 3.

Format the data visually.  For the HTML output that we generate here,
we use Cascading Style Sheets (CSS) which is the standard way to
specify the formatting of a web site.

=back

This document, L<Business::Associates>, provides an installation and
quick-start guide, as well as an overview of the entire package.  Read
this first.

The three stages are documented in three different overview documents:

=over 4

=item 1.

Data retrieval is documented in L<Business::Associates> (this
document).

=item 2.

Data transformation is documented in detail in
L<Business::Associates::Stylesheet>.

=item 3.

Visual formatting is documented in detail in
L<Business::Associates::Formatting>.

=back

Additionally, for detailed programmer's references, see
L<Business::Associates::Data>, L<Business::Associates::XML>,
L<Business::Associates::Cache>,
L<Business::Associates::Communication>, and
L<Business::Associates::Imgsize>.  The order suggested here will
minimize forward references, but I strongly suggest that you read the
three documents above first.



=head1 INSTALLATION

If you are reading this, then chances are that you have already
installed the package.  But here are the instructions again:

Download the latest version of the package from
http://cybaea.com/Associates.html.  It will be in the form of a
compressed archive with the name F<Business-Associates-x.yy.tar.gz>
where I<x.yy> is the version number (e.g. 1.00).  Unpack this archive
and go to the newly created directory.  On a Unix-like system, you
would do

    $ gunzip -c Business-Associates-x.yy.tar.gz | tar xvf -
    $ cd Business-Associates-x.yy

Then build and install the package in the usual perl way.  Note that
to install you probably have to be C<root>.

    $ perl Makefile.PL
    $ make
    $ make test
    % make install

For more information on this process, including how to install without
being the superuser, see L<ExtUtils::MakeMaker>.

=head2 Copy demo files

This is an optional step, but you will probably want to copy the files
from the F<demo/> sub-directory: F<demo/Associates.css> and
F<demo/associates.shtml> normally go to the document root of your web
server, while F<demo/a.pl> goes to your C<cgi-bin> directory.  For my
server (Red Hat Linux), I do:

    $ cp demo/Associates.css demo/associates.shtml /var/www/html/
    $ cp demo/a.pl /var/www/cgi-bin/

Your directories may vary.  You should edit the F<a.pl> file to
include your Amazon.com Associates Id (instead of the default, which
is mine).  Find the line

    $Business::Associates::Data::Associates_Id = "allanengelhardt";

and change C<allanengelhardt> to your id.

You'll probably want to incorporate (some form of) the cascading style
sheet in your main style sheet.  You can do this easily by adding

    @import url("/Associates.css");

near the top of your style sheet (before any instructions).

If your web server is already configured for server-side includes, and
it is running, then you should now be able to do

    $ mozilla http://localhost/associates.shtml

to see the results (requires an active internet connection).
Substitute your web browser for C<mozilla> above.

=head2 Images

The default scripts and style sheets provided with this package
references a number of images from Amazon that are not provided in
this download.  You'll need an Amazon.com Associates account to
download them from

 https://ssl-images.amazon.com/images/G/01/associates/logos2000/a150X75w.gif
 https://ssl-images.amazon.com/images/G/01/associates/logos2000/126X32-w-logo.gif
 https://ssl-images.amazon.com/images/G/01/associates/photo2000/cp_pic_88x31.gif

The samples expect to find them in the F<amazon> sub-directory from
the web server's document root (typically something like
F</var/www/html/amazon/>.

See F<README.XSLT-STYLESHEETS> for more information.

=head2 Server Side Includes

If your Apache server is not already configured for server-side
includes, then enable it in F<httpd.conf> by finding and un-commenting
the lines

    #
    # To use server-parsed HTML files
    #
    AddType text/html .shtml
    AddHandler server-parsed .shtml

See your Apache manual for details.

For other web servers, please consult the manual.

=head2 No Server Side Includes !?

If your server is not configured for server-side includes, then you
should still be able to test the package with a command like

    $ mozilla http://localhost/cgi-bin/a.pl?keywords=make+money+now

though your browser may display the HTML source rather than rendering
it.  (Try saving as an F<.html> file and then loading that, if this is
the case.)




=head1 QUICK START

Please read the L</"INSTALLATION"> first.

I assume that you already have an Amazon Associates account.  The
Amazon Associates program provides for individual web sites to sell
books and other items to their visitors through Amazon.com while
earning a small commission, at the time of writing usually 5%.  For
more information please see http://associates.amazon.com/.

The sections below cover L<HTML|/"Quick Start: HTML">, L<CGI|/"Quick
Start: CGI">, and L<mod_perl|/"Quick Start: mod_perl"> interfaces to
this package.

=head2 Quick Start: HTML

All that is needed to start using this package is I<a single line> in
your HTML page.  If you are using Apache with server-side includes
then that line could be as simple as:

 <!--#include virtual="/cgi-bin/p.pl?keywords=xml&width=3" -->

This makes a simple banner three items wide with a logo (Amazon's or
your own - it's your choice) to the left of the items.  It does a
keyword search for books (the default) on the string "xml" and
displays the top three Amazon best sellers.

=head2 Quick Start: CGI

Below, we present a complete CGI program that uses this package.
Apart from declarations, it is I<only four lines long>.

    #!/usr/local/bin/perl -Tw

    use Business::Associates::Data();
    use Business::Associates::XML();
    $Business::Associates::Data::Associates_Id = "'allanengelhardt'";
    
    my %args = (
       associates_id => $Business::Associates::Data::Associates_Id,
       disable_img_size => "true()"
    	        );
    
    my $what = "xml";               # Search string
    my $mode = "books";             # Product category
    my $ss_name = "Associates";
    my $type = "keywords";          # Or: browse
    
    my $data = Business::Associates::Data->$type ($what, $mode);
    my $xml  = new Business::Associates::XML ($data)
               if defined $data->xml();
    
    my $s    = $xml->transform($ss_name, %args) if defined $xml;
    print "\n\n$s\n"                            if defined $s;


You should change the value of I<Associates_Id> from
C<allanengelhardt> to your own Amazon.com Associates Id.  Note the
extra quotes in that string.

For the moment, treat I<%args> as a magic argument.  The I<$what>
variable is the search string for keyword searches, and you should
separate keywords with the C<+> character (e.g.
C<$what = "make+money+fast">.  If I<$type> is C<"browse">, then
I<$what> is the browse category (e.g. C<"301668"> for popular music).

Normally, you'd get these arguments from the CGI parameters, see
F<demo/a.pl> for an example of this, and see also L<CGI>.

See also F<demo/a.pl> for an example that supports searches across
multiple product categories.

See L</"CGI SCRIPT"> for more details on options to the F<a.pl>
script.

=head2 Quick Start: mod_perl

The module is easy to use from any perl program and provides maximum
performance from mod_perl (see next section).  See the previous
section for an example, and the individual package documentations for
the complete API.




=head1 BACKGROUND

The Amazon Associates program provides for individual web sites to
sell books and other items to their visitors through Amazon.com while
earning a small commission, at the time of writing usually 5%.  For
more information please see http://associates.amazon.com/.

The Associates web site provides many tools for building links to
products on Amazon.com, but in early 2002 a completely new interface
was developed to allow web sites full control to build their links as
they wanted.

This new interface returns structured data about best selling items at
Amazon.  It is currently possible to retrieve this data for any of
Amazon's product lines, including books, magazines, DVDs, etc.  The
data can be specified by keyword search (e.g. "garden+furniture") or
by browse category, which is a classification of Amazon's items (e.g.
C<All Products / Camera & Photo / Brands / Canon / Film Cameras / SLR
Cameras>) that provide fine-grained control over the items returned.

This structured data is provided as XML, which is a popular way to
encode both data and the information about data.  For more information
on XML you can look at http://www.xml.org/ and http://www.xml.com/ for
tutorials, tips, and further links.  XML is an official standard of
the World Wide Web consortium who you can find at http://www.w3.org/.

Even though there are many and excellent tools for manipulating XML it
can be a bit daunting.  This package brings together all the tools
for building efficient ads on your web site.

Some of the benefits and design goals of this package are outlined in
the subsections below.

=head2 Performace

On my middle-of-the-road Pentium machine running Linux, the conversion
of the raw Amazon XML to the formatted HTML banner (about 3k of HTML)
takes about 7 milliseconds.  Conversion of the same XML to another
HTML format (e.g. to sort by author or price instead of the default
sales rank) takes only about 5 milliseconds.  The parsed style sheets
are cached in memory, saving 2 milliseconds on all but the very first
call.

To get anywhere near this performance you need to use mod_perl or some
similar technique that avoids the overhead of creating a new process.

The included CGI script run in just under 300 ms on my machine when
retrieving the data from disk.  A very large part of this is the
overhead of starting a new process and loading perl: the core
processing is less than 30 ms.

=head2 Efficiency

For efficiency and to reduce network load, this package automatically
caches the results from Amazon for 24 hours.  Next time your web
server needs the results for a given keyword combination of browse
category it is retrieved from your disk, not from the network.  This
greatly improves the performance of your system.

Amazon only updates the bestseller list every 24 hours, so you are not
loosing information by this.

The caching is also a condition for using the Amazon XML interface.

=head2 Separation of Code, Data, and Presentation

The design of this package separates code, data, and presentation to
simplify maintenance of complex web sites.

The code is written in pure perl, and should run on practically any
machine regardless of architecture.  It is responsible for the result
caching and network communication, and for orchestrating the whole
effort.

Data transformation is done using XSLT which is a standard for
transforming XML.  This is a very powerful transformation language
with excellent support of development tools.  This package includes a
powerful default transformation as well ans several well-documented
examples on how to extend or modify this.

The presentation is managed using standard cascading style sheets.
All HTML (or xhtml) elements are clearly and uniquely identified ,
allowing precise control over the look of the finished result.  It is
possible to have different visual formatting for different result
categories (e.g. Books can look different from Electronics).

=head2 Portable

The package is developed in perl, and should work on any platform with
a functioning perl installation.

The package uses libxml2 and libxslt, two excellent libraries from the
Gnome project (http://www.gnome.org).  These are pure C libraries and
should provide maximum portability (and performance, see
L</Performance>).

=head1 DESCRIPTION

This package offers the ability to create ads and other information in
conjunction with an Associates program.

An I<Associates program> is a service provided by an online retailer
whereby affiliates are rewarded for referrals to the retailer.
Typically, the reward is a percentage of the sales price.  The best
known of these programs, and the only one currently supported by this
package, is the Amazon.com Associates program.  For more information,
and to sign up, please visit http://associates.amazon.com/.

This package works with an Associates program that provide an XML
interface to their search engines.  In the example of the Amazon.com
interface, it is possible to obtain their bestseller lists for any
category of product (books, DVDs, software...) for specific keywords
(e.g. Jennifer+Lopez) or for a specific "browse category" (e.g. Canon
brand 35mm SLR film cameras).

XML is a standard way of encoding data and information about the data
(e.g. "this is a title", "this is a price"...) that is very popular
and has good tool support.  However, XML is not usually intended to be
viewed directly by the end-user, instead it is an intermediate format
that should be converted, for example to HTML.

The Associates package uses a three-stage processing model:

=over 4

=item 1.

B<Data retrieval>.  The raw XML data is retrieved from the Associates
program's XML server, using keywords or browse categories.  For
efficiency, the XML data is cached locally, reducing the network load
of your web server.

=item 2.

B<Data transformation>.  The raw XML data is then transformed to the
target data format, usually HTML which allows your web server to
display banner ads and the like.

=item 3.

B<Visual formatting>.  The transformed data needs to be formatted
visually.  This includes setting font sizes, deciding on image
displays, etc.

=back

These are separate stages to support separation of code and data, to
allow maximum scalability of your web site, and to allow for other
formats (e.g. different ads for WAP or iMode devices).

=head2 CGI SCRIPT

The provided CGI script, F<a.pl>, is, with server-side includes, the
easiest way to get started with this package.  The script accepts a
number of arguments.  Many of them are shown in the
F<associates.shtml> file in the F<demo/> sub-directory, and in the
following we briefly summarize the main options.


=over 2

=item I<type>     [Default: keywords]

Must be one of "browse" or "keywords" for browse category or keyword
searches, respectively.  Defaults to "keywords".

Examples:

 <!--#include 
     virtual="/cgi-bin/a.pl?type=keywords&keywords=canon+slr&mode=photo" -->

 <!--#include
     virtual="/cgi-bin/a.pl?type=browse&keywords=163306&mode=dvd" -->


=item I<keywords> [Required]

=item I<browse>   [Required]

This is a string that indicates the keywords (for keyword searches) or
the browse category (for browse searches) for which the bestseller
list should be retrieved.  The two forms, I<keywords> and I<browse>
are synonyms.  This is the only required argument.  Separate multiple
arguments with a C<+>, and be sure to encode any arguments that are
not valid in a URL with the C<%xx> notation (see also L<URI::Escape>
or L<Apache::Util>).

Examples

 <!--#include 
     virtual="/cgi-bin/a.pl?keywords=xml+xslt&mode=books" -->

Keyword search for books on XML and XSLT.

 <!--#include
     virtual="/cgi-bin/a.pl?type=browse&browse=163306&mode=dvd" -->

Browse category search.

=item I<mode>      [Default: books+music+dvd]

The so-called I<mode> or product category to search.  Separate
categories with a C<+> sign.

Valid modes for the Amazon.com Associates program includes: C<books
magazines music classical-music vhs dvd toys baby videogames
electronics software universal garden kitchen photo pc-hardware>.

Note that multi-mode searches can take some time when the data is not
cached.

=item I<width>     [Default: '3']

The output of the default data transformation style sheets is a box of
items.  This parameter specifies the width of that box, in number of
items.  See also I<height> below.

=item I<height>    [Default: '1']

The output of the default data transformation style sheets is a box of
items.  This parameter specifies the height of that box, in number of
items.  See also I<width> above.

Example:

  <!--#include
      virtual="/cgi-bin/a.pl?keywords=xml&width='3'&height='1'" -->

The quotes are optional, but recommended (the parameters are
technically XPath specifications).

=item I<ss>        [Default: Associates.xslt]

Specifies the style sheet that is responsible for the data
transformation stage of the processing.  For example, to sort items by
artist (instead of the default sales rank), use

 <!--#include virtual="/cgi-bin/a.pl?keywords=adams+douglas&ss=AssociatesArtist&width=5&height=3&images='none'" -->

=item I<images>   [Default: 'auto']

The Associates package has the ability to display images on any of the
four sides of the advertisement.  Use any combination of C<'auto'>,
C<'top'>, C<'left'>, C<'right'>, and C<'bottom'> separated by spaces,
or C<'none'>.  The value C<'auto'> puts an image on the top if C<width
E<lt>= height> and on the left if C<width E<gt> height>.

 <!--#include virtual="/cgi-bin/a.pl?keywords=apache+web+server&img_src_top='/amazon/126X32-w-logo.gif'&images='bottom'" -->

Note the extra quotes (this is an XPath parameter).

=item I<img_src_(top|left|right|bottom)>

This is the source (C<SRC> attribute of the HTML C<IMG> tag) of the
images (see I<images> above).  The default is
C<'/amazon/a150X75w.gif'>.  Note the extra quotes.  See example in the
previous item.

=item I<class>    [Default: 'A_catalog']

The default transformation style sheets produces a HTML C<table>
containing the ad.  This specifies the C<class> attribute of the
C<table> entity.  See also L<Associates::Formatting>.

 <!--#include virtual="/cgi-bin/a.pl?class='right_float'&keywords=apache+web+server&mode=books&ss=Associates&width=1&height=1&img_src_top='/amazon/126X32-w-logo.gif'&images='bottom'" -->

=item I<coversize> [Default: 'T']

Specifies the size of the image used for the cover.  Valid values
include 'T', 'M', and 'L' for thumbnails, medium, and large images,
respectively.  Note the extra quotes.

=back


=head1 TO DO

Upload to CPAN.

More XSLT examples.

More tests in the install scripts.

=head1 SEE ALSO

Data transformation is documented in detail in
L<Business::Associates::Stylesheet>.

Visual formatting is documented in detail in
L<Business::Associates::Formatting>.

Additionally, for detailed programmer's references, see
L<Business::Associates::Data>, L<Business::Associates::XML>,
L<Business::Associates::Cache>,
L<Business::Associates::Communication>, and
L<Business::Associates::Imgsize>.  The order suggested here will
minimize forward references.

See also
L<CPAN>, http://www.perl.com/CPAN,
L<httpd>, http://www.apache.org/,
L<XML::LibXML>, L<XML::LibXSLT>, L<libxml>, http://www.gnome.org/,
L<Cache::Cache>, L<File::Spec>, L<HTTP::Request>, L<LWP::UserAgent>

=head1 TRADEMARKS

Amazon, Amazon.com, and other names used in this document may be the
registered trademark of Amazon in the United States of America and
other jurisdictions.  Please see http://www.amazon.com/ for more
information.

Other names may be trademarks of their respective owners.

=head1 AUTHOR

This package was written by Allan Engelhardt E<lt>allane@cybaea.comE<gt>

=head1 COPYING

Copyright (c) 2002 Allan Engelhardt E<lt>allane@cybaea.comE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA

=cut
