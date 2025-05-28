import 'package:flutter/material.dart';
import 'package:abaez/theme/colors.dart';
import 'package:abaez/theme/theme.dart';
import 'package:abaez/theme/text_style.dart';

class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.bootcampTheme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryDarkBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          title: const Text('Acerca de'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con logo y título
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Logo con borde redondeado y sombra
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neutralGray.withAlpha(77),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/sodep-logo.jpeg',
                          height: 80,
                          errorBuilder: (context, error, stackTrace) => 
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Sodep S.A.',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black.withAlpha(77),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Nombre de la empresa con sombra
                    Text(
                      'SODEP S.A.',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryDarkBlue,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            color: AppColors.neutralGray.withAlpha(51),
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtítulo
                    Text(
                      'Software Developement & Products',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: AppColors.neutralGray.withAlpha(51)),

              // Sección Sobre la Empresa
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutralGray.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                       const Icon(Icons.business_outlined, 
                          color: AppColors.primaryDarkBlue, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Sobre la Empresa',
                          style: AppTextStyles.headingMd.copyWith(
                            color: AppColors.primaryDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: Text(
                        'Somos una empresa formada por profesionales en el área de TIC con amplia experiencia en diferentes lenguajes y la capacidad de adaptarnos a la herramienta que mejor sirva para solucionar el problema.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: AppColors.neutralGray.withAlpha(230),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sección Valores Sodepianos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.volunteer_activism, 
                          color: AppColors.primaryDarkBlue, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Valores Sodepianos',
                          style: AppTextStyles.headingMd.copyWith(
                            color: AppColors.primaryDarkBlue,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 1,
                                color: AppColors.neutralGray.withAlpha(51),
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Tarjetas de valores con colores de theme
                    _buildValorCardAsImage(
                      icon: Icons.shield_outlined,
                      title: 'Honestidad',
                      description: 'Actuamos con transparencia y verdad en todas nuestras relaciones',
                      bgColor: AppColors.primaryDarkBlue,
                      context: context,
                    ),
                    
                    _buildValorCardAsImage(
                      icon: Icons.diamond_outlined,
                      title: 'Calidad',
                      description: 'Nos esforzamos por la excelencia en cada proyecto y servicio',
                      bgColor: AppColors.primaryLightBlue,
                      context: context,
                    ),
                    
                    _buildValorCardAsImage(
                      icon: Icons.autorenew,
                      title: 'Flexibilidad',
                      description: 'Nos adaptamos a las necesidades cambiantes del mercado',
                      bgColor: AppColors.neutralGray,
                      context: context,
                    ),
                    
                    _buildValorCardAsImage(
                      icon: Icons.chat_bubble_outline,
                      title: 'Comunicación',
                      description: 'Mantenemos diálogo abierto y efectivo con todos nuestros stakeholders',
                      bgColor: AppColors.primaryLightBlue,
                      context: context,
                    ),
                    
                    _buildValorCardAsImage(
                      icon: Icons.psychology_outlined,
                      title: 'Autogestión',
                      description: 'Fomentamos la responsabilidad personal y la iniciativa propia',
                      bgColor: AppColors.primaryDarkBlue,
                      context: context,
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: AppColors.neutralGray.withAlpha(51)),

              // Sección Información de Contacto
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutralGray.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.contact_mail_outlined, 
                          color: AppColors.primaryDarkBlue, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Información de Contacto',
                          style: AppTextStyles.headingMd.copyWith(
                            color: AppColors.primaryDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Elementos de contacto en un contenedor con sombra
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neutralGray.withAlpha(26),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildContactItem(
                              icon: Icons.location_on_outlined,
                              title: 'Dirección',
                              content: 'Belgica 839 c/ Eusebio Lillo\nAsunción, Paraguay',
                              context: context,
                              color: AppColors.primaryDarkBlue,
                            ),
                            
                            _buildContactItem(
                              icon: Icons.phone_outlined,
                              title: 'Teléfono',
                              content: '(+595) 981-131-694',
                              context: context,
                              color: AppColors.primaryLightBlue,
                            ),
                            
                            _buildContactItem(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              content: 'info@sodep.com.py',
                              context: context,
                              color: AppColors.primaryDarkBlue,
                            ),
                            
                            _buildContactItem(
                              icon: Icons.language_outlined,
                              title: 'Sitio Web',
                              content: 'www.sodep.com.py',
                              context: context,
                              color: AppColors.primaryLightBlue,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Footer con copyright
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.neutralGray.withAlpha(51),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '© 2025 SODEP S.A. Todos los derechos reservados.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Tarjetas de valor con sombreado
  Widget _buildValorCardAsImage({
    required IconData icon,
    required String title,
    required String description,
    required Color bgColor,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: bgColor.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withAlpha(51),
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Elementos de contacto con color e indicador de último elemento
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required BuildContext context,
    required Color color,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}