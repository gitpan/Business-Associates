<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
## $Id: Associates.xslt,v 1.1 2002/04/01 22:13:10 allane Exp $
##
## Copyright (c) 2002 Allan Engelhardt <allane@cybaea.com>
##
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
-->
<xsl:stylesheet
	xml:lang="en-US"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0">

<xsl:import href="Associates_do.xslt" />

<!-- ALWAYS use indent="no" -->
<xsl:output
	method="xml"
	version="1.0"
	omit-xml-declaration="yes"
	indent="no"
	encoding="ISO-8859-1"
	media-type="application/xhtml+xml"
	standalone="yes"
	/>

<xsl:strip-space elements="availability" />

<!--
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		       Start of user parameters
-->

<xsl:param name="associates_id" select="'allanengelhardt'" />

<!-- The defaults make a small banner, but I really recommend that
     you always specify these variables. -->
<xsl:param name="width"  select="'3'" />
<xsl:param name="height" select="'1'" />

<xsl:param name="class"     select="'A_catalog'" />
<xsl:param name="coversize" select="'T'" />  <!-- one of T,M,L -->

<!-- What static images to show:
<xsl:param name="images" select="'top bottom left right'" />
-->
<xsl:param name="images" select="'auto'" />

<!-- Maximum sizes for some text fields (characters) -->
<xsl:param name="max_title"    select="'30'" />
<xsl:param name="max_author"   select="'15'" />
<xsl:param name="max_director" select="'15'" />
<xsl:param name="truncation"   select="'...'" />

<xsl:param name="img_src_top"    select="'/amazon/a150X75w.gif'" />
<xsl:param name="img_src_bottom" select="$img_src_top" />
<xsl:param name="img_src_left"   select="'/amazon/a150X75w.gif'" />
<xsl:param name="img_src_right"  select="$img_src_left" />

<xsl:param name="img_alt_top"    select="'[In association with Amazon.com]'" />
<xsl:param name="img_alt_bottom" select="'[In association with Amazon.com]'" />
<xsl:param name="img_alt_left"   select="'[In association with Amazon.com]'" />
<xsl:param name="img_alt_right"  select="'[In association with Amazon.com]'" />

<xsl:param name="disable_img_size" select="1" />

<!-- 
			End of user parameters
  ________________________________________________________________________
-->


<xsl:template match="catalog">

 <div class="Associates">

  <div>
  <xsl:attribute name="class">
   <xsl:value-of select="product_group" />
  </xsl:attribute>

  <table>
   <xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>

   <xsl:call-template name="do_top_image" />

   <!-- XXX Title -->

   <tr>

    <xsl:call-template name="do_left_image" />

    <!-- Do all the images and links in their own table -->
    <td class="A__data_table">
     <table class="A__data_table">
      <xsl:call-template name="do_process_product" />
     </table>
    </td>

    <xsl:call-template name="do_right_image" />

   </tr>

   <xsl:call-template name="do_bottom_image" />

  </table>
  </div>
 </div>

</xsl:template>



<xsl:template match="product">

 <xsl:if test="position() &lt;= $how_many">

  <xsl:if test="(position()-1) mod $width = 0">
   <xsl:value-of select="$newline" />
   <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
  </xsl:if>

  <xsl:call-template name="do_product_content" />

  <xsl:if test="position() mod $width = 0">
   <xsl:value-of select="$newline" />
   <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
  </xsl:if>

 </xsl:if>

</xsl:template>




</xsl:stylesheet>