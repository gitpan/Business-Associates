# $Id: test.pl,v 1.2 2002/04/02 12:04:38 allane Exp $
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}
use Business::Associates;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):
use vars qw( $TEST_COUNT );
$TEST_COUNT = 2;

use Business::Associates::Data();
use Business::Associates::XML();
use Business::Associates::Cache();
use Business::Associates::Communication();

ok();

$Business::Associates::Data::Associates_Id = "allanengelhardt";
$Business::Associates::XML::Always_Load = 1; # For debugging!
ok();

{
    my $cache = new Business::Associates::Cache
	and        ok("Created Cache object")
	    or not_ok("Couldn't create Cache object: Does Cache::Cache work?");
}

{
    my $comms = new Business::Associates::Communication
	and        ok("Created Communication object")
	    or not_ok("Couldn't create Communication object: Does LWP::UserAgent work?");
}

my $xml_string = <<ENDXML;
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE catalog [<!ENTITY pound "£">]>
<catalog>

<keyword>travel+photography</keyword>
<product_group>Books</product_group>

<product>
   <ranking>1</ranking>
   <title>Light at the Edge of the World: A Journey Through the Realm of Vanishing Cultures</title>
   <asin>0792264746</asin>
   <author>Davis, Wade</author>
   <image>http://images.amazon.com/images/P/0792264746.01.MZZZZZZZ.jpg</image>
   <release_date>20020200</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0792264746</tagged_url>
</product>
<product>
   <ranking>2</ranking>
   <title>Oregon III</title>
   <asin>0932575285</asin>
   <author>Atkeson, Ray</author>
   <image>http://images.amazon.com/images/P/0932575285.01.MZZZZZZZ.jpg</image>
   <release_date>19870600</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0932575285</tagged_url>
</product>
<product>
   <ranking>3</ranking>
   <title>South with Endurance: Shackleton\'s Antarctic Expedition, 1914-1917</title>
   <asin>074322292X</asin>
   <author>Hurley, Frank</author>
   <image>http://images.amazon.com/images/P/074322292X.01.MZZZZZZZ.jpg</image>
   <release_date>20010925</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/074322292X</tagged_url>
</product>
<product>
   <ranking>4</ranking>
   <title>The World Trade Center Remembered</title>
   <asin>0789207648</asin>
   <author>Bullaty, Sonja</author>
   <image>http://images.amazon.com/images/P/0789207648.01.MZZZZZZZ.jpg</image>
   <release_date>20011109</release_date>
   <binding>Paperback</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0789207648</tagged_url>
</product>
<product>
   <ranking>5</ranking>
   <title>Sometime Lofty Towers: A Photographic Memorial of the World Trade Center</title>
   <asin>0763154725</asin>
   <author>Rajs, Jake</author>
   <image>http://images.amazon.com/images/P/0763154725.01.MZZZZZZZ.jpg</image>
   <release_date>20011017</release_date>
   <binding>Paperback</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0763154725</tagged_url>
</product>
<product>
   <ranking>6</ranking>
   <title>New York September Eleven Two Thousand One</title>
   <asin>097057682X</asin>
   <author>Baravalle, Giorgio</author>
   <image>http://images.amazon.com/images/P/097057682X.01.MZZZZZZZ.jpg</image>
   <release_date>20011130</release_date>
   <binding>Paperback</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/097057682X</tagged_url>
</product>
<product>
   <ranking>7</ranking>
   <title>The Most Beautiful Villages of Tuscany</title>
   <asin>050001664X</asin>
   <author>Bentley, James</author>
   <image>http://images.amazon.com/images/P/050001664X.01.MZZZZZZZ.jpg</image>
   <release_date>19970900</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/050001664X</tagged_url>
</product>
<product>
   <ranking>8</ranking>
   <title>North Carolina on My Mind</title>
   <asin>1560446854</asin>
   <author>Falcon Publishing Company</author>
   <image>http://images.amazon.com/images/P/1560446854.01.MZZZZZZZ.jpg</image>
   <release_date>19990500</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/1560446854</tagged_url>
</product>
<product>
   <ranking>9</ranking>
   <title>The Most Beautiful Villages of Provence</title>
   <asin>0500541876</asin>
   <author>Jacobs, Michael</author>
   <image>http://images.amazon.com/images/P/0500541876.01.MZZZZZZZ.jpg</image>
   <release_date>19941000</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0500541876</tagged_url>
</product>
<product>
   <ranking>10</ranking>
   <title>Crosstown</title>
   <asin>1576871037</asin>
   <author>Helen Levitt</author>
   <image>http://images.amazon.com/images/P/1576871037.01.MZZZZZZZ.jpg</image>
   <release_date>20011000</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/1576871037</tagged_url>
</product>
<product>
   <ranking>11</ranking>
   <title>National Geographic the Photographs</title>
   <asin>0870449869</asin>
   <author>Bendavid-Val, Leah</author>
   <image>http://images.amazon.com/images/P/0870449869.01.MZZZZZZZ.jpg</image>
   <release_date>19941000</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0870449869</tagged_url>
</product>
<product>
   <ranking>12</ranking>
   <title>When the Iron Bird Flies</title>
   <asin>0966410041</asin>
   <author>Clinch, Danny</author>
   <image>http://images.amazon.com/images/P/0966410041.01.MZZZZZZZ.jpg</image>
   <release_date>20001100</release_date>
   <binding>Paperback</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0966410041</tagged_url>
</product>
<product>
   <ranking>13</ranking>
   <title>Private Tuscany</title>
   <asin>0847821781</asin>
   <author>Helman-Minchilli, Elizabeth</author>
   <image>http://images.amazon.com/images/P/0847821781.01.MZZZZZZZ.jpg</image>
   <release_date>19990500</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0847821781</tagged_url>
</product>
<product>
   <ranking>14</ranking>
   <title>Back In The Days</title>
   <asin>1576871061</asin>
   <author>Shabazz, Jamel</author>
   <image>http://images.amazon.com/images/P/1576871061.01.MZZZZZZZ.jpg</image>
   <release_date>20011215</release_date>
   <binding>Hardcover</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/1576871061</tagged_url>
</product>
<product>
   <ranking>A15</ranking>
   <title>Spirit of Place: The Art of the Traveling Photographer</title>
   <asin>0817458948</asin>
   <author>Krist, Bob</author>
   <image>http://images.amazon.com/images/P/0817458948.01.MZZZZZZZ.jpg</image>
   <release_date>20000315</release_date>
   <binding>Paperback</binding>
   <availability> </availability>
   <tagged_url>http://www.amazon.com:80/exec/obidos/redirect?tag=allanengelhardt&amp;creative=11397&amp;camp=1877&amp;link_code=xml&amp;path=ASIN/0817458948</tagged_url>
</product>
</catalog>
ENDXML

{};

my %data = ( xml => $xml_string );
my $fake_data = \%data;

{
    my $xml = new Business::Associates::XML($fake_data)
	and        ok("Created XML object.")
	    or not_ok("Couldn't create XML object: Does XML::LibXML work?");
}

{
    my $xml1 = new Business::Associates::XML($fake_data)
	and        ok("Created XML 1 object")
	    or not_ok("Couldn't create XML 1 object.");
    my $xml2 = new Business::Associates::XML($fake_data)
	and        ok("Created XML 2 object")
	    or not_ok("Couldn't create XML 2 object.");
    $xml1->append($xml2)
	and        ok("Appended XML object")
	    or not_ok("Could not append XML objects");
}

{
    my $xml = new Business::Associates::XML($fake_data)
	and        ok("Created XML object")
	    or not_ok("Couldn't create XML object.");
    for my $ss ("Associates", "AssociatesArtist", "AssociatesRight") {
	$xml->get_stylesheet($ss)
	    and        ok("Found style sheet $ss")
		or not_ok("Could not find $ss style sheet.");
    }
}

{
    my $xml = new Business::Associates::XML($fake_data)
	and        ok("Created XML object")
	    or not_ok("Couldn't create XML object.");
    my %args = (disable_img_size => "true()");
    my $s = $xml->transform("Associates", %args)
	and        ok("Transformed XML object")
	    or not_ok("Couldn't transform XML object.");
}

sub ok
{
  my ( $message ) = @_;

  print "#$message\n" if $message;
  print "ok $TEST_COUNT\n";

  $TEST_COUNT++;
  return 1;
}


sub not_ok
{
  my ( $message ) = @_;

  print "not ok $TEST_COUNT #  $message\n";

  $TEST_COUNT++;
  return 0;
}


sub skip
{
  my ( $message ) = @_;

  print "ok $TEST_COUNT # skipped: $message\n";

  $TEST_COUNT++;
  return 1;
}
