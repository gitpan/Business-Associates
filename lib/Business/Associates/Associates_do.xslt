<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
## $Id: Associates_do.xslt,v 1.3 2002/04/28 16:00:53 allane Exp $
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

<xsl:import href="Associates_utilities.xslt" />
<xsl:import href="Associates_variables.xslt" />

<!-- Templates you are likely to want to customize -->

<xsl:template name="do_process_product">
 <xsl:apply-templates select="product">
  <xsl:sort select="ranking" data-type="number" order="ascending" />
 </xsl:apply-templates>
</xsl:template>

<xsl:template name="do_product_content">
  <xsl:call-template name="do_product_cover_image" />
  <xsl:call-template name="do_product_text" />
</xsl:template>

<xsl:template name="do_product_text">
  <xsl:value-of select="$newline" />
  <td class="A__text">

   <div class="A_ranking">
    <xsl:value-of select="ranking" />
   </div><xsl:value-of select="$newline" />
   
   <div class="A_author">
    <xsl:call-template name="trunc">
     <xsl:with-param name="string" select="author" />
     <xsl:with-param name="length" select="$max_author" />
    </xsl:call-template>
   </div><xsl:value-of select="$newline" />

   <div class="A_director">
    <xsl:call-template name="trunc">
     <xsl:with-param name="string" select="director" />
     <xsl:with-param name="length" select="$max_director" />
    </xsl:call-template>
   </div><xsl:value-of select="$newline" />

   <div class="A_title">
    <a target="_blank">
     <xsl:attribute name="href">
      <xsl:value-of select="tagged_url" />
     </xsl:attribute>
     <xsl:call-template name="trunc">
      <xsl:with-param name="string" select="title" />
      <xsl:with-param name="length" select="$max_title" />
     </xsl:call-template>
    </a>
   </div><xsl:value-of select="$newline" />

   <div class="A_our_price">
    <xsl:value-of select="our_price" />
   </div><xsl:value-of select="$newline" />

   <div class="A_list_price">
    <xsl:value-of select="list_price" />
   </div><xsl:value-of select="$newline" />

   <xsl:variable name="list">
    <xsl:value-of select="translate(list_price, '$£¥', '')" />
   </xsl:variable>

   <xsl:variable name="our">
    <xsl:value-of select="translate(our_price, '$£¥', '')" />
   </xsl:variable>

   <xsl:if test="$list &gt; 0 and $our &gt; 0">
    <div class="A__save_percent">
     <xsl:value-of select="format-number(($list - $our) div $list, '##%')" />
    </div>
   </xsl:if>

   <div class="A_release_date">
    <xsl:value-of select="release_date" />
   </div><xsl:value-of select="$newline" />

   <div class="A_binding">
    <xsl:value-of select="binding" />
   </div><xsl:value-of select="$newline" />

   <div class="A_availability">
    <xsl:value-of select="availability" />
   </div><xsl:value-of select="$newline" />

   <div class="A_asin">
    <xsl:value-of select="asin" />
   </div><xsl:value-of select="$newline" />


  </td>
</xsl:template>

<xsl:template name="do_product_cover_image">
 <xsl:param name="replace" select="concat('.', $coversize, 'ZZZZZZZ.')" />
 <xsl:param name="search"  select="'.MZZZZZZZ.'" />
 
 <xsl:variable name="image">
  <xsl:value-of 
   select="concat(substring-before(image, $search),
           $replace,
           substring-after(image, $search))" />
 </xsl:variable>

  <xsl:value-of select="$newline" />
  <td class="A__cover_image">
   <xsl:element name="a">
    <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
    <xsl:attribute name="href">
     <xsl:value-of select="tagged_url" />
    </xsl:attribute>
    <xsl:element name="img">
     <xsl:attribute name="src">
      <xsl:value-of select="$image" />
     </xsl:attribute>
     <xsl:attribute name="alt">[<xsl:value-of select="substring(title,1,20)" />]</xsl:attribute>
     <xsl:attribute name="title">[<xsl:value-of select="title" />]</xsl:attribute>
     <xsl:call-template name="get_img_size_for_url">
      <xsl:with-param name="url" select="$image" />
     </xsl:call-template>
    </xsl:element>
   </xsl:element>
  </td>
</xsl:template>

<xsl:template name="do_top_image">
  <!-- Do the top image -->
  <xsl:if test="string-length($top_image) &gt; 0">
   <tr class="A__image_top">
    <td class="A__image_top">
     <xsl:attribute name="colspan">
      <xsl:value-of select="$colspan" />
     </xsl:attribute>
     <xsl:call-template name="top-image" />
    </td>
   </tr>
  </xsl:if>
</xsl:template>

<xsl:template name="do_left_image">
   <!-- Do the left image -->
   <xsl:if test="string-length($left_image) &gt; 0">
    <td class="A__image_left">
     <xsl:call-template name="left-image" />
    </td>
   </xsl:if>
</xsl:template>

<xsl:template name="do_right_image">
   <!-- Do the right image -->
   <xsl:if test="string-length($right_image) &gt; 0">
    <td class="A__image_right">
     <xsl:call-template name="right-image" />
    </td>
   </xsl:if>
</xsl:template>

<xsl:template name="do_bottom_image">
  <!-- Do the bottom image -->
  <xsl:if test="string-length($bottom_image) &gt; 0">
   <tr class="A__image_bottom">
    <td class="A__image_bottom">
     <xsl:attribute name="colspan">
      <xsl:value-of select="$colspan" />
     </xsl:attribute>
     <xsl:call-template name="bottom-image" />
    </td>
   </tr>
  </xsl:if>
</xsl:template>

 <!-- OK, it's a hack: I admit it.... -->
 <xsl:variable name="top_image">
  <xsl:call-template name="top-image" />
 </xsl:variable>
 <xsl:variable name="bottom_image">
  <xsl:call-template name="bottom-image" />
 </xsl:variable>
 <xsl:variable name="left_image">
  <xsl:call-template name="left-image" />
 </xsl:variable>
 <xsl:variable name="right_image">
  <xsl:call-template name="right-image" />
 </xsl:variable>
 <xsl:variable name="colspan">
  <xsl:value-of select="1 + number(boolean(string-length($left_image))) + number(boolean(string-length($right_image)))" />
 </xsl:variable>
 <!-- End of stupid hack -->



</xsl:stylesheet>