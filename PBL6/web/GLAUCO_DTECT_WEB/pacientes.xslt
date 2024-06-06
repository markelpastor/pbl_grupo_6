<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>GLAUCO DTECT</title>
				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"/>
                <link rel="icon" href="images/logo empresa recortado.jpg" type="images/logo empresa recortado.jpg"/>
                <link rel="stylesheet" href="xslt estilo.css"/>
            </head>
            <body>
                <header>
                    <a href="#" class="logo">
                        <img src="images/VisionHealth.jpg" class="logo-img" alt="Vision Health Logo"></img>
                    </a>
                    <nav class="navbar">
                        <ul>
                            <li><a href="index.html" class="active"><b>Inicio</b></a></li>
                            <li><a href="index.html">Nosotros</a></li>
                            <li><a href="index.html">Productos</a></li>
                            <li><a href="index.html">Dónde encontrarnos</a></li>
                            <li><a href="index.html">Contácto</a></li>
                            <li><a href="index.html">Opiniones de usuarios</a></li>
                            <li><a href="index.html"><b>Cerrar Sesión</b></a></li>
                        </ul>
                    </nav>
                    <div class="fas fa-bars"></div>
                </header>
                <h1>GlaucoDtect_analysis</h1>
                
                <table border="1">
                    <tr>
                        <th>Paciente</th>
                        <th>Genero</th>
                        <th>Edad</th>
                        <th>Centro</th>
                        <th>Especialista</th>
                        <th>Comentarios</th>
                        <th>Fecha diagnóstico</th>
                        <th>Glaucoma</th>
                        <th>Resultados</th>
                        <th>Datos resultados</th>
                        <th>Tratamiento</th>
                        <th>Dosis</th>
                        <th>Historial médico familiar</th>
                    </tr>
                    <xsl:for-each select="GlaucoDtect_analysis/Pacientes/Paciente">
                        <tr>
                            <td><xsl:value-of select="@id"/></td>
                            <td><xsl:value-of select="Genero"/></td>
                            <td><xsl:value-of select="Edad"/></td>
                            <td><xsl:value-of select="Centro/@centro"/></td>
                            <td><xsl:value-of select="Centro/Especialista"/></td>
                            <td><xsl:value-of select="Centro/Comentarios_especialista"/></td>
                            <td><xsl:value-of select="Centro/fecha_diagnóstico"/></td>
                            <td><xsl:value-of select="Centro/Glaucoma"/></td>
                            <td style="text-align:center; vertical-align:middle;">
                                <img>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="Centro/Resultados_glaucoma/Imagen/@image"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="style">
                                        <xsl:text>width:100px;height:auto;</xsl:text>
                                    </xsl:attribute>
                                </img>
                            </td>
                            <td>
                                <xsl:for-each select="Centro/Resultados_glaucoma/Datos/*">
                                    <xsl:value-of select="local-name()"/>: <xsl:value-of select="."/><br/>
                                </xsl:for-each>
                            </td>
                            <td><xsl:value-of select="Centro/Tratamiento"/></td>
                            <td><xsl:value-of select="Centro/Dosis"/></td>
                            <td><xsl:value-of select="Centro/Historial_Médico_Familiar/Antecedentes"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
                <section class="footer" >
                    <div class="icons">
                        <a href="https://www.facebook.com/?locale=eu_ES" class="fab fa-facebook-f"></a>
                        <a href="https://x.com/home?lang=ES" class="fab fa-twitter"></a>
                        <a href="https://www.instagram.com/" class="fab fa-instagram"></a>
                        <a href="https://www.reddit.com/" class="fab fa-reddit"></a>
                    </div>
                </section>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
