## $Id: Stylesheet.pm,v 1.1 2002/04/01 22:13:10 allane Exp $
##
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Stylesheet:         Documents the stylesheets and how to modify them.
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

package Business::Associates::Stylesheet;

use strict;

require Exporter;

BEGIN {
    use Exporter();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    $VERSION = do { my @r = (q$Revision: 1.1 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
    @ISA = qw(Exporter);
    @EXPORT = qw();
    @EXPORT_OK = qw();
    %EXPORT_TAGS = (
		    );
}


1;

__END__


=head1 NAME

Business::Associates::Stylesheet - information on the Associates XSLT stylesheets and how to modify the data processing.

=head1 INTRODUCTION

This document provides information on the standard stylesheet
F<Associates.xslt> included with this package, and shows how to extend
or change the functionality.

This document is therefore concerned with I<data transformation> and
how to transform the XML that is delivered from Amazon.com into a
format suitable for display (i.e. HTML).

For I<visual formatting> see L<Business::Associates::Formatting>.

Ideally, you should have some basic understanding of XSLT when reading
this document.  I can recommend

 Doug Tidwell: XSLT (O'Reilly & Associates, 2001)
 http://www.amazon.com/exec/obidos/ASIN/0596000537/ref=nosim/allanengelhardt

It is a fine book.  Go ahead: buy it, read it.  This document will
still be here when you get back.

=head1 THE PROCESSING MODEL

Before we get going on the details, let us first remind ourselves on
what we might call the processing model of the Associates package.

The first step is to retrieve the raw XML data from Amazon.com (or,
technically, from the local cache if we already have it).  This is
structured data that describes the (currently) fifteen best-selling
titles at Amazon.com for the selection criteria we have chosen.  Those
criteria can be keyword searches or a look-up of a specific category
of product, and are typically chosen by the HTML editor or by the code
that generates the HTML.  The perl code provided by this package
retrieves the XML.

The second step is to transform this raw XML into a format that the
device responsible for the visual display can handle.  In our case,
that device is ultimately the web browser, so we need to transform the
XML data into HTML or xhtml data.  However, the same process model
could be used to render the data in another format, say for inclusion
to a postscript document.  This data transformation is done used XSLT,
a standard and a very powerful tool for transforming XML documents.
This is the subject of this document.

The third step is the visual formatting of the data.  At this stage we
have the data in a format that the visual display device can
understand, and we need to tell it of the details of the formatting.
In out model and for HTML (or xhtml) output, that is done using
traditional Cascading Style Sheets (CSS).  That is the topic of a
separate document and concerns us only so far as it reminds us that we
need to be able to identify each element type in the output such that
the CSS designer can say, for example, "let's have all book titles in
red text".  In HTML, this identification is done by defining C<class>
attributes.

=head1 THE DEFAULT STYLE SHEET

The default style sheet is available in the file
F<stylesheets/Associates.xslt>.  It uses a number of additional
style sheets to keep it modular: we will discuss those in turn.

Let's go through the style sheet in some detail.  Everything in

    <!-- ... -->

are comments, so we'll skip those.

=head2 The Preamble

The first line is

    <?xml version="1.0" encoding="ISO-8859-1"?>

There are two things that are important to remember here.  First, all
XSLT documents are also XML documents with all the restrictions that
that implies.  Second, the default encoding for these documents is
Unicode, specifically UTF-8.  But my editor can not handle Unicode
documents, so I'm careful to specify the Latin 1 character set in the
official format.

You'll need this line as the very first line (no comments) of every
style sheet that you write.

Then we go on to define the actual style sheet:

    <xsl:stylesheet
        xml:lang="en-US"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

One of the slightly tedious things about XSLT is the amount of
typing.  All entities (C<stylesheet> in this example) must be prefixed
by the C<xsl:> string.  This allows you to mix ordinary markup and
XSLT processing markup in the same document.

The C<version> and first C<xmlns> arguments are mandatory, but for the
purposes of this document take it as given that this should be the
second non-comment instruction (first entity) in your style sheet.
Cut and paste is your friend.

This tag is closed towards the end of the document with
C<E<lt>/xsl:stylesheetE<gt>>.  Don't forget that in XML all tags must
be closed, and don't put more than one C<xsl:stylesheet> entity in
your document.

    <xsl:import href="Associates_do.xslt" />

We then import some convenience functions that we will discuss later.
When we later get to modify the behavior of the default style sheet,
you'll see that we import I<it> into our style sheet and then change
some of the functions that are defined in F<Associates_do.xslt>.  If
you have a peek in F<Associates_do.xslt>, you'll see that it is a
style sheet in its own right and follow the same structure in the
beginning as this document.

    <xsl:output
        method="xml"
        version="1.0"
        omit-xml-declaration="yes"
        indent="no"
        encoding="ISO-8859-1"
        media-type="application/xhtml+xml"
        standalone="yes"
        />

This is an important instruction.  It tells the XSLT processor that we
want some output and what format we want it in.  When we get to extend
this default style sheet to provide different or expanded
functionality, we'll do that by writing a new style sheet with an
C<xsl:output> entity and an import of the default.  By using
C<xsl:import> instead of C<xsl:include>, we ensure that our
definitions override the originals.  But we are getting ahead of
ourselves.  Consider it mandatory for style sheets that provide output
(as opposed to templates or variables for reuse) and remember: cut and
paste is your friend.

    <xsl:strip-space elements="availability" />

When Amazon is unable to provide any availability information, they
provide an entity with a single space in it, which is very annoying.
So we tell the XSLT processor to remove it for this element.

=head2 User Parameters

The next section defines a number of parameters that can be used to
customize the behavior of the style sheet and therefore the output
that it generates.  These parameters can be specified on the
F<test.pl> CGI script as additional parameters.  For example, if you
use server side includes (see L<Business::Associates>), then the line

 <!--#include virtual="/cgi-bin/test.pl?keywords=xml&width=3&height=1" -->

in the HTML sets the two parameters C<width> and C<height>.  If you
use the perl functions directly, then the optional argument to
I<Business::Associates::XML->transform()> contains a hash of these parameters:

    $s    = $xml->transform($ss, width => "'3'", height => "'1'");

does the same thing.

Don't worry if this is all Greek to you.  What is important is this:
if you define parameters, people can use them.  So, let's go define
some.

    <xsl:param name="associates_id" select="'allanengelhardt'" />

Occasionally, we need to generate a URL back to Amazon.com, for
example when we display an Amazon.com logo.  For that we need the
associates id.  Here it is (see also L<Business::Associates::XML/transform>).
The default is actually very rarely used since most code provides
sensible values (see L<Business::Associates::Data/"VARIABLES">.

One thing we may want to remind you here: default values are specified
in the C<select> statement and are XPath values.  If you want strings,
you need more quotes, as we have shown.  Otherwise it matches the
C<E<lt>allanengelhardtE<gt>> entity in the XML data, and there aren't
many of those...

    <xsl:param name="width"  select="'3'" />
    <xsl:param name="height" select="'1'" />

You thought we'd never get around to defining those, didn't you?
Well, here they are.  The data that we generate is basically a box
(implemented as an HTML C<table>) of items from Amazon.  These two
variables specify how many items (books, videos, cameras,...) this box
is wide and high.

    <xsl:param name="class" select="'A_catalog'" />

The main table need a class name so the people who does the visual
formatting can find it again.  Often you'll want it to have a specific
name so you can find it.  Maybe "big_box" or
"My_fancy_blue_box_on_the_left_side" : whatever makes you happy.

    <xsl:param name="coversize" select="'T'" />  <!-- one of T,M,L -->

Cover size is a bit misleading for items that are not boos, records,
videos and such, but it is used to indicate the size of the image you
want.  Amazon sends us the B<M>edium size as default, while this sheet
prefers the B<T>humbnail.  You may want the B<L>arge size, but it is
usually very big indeed...

    <xsl:param name="images" select="'auto'" />

Remember the output: we have a basic box of C<width> and C<height>
items from Amazon.  This parameter allows you to put an image on
either (or all) of the four sides of that box.  Valid values are
C<auto top bottom left right none>.  The C<auto> value means put an
image on the left if the height is the longest dimension, otherwise on
the top.  The value C<none> (or the empty string) means don't use
images, and the other values you can probably guess.  By all means use
several of C<auto top bottom left right> in one long string separated
by spaces, but don't mix them with C<none>.

    <xsl:param name="max_title"    select="'30'" />
    <xsl:param name="max_author"   select="'15'" />
    <xsl:param name="max_director" select="'15'" />
    <xsl:param name="truncation"   select="'...'" />

The style sheet truncates very long fields and shows that by adding
the C<truncation> characters to the end.  So, the (maybe future)
author "Engelhardt, Allan" becomes "Engelhardt, A...", truncating such
that the string is no longer than C<max_author> characters.  It is
possible to truncate the title and director fields as well.  Please
don't specify a C<max_> field that is smaller than the length of
C<truncation>...   :-)

    <xsl:param name="img_src_top"    select="'/amazon/a150X75w.gif'" />
    <xsl:param name="img_src_bottom" select="$img_src_top" />
    <xsl:param name="img_src_left"   select="'/amazon/a150X75w.gif'" />
    <xsl:param name="img_src_right"  select="$img_src_left" />

These are the images to show; specifically the content of the C<src>
attribute on the C<img> entity.  I keep my Amazon.com images in an
F<amazon> sub-directory under the document root, and the
F<a150X75w.gif> file is an "In association with Amazon.com" graphics
that I downloaded from http://associates.amazon.com/.
    
    <xsl:param name="img_alt_top"    select="'[In association with Amazon.com]'" />
    <xsl:param name="img_alt_bottom" select="'[In association with Amazon.com]'" />
    <xsl:param name="img_alt_left"   select="'[In association with Amazon.com]'" />
    <xsl:param name="img_alt_right"  select="'[In association with Amazon.com]'" />

The previous attribute defined the value of the C<src> attribute of
the C<img> entity.  This one defines the value of the C<alt> and
C<title> attributes.

    <xsl:param name="disable_img_size" select="1" />

This parameter can be used to disable the automatic generation of
C<width> and C<height> tags for the C<img> entities, when
Business::Associates::Imgsize is installed.  Note the lack of extra quotes here.
See also L<Business::Associates::Imgsize>.  B<NOTE> that the default value is
likely to change in a future release: I<always specify this value
explicitly>.

And with that, we have documented all the parameters of the standards
style sheet.  Now let's look at the structure.

=head2 Catalog Template

    <xsl:template match="catalog">

This is the template that matches the top element of the Amazon XML
structure.

     <div class="Associates">

We can mix ordinary markup and XSLT markup in one file.  Here we first 
define a named division that will clearly mark all the generated code
as output from this library.  This allows our CSS designers to quickly
pinpoint these ads, and they can be dealt with as a group.  For
example, a CSS entry of

    div.Associates { display: none; }

will quickly remove all ads from the site.

      <div>
      <xsl:attribute name="class">
       <xsl:value-of select="product_group" />
      </xsl:attribute>

We have to think of those CSS designers, so here we identify the
product group with a named division.  Again, a CSS entry of

    div.Associates div.Books { display: none; }

will remove all book adverts, but leave the cameras etc. intact.

      <table>
       <xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>

The whole ad is one big table, and here it starts.  Again, we name the
table so the CSS designer can find it and

    div.Associates table.Franks_Sexy_Table { display: none; }

in the CSS file will remove Frank's new ads completely.

       <xsl:call-template name="do_top_image" />

This calls a template (from F<Associates_do.xslt>) that inserts the
top image, if it needs to be inserted.

       <!-- XXX Title -->

I don't normally include comments, but we should probably provide for
a way of inserting a title, maybe "Interesting Books on garden gnomes"
or something.  We don't.

       <tr>

OK, let's stuff something more in the table.  By the way, the
I<do_top_image> template provides its own table row.

        <xsl:call-template name="do_left_image" />

You can guess this one...

        <td class="A__data_table">
         <table class="A__data_table">
          <xsl:call-template name="do_process_product" />
         </table>
        </td>

The important thing here is to note that all the products are in their
own little table within the larger table.  There is a magic named
template, I<do_process_product>, that is responsible for selecting all
the C<product> entities.  It is done this way so we can easily change
things like the sort order -- more later.

        <xsl:call-template name="do_right_image" />
    
       </tr>
    
       <xsl:call-template name="do_bottom_image" />
    
      </table>
      </div>
     </div>
    
    </xsl:template>

We have a few more images to do and some open tags to close (remember:
this is XML and all tags must be closed), and then we are done.

Now that didn't hurt, did it?

One note: what happens if there are no products?  Then
I<do_process_product> returns nothing, and the middle table collapses
to an empty table.  We are left with just the images.

=head2 Product Template

The catalog isn't that interesting: it is the products that we want to
sell.

    <xsl:template match="product">

     <xsl:if test="position() &lt;= $how_many">

We've found the products, and we make a simple test on if we have
already displayed enough of them.  (We can't do it where we select
them, because they are not ordered by that time.  We could, and
probably should, introduce another level of indirection.  Later.)

      <xsl:if test="(position()-1) mod $width = 0">
       <xsl:value-of select="$newline" />
       <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
      </xsl:if>

There is some book-keeping to make sure the new table rows happen
every C<width> item.

      <xsl:call-template name="do_product_content" />

This is the template that does the work.  You knew it would be easy,
didn't you?

      <xsl:if test="position() mod $width = 0">
       <xsl:value-of select="$newline" />
       <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
      </xsl:if>
    
     </xsl:if>
    
    </xsl:template>

More book-keeping to do with the table rows, and we are done.

And that is the end of the default style sheet!  But I think we'd
better have a peek at some of those magic I<do_> templates.

=head1 The Associates_do Style Sheet

We will briefly document the main magic I<do_> named templates, and
then give some examples in the next section on how to use them.

=head2 do_process_product

The I<do_process_product> named template is the main body of the
C<catalog> template.  It provides the sorting mechanism of the style
sheet:

    <xsl:template name="do_process_product">
     <xsl:apply-templates select="product">
      <xsl:sort select="ranking" data-type="number" order="ascending" />
     </xsl:apply-templates>
    </xsl:template>

=head2 do_product_content

The I<do_product_content> named template is the main body of the
C<product> template.  It simply calls two other named templates.

    <xsl:template name="do_product_content">
      <xsl:call-template name="do_product_cover_image" />
      <xsl:call-template name="do_product_text" />
    </xsl:template>

=head2 do_product_cover_image, and do_product_text

These are longer named templates that produce the markup for the
Amazon product images (mistakenly called covers because I was thinking
books: sorry!) and the text that goes with it.

The I<do_product_text> simply extracts all the entity values, as
defined in the Amazon DTD, and puts each in its own named division.
If Amazon ever adds new fields to their XML (e.g. price), then this is
where we would add it.

See the F<Associates_do.xslt> file for the details.

Let's do some examples!

=head1 EXAMPLES

A few examples to get you going with extending and modifying the
style sheets.  It is really easy!

=head2 Swap the Image and Text

By default, the product image is displayed before the text.  Some may
prefer it the other way around.  This is not something you can fix in
CSS, it needs changes tot he data structure, i.e. XSLT.

If you look at the solution in F<AssociatesRight.xslt>, you'll see
that, apart from comments and the usual XML and XSLT preamble, we are
able to do this in exactly five lines of code.

First, we import all the defaults:

    <xsl:import href="Associates.xslt" />

This gives us all the standard templates and variables, and if that
was the only line in our new style sheet, it would do exactly the same
as the old one.

But C<xsl:import> imports with lower priority than what is in the
file, so any templates we define here will override the standard
ones.  Remember, that I<do_product_content> is the body of the
C<product> matching template (see above), so all we have to do is
change it:

    <xsl:template name="do_product_content">
      <xsl:call-template name="do_product_text" />
      <xsl:call-template name="do_product_cover_image" />
    </xsl:template>

Now we do the text before the image.  Call it as, for example,

 <!--#include virtual="/cgi-bin/test.pl?keywords=xml&ss=AssociatesRight" -->

and you'll see books on XML with the text before the image (the C<ss>
parameter tells F<test.pl> what style sheet to use).

That all there is to it.  Honest!

=head2 Change the sort order

Suppose you don't like the default sort order of the products.  First
of all, do you remember what it is?  If not, read the previous
sections.

Maybe we want to sort by the artist name, where artist is either the
author or the director.  For good measure, if there are multiple items
from the same artist, sort by the release date, most recent first.

Oh, and while we are at it, let's increase the defaults for how long
the artist's name can be before we truncate it.

Ready?

The answer is in F<AssociatesArtist.xslt>.  There is all the ususal
XML and XSLT overhead: let's ignore that.  Then there is theusual
import of the standard templates:

    <xsl:import href="Associates.xslt" />

Overhead.  Noise.  Cut and paste is your friend.

First, we fix the defaults:

    <xsl:param name="max_author"   select="'25'" />
    <xsl:param name="max_director" select="'25'" />

That was easy.  Then we need to fix the sort order.

Remember that I<do_process_product> was the heart of the C<catalog>
template (yes: C<catalog>).  We did say it was responsible for sorting
earlier in the manual, so if you had been paying attention, it would
have been easy:

    <xsl:template name="do_process_product">
     <xsl:apply-templates select="product">
      <!-- Sort first by author, then director, then most recently published -->
      <xsl:sort select="author"       data-type="text"   order="ascending"  />
      <xsl:sort select="director"     data-type="text"   order="ascending"  />
      <xsl:sort select="release_date" data-type="number" order="descending" />
     </xsl:apply-templates>
    </xsl:template>

And that's all: less than ten lines of code.

=head1 TO DO

Parameters to specify the image URL, instead of assuming Amazon home page.

Provide title.

=head1 SEE ALSO

See also L<Business::Associates>.

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
