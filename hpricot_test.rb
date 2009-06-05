require 'rubygems'
require 'hpricot'  
require 'open-uri'

adds_metar = "http://adds.aviationweather.gov/metars/index.php?submit=1&station_ids="
adds_station = "kmwc"
adds_url = "#{adds_metar}#{adds_station}"

def get_metar(doc)
  return doc.at("font").inner_html
end

test_html = <<END 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<HTML>
<HEAD>
<TITLE>ADDS - METARs form results</TITLE>
<LINK REL="StyleSheet" type="text/css" HREF="/layout/ops/mystyle.css">
</HEAD>
<BODY BGCOLOR="#FFFFFF">
  <TABLE SUMMARY="This table is used for formatting purposes only" BORDER=0 CELLPADDING=3 CELLSPACING=0>
    <TR VALIGN="top">
      <TD ALIGN="left" COLSPAN="2">
        <H2>Aviation Digital Data Service (ADDS)</H2>

        Output produced by METARs form (1715&#160;UTC&nbsp;05 June 2009)<BR>
        found at <A HREF="/metars/index.php"> http://adds.aviationweather.gov/metars/index.php</A><BR>&#160;<BR>
      </TD>
    </TR>
    <TR VALIGN="top">
      <TD ALIGN="left" COLSPAN="2">

<FONT FACE="Monospace,Courier">KMWC 051645Z 24010G18KT 10SM CLR 24/07 A2987</FONT><BR>
      </TD>
    </TR>
  </TABLE>
</BODY>
</HTML>
END

# doc = Hpricot(test_html)
doc = Hpricot(open(adds_url))
puts "METAR = #{get_metar(doc)}"

