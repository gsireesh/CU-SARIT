<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions">
   <xsl:output method="html" encoding="utf-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd"
      doctype-public="-//W3C//DTD HTML 4.01//EN"></xsl:output>

<xsl:template match="/">
  <div><xsl:apply-templates/>  </div>
</xsl:template>

<xsl:template match="teiHeader"/>

<xsl:template match="body/p[@xml:id] | body/lg[@xml:id] | body/div[@xml:id]">
<a class="anchor" id="{@xml:id}"/>
<xsl:apply-templates/>
</xsl:template>

<!-- for verse !-->
<xsl:template match="lg">
  <xsl:variable name="type">
    <xsl:value-of select="@type"/>
  </xsl:variable>
  <xsl:if test="@xml:id"><a class="anchor" id="{@xml:id}"></a></xsl:if>
  <span>
    <xsl:apply-templates/>
  </span>
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
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- inserts page information etc !-->
<xsl:template match="pb">
  <xsl:variable name="pageno" select="concat('page',@n)"/>
  <a id="pg{$pageno}"/>
  <span class="floatright"><xsl:value-of select="@n"/></span>
</xsl:template>

<xsl:template match="milestone[@unit='metricalgroup']">
  <div class="metricalgroup"><xsl:text>***</xsl:text></div>
</xsl:template>

<!-- italicize foreign-language inline text !-->
<xsl:template match="foreign">
<span class="foreign"><xsl:apply-templates /></span>
</xsl:template>
<!-- for lemmas in commentaries, etc !-->
<xsl:template match="mentioned">
<span class="mentioned"><xsl:apply-templates/></span>
</xsl:template>

<!-- for pratīkas in the text, try to have them link to the base text !-->
<xsl:template match="ref[@type='pratīka']">
  <xsl:variable name="xmlid" select="@cRef"/>
  <!-- let's have links be specified explicitly, instead of putting comm in the filename !-->
  <!-- <xsl:variable name="filename" select="/TEI/@xml:id"/> !-->
  <!-- <xsl:variable name="linkedfile" select="concat(substring-before($filename,'comm'),'text-',substring-after($filename,'-'),'.html')"/> !-->
  <xsl:variable name="linkedfile" select="concat(/TEI/@corresp,'.html')"/>
  <a class="pratika" href="#{$xmlid}" rel="_NS"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="ref[@cRef]">
  <xsl:variable name="xmlid" select="@cRef"/>
  <span class="citation"><a href="#{$xmlid}" rel="_ext"><xsl:apply-templates/></a></span>
</xsl:template>

<!-- for titles and names, bold face !-->
<xsl:template match="title | name | persName">
  <span class="mentioned"><xsl:apply-templates/></span>
</xsl:template>

<!-- bold labels !-->
<xsl:template match="label">
<span class="label"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="emph">
<em><xsl:apply-templates /></em>
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
  <xsl:variable name="appnum2">
    <xsl:number level="any" from="body"/>
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
          <xsl:text> </xsl:text><span style="font-weight:800"><xsl:value-of select="translate(translate(@wit,' ',''),'#','')"/></span>
        </xsl:if>
        <xsl:if test="@type='conj'">
          <xsl:text> conj. </xsl:text><xsl:value-of select="translate(translate(@resp,' ',''),'#','')"/>
        </xsl:if>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <a href="#" class="app">*<div><xsl:copy-of select="$apparatus"/></div></a>
</xsl:template>

<xsl:template match="q">
  <xsl:choose>
    <xsl:when test="ancestor::app | ancestor::note[@place='app']">
      <xsl:text>&lt;b&gt;</xsl:text><xsl:apply-templates/><xsl:text>&lt;/b&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <b><xsl:apply-templates/></b>
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

<xsl:template match="head">
  <div class="header"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="trailer">
  <div class="trailer"><xsl:apply-templates/></div>
</xsl:template>

<!-- some magic for app notes !-->
<xsl:template match="rdg/note"/>

</xsl:stylesheet>
