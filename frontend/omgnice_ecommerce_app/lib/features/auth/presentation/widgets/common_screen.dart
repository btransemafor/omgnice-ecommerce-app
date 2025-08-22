import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
class CommonScreen extends StatelessWidget {
  String? title;
  String? subtitle;
  Widget middleWidget;
  CommonScreen(
      {Key? key, this.title, this.subtitle, required this.middleWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(
              padding: EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            backgroundColor: const Color(0xFF699D3C),
            expandedHeight: size.height * 0.25,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF699D3C),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with subtle shadow
                    Container(
                      child: Image.asset(
                        'assets/logo.png',
                        width: size.height * 0.20,
                        height: size.height * 0.20,
                      ),
                    ),
                    //const SizedBox(height: 5),
                    // Brand name with gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.green.shade200,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'OMGNICE',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: size.height * 0.67,
              color: Color(0xFF699D3C),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${title}",
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF699D3C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Subtitle with softer color
                      Text(
                        "$subtitle",
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.0355,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Sign Up Form
                      middleWidget,
                      // Login redirection with more engaging design
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
