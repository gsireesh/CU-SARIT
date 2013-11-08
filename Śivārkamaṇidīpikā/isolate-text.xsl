<xsl:transform version ="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" >

<xsl:template match="/">
  <xsl:apply-templates select="TEI/div"/>
</xsl:template>

<xsl:template match="TEI/div">
  <xsl:copy-of select="*"/>
</xsl:template>

</xsl:transform>
