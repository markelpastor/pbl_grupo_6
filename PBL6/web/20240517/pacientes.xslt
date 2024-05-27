<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
			<html>
			<head>
                <title>GlaucoDtect_analysis</title>
                <link rel="stylesheet" type="text/css" href="xslt estilo.css"/>
            </head>
				<body>
				<h1>GlaucoDtect_analysis</h1>
					<table border="1">
						<tr>
							<th>Patient</th>
							<th>Hospital</th>
							<th>Doctor</th>
							<th>fecha_diagnóstico</th>
							<th>Glaucoma</th>
							<th>Calidad_imagen</th>
							<th>Resultados_imagenes</th>							
						</tr>
						<xsl:for-each select="GlaucoDtect_analysis/Patients/Patient">
							<tr>
								<td><xsl:value-of select="@id"/></td>
								<td><xsl:value-of select="Hospital"/></td>
								<td><xsl:value-of select="Doctor"/></td>
								<td><xsl:value-of select="fecha_diagnóstico"/></td>
								<td><xsl:value-of select="Glaucoma"/></td>
								<td><xsl:value-of select="Calidad_imagen"/></td>
								<td style="text-align:center; vertical-align:middle;">
									<img>
										<xsl:attribute name="src">
											<xsl:value-of select="Resultados_imagenes/@image"/>
										</xsl:attribute>
										<xsl:attribute name="style">
											<xsl:text>width:100px;height:auto;</xsl:text> 
										</xsl:attribute>
									</img>
								</td>
							</tr>
						</xsl:for-each>					
					</table>
				</body>
			</html>
	</xsl:template>
</xsl:stylesheet>