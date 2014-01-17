<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions">
   <xsl:output method="html" encoding="utf-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd"
      doctype-public="-//W3C//DTD HTML 4.01//EN"></xsl:output>

<xsl:template match="/">
<html encodingxmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="cssstylesheet.css" />
    <title><xsl:value-of select="//titleStmt/title"/></title>
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script src="waypoints.js"></script>
    <script src="waypoints-sticky.js"></script>
    <script type="text/javascript">
    <![CDATA[
    $(function() {
      $( ".struct-container" ).accordion({
        collapsible: true
      });
      $( ".chayacontainer" ).accordion({
        collapsible: true,
        active: false
      });
      $( ".struct-container a").click(function() {
        window.location = $(this).attr('href');
        return false;
      });
    });
$(document).ready(function() {
  $('.nav-container').waypoint('sticky');
});
// qTip - CSS Tool Tips - by Craig Erskine
// http://qrayg.com
//
// Multi-tag support by James Crooke
// http://www.cj-design.com
//
// Inspired by code from Travis Beckham
// http://www.squidfingers.com | http://www.podlob.com
//
// Copyright (c) 2006 Craig Erskine
// Permission is granted to copy, distribute and/or modify this document
// under the terms of the GNU Free Documentation License, Version 1.3
// or any later version published by the Free Software Foundation;
// with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
// A copy of the license is included in the section entitled "GNU
// Free Documentation License".

var qTipTag = "a,label,input"; //Which tag do you want to qTip-ize? Keep it lowercase!//
var qTipX = 0; //This is qTip's X offset//
var qTipY = 15; //This is qTip's Y offset//

//There's No need to edit anything below this line//
tooltip = {
  name : "qTip",
  offsetX : qTipX,
  offsetY : qTipY,
  tip : null
}

tooltip.init = function () {
	var tipNameSpaceURI = "http://www.w3.org/1999/xhtml";
	if(!tipContainerID){ var tipContainerID = "qTip";}
	var tipContainer = document.getElementById(tipContainerID);

	if(!tipContainer) {
	  tipContainer = document.createElementNS ? document.createElementNS(tipNameSpaceURI, "div") : document.createElement("div");
		tipContainer.setAttribute("id", tipContainerID);
	  document.getElementsByTagName("body").item(0).appendChild(tipContainer);
	}

	if (!document.getElementById) return;
	this.tip = document.getElementById (this.name);
	if (this.tip) document.onmousemove = function (evt) {tooltip.move (evt)};

	var a, sTitle, elements;
	
	var elementList = qTipTag.split(",");
	for(var j = 0; j < elementList.length; j++)
	{	
		elements = document.getElementsByTagName(elementList[j]);
		if(elements)
		{
			for (var i = 0; i < elements.length; i ++)
			{
				a = elements[i];
				sTitle = a.getAttribute("title");				
				if(sTitle)
				{
					a.setAttribute("tiptitle", sTitle);
					a.removeAttribute("title");
					a.removeAttribute("alt");
					a.onmouseover = function() {tooltip.show(this.getAttribute('tiptitle'))};
					a.onmouseout = function() {tooltip.hide()};
				}
			}
		}
	}
}

tooltip.move = function (evt) {
	var x=0, y=0;
	if (document.all) {//IE
		x = (document.documentElement && document.documentElement.scrollLeft) ? document.documentElement.scrollLeft : document.body.scrollLeft;
		y = (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop : document.body.scrollTop;
		x += window.event.clientX;
		y += window.event.clientY;
		
	} else {//Good Browsers
		x = evt.pageX;
		y = evt.pageY;
	}
	this.tip.style.left = (x + this.offsetX) + "px";
	this.tip.style.top = (y + this.offsetY) + "px";
}

tooltip.show = function (text) {
	if (!this.tip) return;
	this.tip.innerHTML = text;
	this.tip.style.display = "block";
}

tooltip.hide = function () {
	if (!this.tip) return;
	this.tip.innerHTML = "";
	this.tip.style.display = "none";
}

window.onload = function () {
	tooltip.init ();
}
    ]]>
    </script>
  </head>
  <body>
  <xsl:apply-templates/>
  </body>
</html>
</xsl:template>

<!-- get rid of header and front matter !-->
<xsl:template match="teiHeader"/>
<xsl:template match="text/front"/>

<!-- let's have a table of contents too !-->
<xsl:template match="//text/body"> 
  <table id="container">
  <tr>
  <td id="content"><xsl:apply-templates/></td>
  <td id="rightbar">
  <div class="toc">
  <h2><xsl:text>contents</xsl:text></h2>
  <xsl:for-each select="./div"> <!-- first-level: for paricchedas, prakāśas, adhyāyas, etc. !-->
    <p class="divhead"><a href="#{xml:id}">
    <xsl:value-of select="head[@type='toc']"/></a></p>
    <xsl:for-each select="./div[@type='structural']"> <!-- second-level !-->
      <p class="div2head"><a href="#{@xml:id}">
        <xsl:if test="@n"><xsl:value-of select="@n"/>
          <xsl:text>: </xsl:text>
        </xsl:if><xsl:value-of select="head[@type='toc']"/></a></p>
      <xsl:for-each select="./div[@type='structural']"> <!-- third-level !-->
        <p class="div3head"><a href="#{@xml:id}">
          <xsl:if test="../@n">
            <xsl:value-of select="../@n"/>
            <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
          </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
        <xsl:for-each select="./div[@type='structural']"> <!-- fourth level !-->
          <p class="div4head"><a href="#{@xml:id}">
            <xsl:if test="../../@n">
              <xsl:value-of select="../../@n"/>
              <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
              </xsl:if>
            </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
          <xsl:for-each select="./div[@type='structural']"> <!-- fifth level !-->
            <p class="div5head"><a href="#{@xml:id}">
              <xsl:if test="../../../@n">
                <xsl:value-of select="../../../@n"/>
                <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                  <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                    <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                  </xsl:if>
                </xsl:if>
              </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
            <xsl:for-each select="./div[@type='structural']"> <!-- sixth level !-->
              <p class="div6head"><a href="#{@xml:id}">
                <xsl:if test="../../../../@n">
                  <xsl:value-of select="../../../../@n"/>
                  <xsl:if test="../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../@n"/>
                    <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                      <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                        <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if>
                </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
              <xsl:for-each select="./div[@type='structural']"> <!-- seventh level !-->
                <p class="div7head"><a href="#{@xml:id}">
                  <xsl:if test="../../../../../@n">
                    <xsl:value-of select="../../../../../@n"/>
                    <xsl:if test="../../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../../@n"/>
                      <xsl:if test="../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../@n"/>
                        <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                          <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                            <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
  </div></td>
  </tr>
  </table>
</xsl:template>

<xsl:template match="head[@type='toc']"/>

<!-- BODY !--> 
<xsl:template match="head">
<span class="head"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="trailer">
<span class="trailer"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="div">
  <xsl:if test="@xml:id"><a name="{@xml:id}"/></xsl:if>
  <div><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="div[@type='structural']">
  <xsl:if test="@xml:id"><a name="{@xml:id}"/></xsl:if>
  <div class="struct-container">
    <div class="nav-container">
    <div class="struct-topnav">
      <b><xsl:value-of select="head[@type='toc']"/></b>  <!-- present level !-->
      <xsl:if test="../div[@type='structural']">
        <xsl:text> &lt; </xsl:text><a href="#{../@xml:id}"><xsl:value-of select="../head[@type='toc']"/></a> <!-- present level -1 !-->
        <xsl:if test="../../div[@type='structural']">
          <xsl:text> &lt; </xsl:text><a href="#{../../@xml:id}"><xsl:value-of select="../../head[@type='toc']"/></a> <!-- present level -2 !-->
          <xsl:if test="../../../div[@type='structural']">
            <xsl:text> &lt; </xsl:text><a href="#{../../../@xml:id}"><xsl:value-of select="../../../head[@type='toc']"/></a> <!-- present level -3 !-->
            <xsl:if test="../../../../div[@type='structural']">
              <xsl:text> &lt; </xsl:text><a href="#{../../../../@xml:id}"><xsl:value-of select="../../../../head[@type='toc']"/></a> <!-- present level -4 !-->
              <xsl:if test="../../../../../div[@type='structural']">
                <xsl:text> &lt; </xsl:text><a href="#{../../../../../@xml:id}"><xsl:value-of select="../../../../../head[@type='toc']"/></a> <!-- present level -5 !-->
                <xsl:if test="../../../../../../div[@type='structural']">
                  <xsl:text> &lt; </xsl:text><a href="#{../../../../../../@xml:id}"><xsl:value-of select="../../../../../../head[@type='toc']"/></a> <!-- present level -6 !-->
                </xsl:if>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:if>
    <div class="struct-topnav-left"></div>
    <div class="struct-topnav-right"></div>
    </div> 
    </div> 
    <!-- <span class="struct-topnav"><xsl:value-of select="head[@type='toc']"/><xsl:text> – </xsl:text>
      <a class="toggle" href="javascript:toggle('{@xml:id}')">collapse</a></span> !-->
    <div class="structural" id="{@xml:id}"> 
    <xsl:apply-templates/>
    </div>
    <!-- 
    <span class="struct-nav">
      <xsl:if test="../div[@type='structural']">
        <xsl:if test="../../div[@type='structural']">
          <xsl:if test="../../../div[@type='structural']">
            <xsl:if test="../../../../div[@type='structural']">
              <xsl:if test="../../../../../div[@type='structural']">
                <xsl:if test="../../../../../../div[@type='structural']">
                  <a href="#{../../../../../../@xml:id}"><xsl:value-of select="../../../../../../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text> 
                </xsl:if>
                <a href="#{../../../../../@xml:id}"><xsl:value-of select="../../../../../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text>
              </xsl:if>
              <a href="#{../../../../@xml:id}"><xsl:value-of select="../../../../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text>
            </xsl:if>
            <a href="#{../../../@xml:id}"><xsl:value-of select="../../../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text>
          </xsl:if>
          <a href="#{../../@xml:id}"><xsl:value-of select="../../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text>
        </xsl:if>
        <a href="#{../@xml:id}"><xsl:value-of select="../head[@type='toc']"/></a><xsl:text> &gt; </xsl:text> 
      </xsl:if><b><xsl:value-of select="head[@type='toc']"/></b>
    </span>  !-->
  </div>
</xsl:template>

<!-- for verse !--> 
<xsl:template match="lg">
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@type='mula'">
      <div class="mula">
      <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:when test="@type='chāyā'">
      <div class="chayacontainer">
      <span class="chayatoggle">[छाया]</span>
      <div class="chaya" id="{@corresp}-ch"><xsl:apply-templates/></div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="lg">
      <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- style lines depending on metrical form !-->
<!-- not presently doing anything with this, since CSS will work !-->
<xsl:template match="l">
  <xsl:if test="position()!=last()">
    <span class="line"><xsl:apply-templates/></span>
  </xsl:if>
  <xsl:if test="position()=last()">
    <span class="line"><xsl:apply-templates/></span>
  </xsl:if>
</xsl:template>
<xsl:template match="l/seg[@type='pada']">
  <xsl:variable name="letter" select="substring(@xml:id,string-length(@xml:id))"/>
  <span class="{$letter}"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="l/seg">
  <xsl:variable name="letter">
    <xsl:choose>
      <xsl:when test="../following-sibling::l">
        <xsl:choose>
          <xsl:when test="./following-sibling::seg">a</xsl:when>
          <xsl:otherwise>b</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="./following-sibling::seg">c</xsl:when>
          <xsl:otherwise>d</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <span class="{$letter}"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="p">
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- inserts page information etc !-->
<xsl:template match="pb">
  <span class="pageinfo"><xsl:text>[page </xsl:text><xsl:value-of select="@n"/><xsl:text>]</xsl:text></span>
</xsl:template>

<!-- italicize foreign-language inline text !-->
<xsl:template match="foreign">
<span class="foreign"><xsl:apply-templates /></span>
</xsl:template>

<!-- for pratīkas in the text, try to have them link to the base text !-->
<xsl:template match="ref[@type='pratīka']">
  <xsl:variable name="xmlid" select="@cRef"/>
  <!-- let's have links be specified explicitly, instead of putting comm in the filename !-->
  <!-- <xsl:variable name="filename" select="/TEI/@xml:id"/> !-->
  <!-- <xsl:variable name="linkedfile" select="concat(substring-before($filename,'comm'),'text-',substring-after($filename,'-'),'.html')"/> !-->
  <xsl:variable name="linkedfile" select="concat(/TEI/@corresp,'.html')"/>
  <a href="{$linkedfile}#{$xmlid}" target="_blank"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="ref[@cRef]">
  <xsl:variable name="xmlid" select="@cRef"/>
  <span class="citation"><a href="#{$xmlid}"><xsl:apply-templates/></a></span>
</xsl:template>

<xsl:template match="ref[@target]">
  <xsl:variable name="xmlid" select="@target"/>
  <a href="{$xmlid}"><xsl:apply-templates/></a>
</xsl:template>

<!-- for titles and names, bold face !-->
<xsl:template match="*[@rend='bold']">
  <b><xsl:apply-templates/></b>
</xsl:template>

<!-- format lists !-->
<xsl:template match="list">
  <xsl:choose>
  <xsl:when test="label">
    <ul class="labelled"><xsl:apply-templates/></ul>
  </xsl:when>
  <xsl:otherwise>
    <xsl:choose>
      <xsl:when test="@type='ordered'">
        <ol><xsl:apply-templates/></ol>
      </xsl:when>
      <xsl:otherwise>
        <ul><xsl:apply-templates/></ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="item">
<li>
  <xsl:if test="../label">
    <span class="label"><xsl:value-of select="preceding-sibling::label[1]"/></span><xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates/></li>
</xsl:template>
<xsl:template match="list/label"/>

<!-- format tables !-->
<xsl:template match="table">
<table><xsl:apply-templates/></table>
</xsl:template>
<xsl:template match="row">
<tr><xsl:apply-templates/></tr>
</xsl:template>
<xsl:template match="cell">
<td><xsl:apply-templates/></td>
</xsl:template>

<!-- apparatus:location-referenced (no lemmas) !-->
<xsl:template match="app">
  <xsl:variable name="appnum">
    <xsl:number level="any" from="lg | p | div" />
  </xsl:variable>
  <xsl:variable name="apparatus">
      <xsl:for-each select=".//rdg">
        <xsl:if test="@type='gloss'">
          <xsl:text> = </xsl:text>
        </xsl:if>
        <span class="foreign"><xsl:apply-templates /></span>
        <xsl:if test="note">
          <span class="appnote"><xsl:value-of select="./note"/></span>
        </xsl:if>
        <xsl:if test="@wit">
          <xsl:text> &lt;b&gt;</xsl:text><xsl:value-of select="translate(translate(@wit,' ',''),'#','')"/><xsl:text>&lt;/b&gt;</xsl:text>
        </xsl:if>
        <xsl:if test="@type='conj'">
          <xsl:text> conj. </xsl:text><xsl:value-of select="translate(translate(@resp,' ',''),'#','')"/>
        </xsl:if>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <a href="" class="app" title="{$apparatus}">
    <span class="appnum"><sup><xsl:copy-of select="$appnum"/></sup></span>
  </a> 
</xsl:template>

<xsl:template match="q">
  <xsl:choose>
    <xsl:when test="ancestor::app | ancestor::note[@place='app']">
      <xsl:text>&lt;b&gt;</xsl:text><xsl:apply-templates/><xsl:text>&lt;/b&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="note[@place='app']">
  <xsl:variable name="apparatus">
    <xsl:apply-templates/>
  </xsl:variable>
  <a href="" class="app" title="{$apparatus}">
    <xsl:text>*</xsl:text>
  </a>
</xsl:template>

<!-- some magic for app notes !-->
<xsl:template match="rdg/note"/>

</xsl:stylesheet>
