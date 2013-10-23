<xsl:transform version ="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" >
<xsl:template match="node() | @*" >
<xsl:copy>
  <xsl:apply-templates select="@*|node()" />
</xsl:copy>
</xsl:template>

<xsl:template match="lg">
  <xsl:copy>
    <xsl:attribute name="xml:id" >
      <xsl:variable name="number" select="count(preceding-sibling::lg) + 1"/>
      <xsl:variable name="id" select="concat('NāŚā.12a.',$number)"/>
      <xsl:value-of select="$id" />
    </xsl:attribute>
  <xsl:apply-templates select ="@*|node()" />
  </xsl:copy>
</xsl:template>

</xsl:transform>
