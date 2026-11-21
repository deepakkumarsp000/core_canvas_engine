// FILE: example/lib/test7.dart
// PURPOSE: TEST 7 - Production Multi-Page Resume Suite
//   - Case 7.1: Template 28 Replica (Dark Sidebar + Golden Bulb & 3D Ribbons)
//   - Case 7.2: Template 1 Replica ("Charles Sanchez" Diamond Spine Timeline)
//   - Case 7.3: Cyber-Gold Chamfered Resume + MS Word Justified Layout

import 'test_registry.dart';

class Test7Cases {
  static const String _cat = "7. Production Resume Templates (Multi-Page)";

  static List<TestCase> getCases() {
    return [
      _case7_1(),
      _case7_2(),
      _case7_3(),
    ];
  }

  // ============================================================================
  // MASTER DUMMY DATA PAYLOAD (Shared across all Resume Templates)
  // ============================================================================
  static Map<String, dynamic> getDummyResumeData() {
    return {
      "personal_details": {
        "fullName": "Alex Carter",
        "email": "alex.carter@example.com",
        "phone": "+1 234 567 8900",
        "location": "San Francisco, CA, USA",
        "linkedin": "linkedin.com/in/alexcarter",
        "github": "github.com/alexcarter",
        "imagePath": "",
        "signaturePath": ""
      },
      "objective": {
        "text":
        "Highly driven Senior Software Engineer with 6+ years of experience in developing scalable mobile and web applications. Proven ability to lead cross-functional teams, optimize performance, and deliver high-quality software solutions using modern technologies."
      },
      "experience": {
        "list": [
          {
            "id": "exp_001",
            "jobTitle": "Senior Mobile Engineer",
            "company": "TechNova Solutions",
            "location": "San Francisco, CA",
            "startDate": "2021",
            "endDate": "Present",
            "description":
            "• Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.Spearheaded the development of a flagship fintech app using Flutter, reaching 500k+ active users.\n• Optimized rendering performance, reducing app load time by 30%.\n• Managed a team of 4 junior developers, implementing Agile methodologies and CI/CD pipelines."
          },
          {
            "id": "exp_002",
            "jobTitle": "Software Developer",
            "company": "Creative Code Labs",
            "location": "Austin, TX",
            "startDate": "2018",
            "endDate": "2021",
            "description":
            "• Built and maintained RESTful APIs using Node.js and PostgreSQL.\n• Collaborated with UI/UX designers to translate wireframes into interactive mobile screens.\n• Resolved 150+ critical bugs, improving overall crash-free rate to 99.8%."
          }
        ]
      },
      "education": {
        "list": [
          {
            "id": "edu_001",
            "degree": "B.S. in Computer Science",
            "school": "University of California, Berkeley",
            "startDate": "2014",
            "endDate": "2018",
            "grade": "3.8 GPA"
          }
        ]
      },
      "skills": {
        "list": [
          {"skill": "Mobile Development: Flutter, Dart, Swift", "rating": 5},
          {"skill": "Backend & Cloud: Firebase, Node.js, AWS", "rating": 4},
          {"skill": "Database Management: PostgreSQL, MongoDB", "rating": 4},
          {"skill": "Tools & Practices: Git, Docker, Agile/Scrum", "rating": 5}
        ]
      },
      "projects": {
        "list": [
          {
            "id": "proj_001",
            "title": "E-Commerce Mobile Store",
            "techStack": "Flutter, Firebase, Stripe API",
            "link": "github.com/alexcarter/ecommerce",
            "startDate": "2022",
            "endDate": "2023",
            "description":
            "A full-stack e-commerce application featuring real-time inventory tracking, secure payment gateways, and a dynamic admin dashboard."
          }
        ]
      },
      "certifications": {
        "list": [
          {
            "id": "cert_001",
            "title": "AWS Certified Solutions Architect",
            "issuer": "Amazon Web Services",
            "date": "2022",
            "link": "aws.amazon.com/verify"
          }
        ]
      },
      "achievements": {
        "list": [
          {
            "id": "ach_001",
            "title": "Employee of the Year",
            "issuer": "TechNova Solutions",
            "date": "2023",
            "description":
            "Awarded for exceptional leadership and delivering the flagship product 2 weeks ahead of schedule."
          }
        ]
      },
      "interests": {
        "list": [
          "Open Source Contributing",
          "Machine Learning",
          "Trekking & Photography"
        ]
      },
      "languages": {
        "list": [
          {"id": "lang_001", "name": "English", "proficiency": "Native"},
          {"id": "lang_002", "name": "Spanish", "proficiency": "Intermediate"}
        ]
      },
      "references": {
        "list": [
          {
            "id": "ref_001",
            "name": "Sarah Jenkins",
            "designation": "CTO",
            "company": "TechNova Solutions",
            "email": "sarah.j@technova.com",
            "phone": "+1 987 654 3210"
          }
        ]
      },
      "cover_letter": {
        "role": "Lead Mobile Developer",
        "company": "Innovate Inc.",
        "body":
        "Dear Hiring Manager,\n\nI am thrilled to apply for the Lead Mobile Developer position at Innovate Inc. With a strong background in cross-platform development and a passion for crafting seamless user experiences, I am confident in my ability to drive your mobile initiatives forward.\n\nThank you for your time and consideration."
      },
      "custom_demo_declaration_001": {
        "text":
        "I hereby declare that the information provided above is true and correct to the best of my knowledge."
      },
      "custom_demo_publications_002": {
        "list": [
          {
            "id": "pub_001",
            "title": "State Management in Flutter",
            "subtitle": "Medium Article",
            "date": "Oct 2022",
            "description":
            "A comprehensive guide analyzing Provider, Riverpod, and BLoC patterns for modern app architecture."
          }
        ]
      },
      "custom_sections_meta": {
        "sections": [
          {
            "id": "custom_demo_publications_002",
            "title": "PUBLICATIONS",
            "iconIndex": 0,
            "sectionType": "complex"
          },
          {
            "id": "custom_demo_declaration_001",
            "title": "DECLARATION",
            "iconIndex": 0,
            "sectionType": "simple"
          }
        ]
      },
      "active_sections_order": {
        "order": [
          "personal",
          "objective",
          "experience",
          "education",
          "skills",
          "projects",
          "custom_demo_publications_002",
          "certifications",
          "languages",
          "custom_demo_declaration_001"
        ]
      }
    };
  }

  // ============================================================================
  // TEMPLATE 28 PALETTE & ASSETS (For Case 7.1)
  // ============================================================================
  static const int _kDarkSidebar = 0xFF38393D;
  static const int _kGoldPrimary = 0xFFE2A83E;
  static const int _kGoldBright = 0xFFF59E0B;
  static const int _kGoldDarkFold = 0xFF9A6812;
  static const int _kTimelineLine = 0xFF8D7B68;
  static const int _kTextDark = 0xFF2D3139;
  static const int _kTextMuted = 0xFF525866;

  static const String _kLeftBulbClipPath =
      "M 0 13 C 24 13 40 0 64 0 C 80 0 92 11 92 25 C 92 39 80 50 64 50 C 40 50 24 37 0 37 Z";

  static const String _svgUserProfile =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5z'/></svg>";

  static const String _svgPhoneCall =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1-9.4 0-17-7.6-17-17 0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1L6.6 10.8z'/></svg>";

  static const String _svgSkillsTrophy =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M19 5h-2V3H7v2H5c-1.1 0-2 .9-2 2v1c0 2.55 1.92 4.63 4.39 4.94.63 1.5 1.98 2.63 3.61 2.96V19H7v2h10v-2h-4v-3.1c1.63-.33 2.98-1.46 3.61-2.96C19.08 12.63 21 10.55 21 8V7c0-1.1-.9-2-2-2zM5 8V7h2v3.82C5.84 10.4 5 9.3 5 8zm14 0c0 1.3-.84 2.4-2 2.82V7h2v1z'/></svg>";

  static const String _svgBriefcaseExp =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M20 6h-4V4c0-1.1-.9-2-2-2h-4c-1.1 0-2 .9-2 2v2H4c-1.1 0-2 .9-2 2v11c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-6 0h-4V4h4v2z'/></svg>";

  static const String _svgGraduationCap =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72L12 15l5-2.73v3.72z'/></svg>";

  static const String _svgProjectsCode =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z'/></svg>";

  static const String _svgPublicationDoc =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z'/></svg>";

  static const String _svgGlobeLang =
      "<svg viewBox='0 0 24 24'><path fill='#FFFFFF' d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z'/></svg>";

  static const String _svgPinGold =
      "<svg viewBox='0 0 24 24'><path fill='#F59E0B' d='M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z'/></svg>";

  static const String _svgPhoneGold =
      "<svg viewBox='0 0 24 24'><path fill='#F59E0B' d='M20 15.5c-1.2 0-2.4-.2-3.6-.6-.3-.1-.7 0-1 .2l-2.2 2.2c-2.8-1.4-5.1-3.8-6.6-6.6l2.2-2.2c.3-.3.4-.7.2-1-.3-1.1-.5-2.3-.5-3.5 0-.6-.4-1-1-1H4c-.6 0-1 .4-1 1 0 9.4 7.6 17 17 17 .6 0 1-.4 1-1v-3.5c0-.6-.4-1-1-1z'/></svg>";

  static const String _svgWebGold =
      "<svg viewBox='0 0 24 24'><path fill='#F59E0B' d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm6.93 6h-2.95c-.32-1.25-.78-2.45-1.38-3.56 1.84.63 3.37 1.91 4.33 3.56zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56-1.84-.63-3.37-1.9-4.33-3.56zm2.95-8H5.07c.96-1.66 2.49-2.93 4.33-3.56C8.8 5.55 8.34 6.75 8.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95c-.96 1.65-2.49 2.93-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z'/></svg>";

  // ============================================================================
  // TEMPLATE 28 HELPERS (Case 7.1)
  // ============================================================================
  static CanvasBox _buildLeftSectionHeader(String title, String iconSvg) {
    return CanvasBox(
      widthPct: 100,
      height: 52,
      margin: EdgeInsets.only(top: 14.0, bottom: 10.0),
      direction: FlexDir.row,
      alignItems: FlexAlign.center,
      children: [
        CanvasBox(
          width: 92,
          height: 50,
          padding: EdgeInsets.only(left: 34.0),
          justifyContent: FlexJustify.center,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(
            gradient: const [0xFFEAB354, 0xFFD99A2B],
            isClip: true,
            clipSvgPath: _kLeftBulbClipPath,
            shadow: CanvasShadow(
              color: 0x77000000,
              offsetX: 2.0,
              offsetY: 4.0,
              blurRadius: 8.0,
            ),
          ),
          children: [
            CanvasSvg(svgXml: iconSvg, width: 26, height: 26),
          ],
        ),
        CanvasBox(
          margin: EdgeInsets.only(left: 12.0),
          direction: FlexDir.column,
          alignItems: FlexAlign.flexStart,
          children: [
            CanvasText(
              title,
              color: 0xFFFFFFFF,
              fontSize: 15.0,
              weight: 800,
              letterSpacing: 1.0,
            ),
            CanvasBox(
              width: 56,
              height: 3.0,
              margin: EdgeInsets.only(top: 4.0),
              decoration: CanvasDecoration(
                backgroundColor: _kGoldBright,
                borderRadius: EdgeInsets.all(1.5),
              ),
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildContactItem(
      String iconSvg,
      String label,
      String value,
      ) {
    return CanvasBox(
      widthPct: 100,
      padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 5.0),
      direction: FlexDir.row,
      alignItems: FlexAlign.flexStart,
      gap: 10.0,
      children: [
        CanvasBox(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(top: 2.0),
          children: [CanvasSvg(svgXml: iconSvg, width: 18, height: 18)],
        ),
        CanvasBox(
          width: 142,
          direction: FlexDir.column,
          children: [
            CanvasText(label, color: 0xFFFFFFFF, fontSize: 11.0, weight: 700),
            CanvasText(
              value,
              color: 0xFFD1D5DB,
              fontSize: 10.0,
              lineHeight: 1.3,
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildSkillBar(String rawSkill, int rating) {
    final parts = rawSkill.split(':');
    final String mainSkill = parts.first.trim();
    final String subSkills =
    parts.length > 1 ? parts.sublist(1).join(':').trim() : '';
    final double pct = (rating.clamp(1, 5) / 5.0) * 156.0;

    return CanvasBox(
      widthPct: 100,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
      direction: FlexDir.column,
      alignItems: FlexAlign.center,
      children: [
        CanvasText(
          mainSkill,
          color: 0xFFFFFFFF,
          fontSize: 11.5,
          weight: 700,
          align: TextAlign.center,
        ),
        if (subSkills.isNotEmpty)
          CanvasText(
            subSkills,
            color: 0xFF9CA3AF,
            fontSize: 9.5,
            align: TextAlign.center,
          ),
        CanvasBox(
          width: 156,
          height: 9,
          margin: EdgeInsets.only(top: 5.0),
          decoration: CanvasDecoration(
            backgroundColor: 0xFF26272B,
            borderRadius: EdgeInsets.all(2.0),
          ),
          children: [
            CanvasBox(
              width: pct,
              height: 9,
              decoration: CanvasDecoration(
                gradient: const [0xFFF59E0B, 0xFFE2A83E],
                borderRadius: EdgeInsets.all(2.0),
              ),
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildRightRibbonHeader(String title, String iconSvg) {
    return CanvasBox(
      width: 356,
      height: 60,
      margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
      children: [
        CanvasBox(
          width: 16,
          height: 14,
          posType: PosType.absolute,
          left: -16,
          bottom: 0,
          decoration: CanvasDecoration(
            backgroundColor: _kGoldDarkFold,
            isClip: true,
            clipSvgPath: "M 0 0 L 16 0 L 16 14 Z",
          ),
        ),
        CanvasBox(
          width: 348,
          height: 46,
          posType: PosType.absolute,
          left: -16,
          top: 0,
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          direction: FlexDir.row,
          alignItems: FlexAlign.center,
          gap: 14.0,
          decoration: CanvasDecoration(
            gradient: const [0xFFE7B24D, 0xFFD89B28],
            borderRadius: EdgeInsets.only(
              top: 6.0,
              right: 6.0,
              bottom: 6.0,
              left: 0.0,
            ),
            shadow: CanvasShadow(
              color: 0x44000000,
              offsetX: 0.0,
              offsetY: 4.0,
              blurRadius: 8.0,
            ),
          ),
          children: [
            CanvasSvg(svgXml: iconSvg, width: 28, height: 28),
            CanvasText(
              title.toUpperCase(),
              color: 0xFFFFFFFF,
              fontSize: 18.0,
              weight: 800,
              letterSpacing: 1.2,
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildTimelineNode({
    required String title,
    required String subtitle,
    required String dateRange,
    required String description,
    String? badgeLink,
    bool isLast = false,
  }) {
    final String headingLine = dateRange.isNotEmpty
        ? "${title.toUpperCase()}  |  $dateRange"
        : title.toUpperCase();

    return CanvasBox(
      width: 340,
      margin: EdgeInsets.only(left: 16.0),
      direction: FlexDir.row,
      alignItems: FlexAlign.stretch,
      children: [
        CanvasBox(
          width: 24,
          alignItems: FlexAlign.center,
          children: [
            CanvasBox(
              width: 1.8,
              heightPct: isLast ? 30 : 100,
              posType: PosType.absolute,
              top: 0,
              left: 11,
              decoration: CanvasDecoration(backgroundColor: _kTimelineLine),
            ),
            CanvasBox(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(top: 4.0),
              decoration: CanvasDecoration(
                backgroundColor: _kGoldPrimary,
                shape: BoxShape.circle,
                borderColor: _kTimelineLine,
                borderWidth: EdgeInsets.all(2.0),
              ),
            ),
          ],
        ),
        CanvasBox(
          width: 308,
          padding: EdgeInsets.only(left: 10.0, bottom: 16.0),
          direction: FlexDir.column,
          alignItems: FlexAlign.flexStart,
          gap: 3.0,
          children: [
            CanvasText(
              headingLine,
              color: _kTextDark,
              fontSize: 11.5,
              weight: 800,
            ),
            if (subtitle.isNotEmpty)
              CanvasText(
                subtitle,
                color: _kGoldDarkFold,
                fontSize: 10.5,
                weight: 700,
              ),
            if (badgeLink != null && badgeLink.isNotEmpty)
              CanvasText(
                badgeLink,
                color: 0xFF0284C7,
                fontSize: 9.5,
                weight: 600,
              ),
            if (description.isNotEmpty)
              CanvasText(
                description,
                color: _kTextMuted,
                fontSize: 10.2,
                lineHeight: 1.38,
              ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildAwardGridCard({
    required String badgeNum,
    required String title,
    required String issuerAndDate,
    required String description,
  }) {
    return CanvasBox(
      width: 166,
      padding: EdgeInsets.all(6.0),
      direction: FlexDir.row,
      alignItems: FlexAlign.flexStart,
      gap: 8.0,
      children: [
        CanvasBox(
          width: 18,
          height: 18,
          margin: EdgeInsets.only(top: 1.0),
          justifyContent: FlexJustify.center,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(
            backgroundColor: _kDarkSidebar,
            shape: BoxShape.circle,
            borderColor: _kGoldPrimary,
            borderWidth: EdgeInsets.all(1.5),
          ),
          children: [
            CanvasText(badgeNum, color: _kGoldPrimary, fontSize: 8.5, weight: 800),
          ],
        ),
        CanvasBox(
          width: 132,
          direction: FlexDir.column,
          gap: 2.0,
          children: [
            CanvasText(
              title.toUpperCase(),
              color: _kTextDark,
              fontSize: 10.0,
              weight: 800,
            ),
            CanvasText(
              issuerAndDate,
              color: _kGoldDarkFold,
              fontSize: 9.5,
              weight: 700,
            ),
            CanvasText(
              description,
              color: _kTextMuted,
              fontSize: 9.2,
              lineHeight: 1.3,
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  // ============================================================================
  // CASE 7.1: TEMPLATE 28 MULTI-PAGE EXECUTIVE RESUME
  // ============================================================================
  static TestCase _case7_1() {
    final data = getDummyResumeData();
    final personal = data['personal_details'] as Map<String, dynamic>;
    final objective = (data['objective'] as Map<String, dynamic>)['text'] as String;
    final expList = (data['experience'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final eduList = (data['education'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final skillsList = (data['skills'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final projList = (data['projects'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final certList = (data['certifications'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final achList = (data['achievements'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final interestsList = (data['interests'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final langList = (data['languages'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final refList = (data['references'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final coverLetter = data['cover_letter'] as Map<String, dynamic>;
    final pubList =
    (data['custom_demo_publications_002'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final declarationText =
    (data['custom_demo_declaration_001'] as Map<String, dynamic>)['text'] as String;

    final firstExp = expList.isNotEmpty ? expList.first as Map<String, dynamic> : {};
    final roleTitle = (firstExp['jobTitle'] ?? 'Senior Software Engineer').toString();

    return TestCase(
      "7.1 Template 28 Executive Resume (Multi-Page)",
      CanvasDocument(
        title: "${personal['fullName']} - Executive Resume",
        author: personal['fullName'].toString(),
        format: CanvasFormat.a4,
        pageMode: PdfPageMode.useOutlines,
        body: CanvasBox(
          width: 595,
          height: 1684,
          direction: FlexDir.row,
          alignItems: FlexAlign.stretch,
          decoration: CanvasDecoration(backgroundColor: 0xFFFFFFFF),
          children: [
            CanvasBox(
              width: 210,
              height: 1684,
              direction: FlexDir.column,
              alignItems: FlexAlign.center,
              decoration: CanvasDecoration(backgroundColor: _kDarkSidebar),
              children: [
                CanvasBox(
                  width: 210,
                  height: 205,
                  children: [
                    CanvasBox(
                      width: 210,
                      height: 205,
                      posType: PosType.absolute,
                      top: 0,
                      left: 0,
                      decoration: CanvasDecoration(
                        gradient: const [0xFFF59E0B, 0xFFE2A83E],
                        isClip: true,
                        clipSvgPath: "M 0 5 L 210 205 L 0 205 Z",
                      ),
                    ),
                    CanvasBox(
                      width: 144,
                      height: 144,
                      posType: PosType.absolute,
                      top: 26,
                      left: 33,
                      justifyContent: FlexJustify.center,
                      alignItems: FlexAlign.center,
                      decoration: CanvasDecoration(
                        backgroundColor: 0xFFD97706,
                        shape: BoxShape.circle,
                        isClip: true,
                        borderColor: 0xFFFFFFFF,
                        borderWidth: EdgeInsets.all(4.0),
                        shadow: CanvasShadow(
                          color: 0x88000000,
                          offsetX: 0.0,
                          offsetY: 8.0,
                          blurRadius: 16.0,
                        ),
                      ),
                      children: [
                        CanvasImage(
                          base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                          width: 144,
                          height: 144,
                          fit: ImageFit.cover,
                        ),
                      ],
                    ),
                  ],
                ),
                CanvasBox(
                  widthPct: 100,
                  padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.center,
                  gap: 4.0,
                  children: [
                    CanvasText(
                      personal['fullName'].toString(),
                      fontFamily: 'Times',
                      color: 0xFFFFFFFF,
                      fontSize: 22.0,
                      weight: 700,
                      align: TextAlign.center,
                    ),
                    CanvasText(
                      roleTitle,
                      color: 0xFFE5E7EB,
                      fontSize: 11.5,
                      align: TextAlign.center,
                    ),
                  ],
                ),
                _buildLeftSectionHeader("PROFILE", _svgUserProfile),
                CanvasBox(
                  widthPct: 100,
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 4.0),
                  children: [
                    CanvasText(
                      objective,
                      color: 0xFFE5E7EB,
                      fontSize: 10.0,
                      lineHeight: 1.42,
                    ),
                  ],
                ),
                _buildLeftSectionHeader("CONTACT", _svgPhoneCall),
                _buildContactItem(_svgPhoneGold, "Phone", personal['phone'].toString()),
                _buildContactItem(
                  _svgWebGold,
                  "Web & Portfolio",
                  "${personal['email']}\n${personal['linkedin']}\n${personal['github']}",
                ),
                _buildContactItem(_svgPinGold, "Address", personal['location'].toString()),
                _buildLeftSectionHeader("SKILLS", _svgSkillsTrophy),
                ...skillsList.map((s) {
                  final map = s as Map<String, dynamic>;
                  return _buildSkillBar(
                    map['skill'].toString(),
                    (map['rating'] as num?)?.toInt() ?? 4,
                  );
                }),
                _buildLeftSectionHeader("LANGUAGES", _svgGlobeLang),
                ...langList.map((l) {
                  final map = l as Map<String, dynamic>;
                  final int score = map['proficiency'] == 'Native' ? 5 : 3;
                  return _buildSkillBar(
                    "${map['name']} (${map['proficiency']})",
                    score,
                  );
                }),
                _buildLeftSectionHeader("INTERESTS", _svgSkillsTrophy),
                CanvasBox(
                  widthPct: 100,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  direction: FlexDir.column,
                  gap: 8.0,
                  children: interestsList.map((interest) {
                    return CanvasBox(
                      direction: FlexDir.row,
                      alignItems: FlexAlign.center,
                      gap: 8.0,
                      children: [
                        CanvasBox(
                          width: 7,
                          height: 7,
                          decoration: CanvasDecoration(
                            backgroundColor: _kGoldBright,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CanvasText(
                          interest.toString(),
                          color: 0xFFE5E7EB,
                          fontSize: 10.5,
                          weight: 600,
                        ),
                      ],
                    );
                  }).toList(),
                ).avoidPageBreakInside(),
                _buildLeftSectionHeader("REFERENCE", _svgUserProfile),
                ...refList.map((r) {
                  final map = r as Map<String, dynamic>;
                  return CanvasBox(
                    widthPct: 100,
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                    direction: FlexDir.column,
                    gap: 3.0,
                    children: [
                      CanvasText(
                        map['name'].toString(),
                        color: 0xFFFFFFFF,
                        fontSize: 12.0,
                        weight: 800,
                      ),
                      CanvasText(
                        "${map['designation']} — ${map['company']}",
                        color: _kGoldBright,
                        fontSize: 10.5,
                        weight: 700,
                      ),
                      CanvasText(
                        "${map['email']}\n${map['phone']}",
                        color: 0xFFD1D5DB,
                        fontSize: 9.8,
                        lineHeight: 1.35,
                      ),
                    ],
                  ).avoidPageBreakInside();
                }),
              ],
            ),
            CanvasBox(
              width: 385,
              padding: EdgeInsets.only(top: 14.0, right: 20.0, bottom: 20.0),
              direction: FlexDir.column,
              alignItems: FlexAlign.flexStart,
              children: [
                _buildRightRibbonHeader("EXPERIENCE", _svgBriefcaseExp)
                    .meta(bookmark: "1. Experience"),
                ...List.generate(expList.length, (i) {
                  final item = expList[i] as Map<String, dynamic>;
                  return _buildTimelineNode(
                    title: "${item['jobTitle']} — ${item['company']}",
                    subtitle: item['location'].toString(),
                    dateRange: "${item['startDate']} - ${item['endDate']}",
                    description: item['description'].toString(),
                    isLast: i == expList.length - 1,
                  );
                }),
                _buildRightRibbonHeader("EDUCATION", _svgGraduationCap)
                    .meta(bookmark: "2. Education"),
                ...List.generate(eduList.length, (i) {
                  final item = eduList[i] as Map<String, dynamic>;
                  return _buildTimelineNode(
                    title: item['degree'].toString(),
                    subtitle: item['school'].toString(),
                    dateRange: "${item['startDate']} - ${item['endDate']}",
                    description: "Academic Standing: ${item['grade']}",
                    isLast: i == eduList.length - 1,
                  );
                }),
                _buildRightRibbonHeader("PROJECTS", _svgProjectsCode)
                    .meta(bookmark: "3. Key Projects"),
                ...List.generate(projList.length, (i) {
                  final item = projList[i] as Map<String, dynamic>;
                  return _buildTimelineNode(
                    title: item['title'].toString(),
                    subtitle: "Tech Stack: ${item['techStack']}",
                    dateRange: "${item['startDate']} - ${item['endDate']}",
                    badgeLink: item['link'].toString(),
                    description: item['description'].toString(),
                    isLast: i == projList.length - 1,
                  );
                }),
                _buildRightRibbonHeader("AWARD & CERTS", _svgSkillsTrophy)
                    .meta(bookmark: "4. Awards & Certifications"),
                CanvasBox(
                  width: 348,
                  margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                  direction: FlexDir.row,
                  justifyContent: FlexJustify.spaceBetween,
                  children: [
                    if (achList.isNotEmpty)
                      _buildAwardGridCard(
                        badgeNum: "01",
                        title: (achList.first as Map)['title'].toString(),
                        issuerAndDate:
                        "${(achList.first as Map)['issuer']} (${(achList.first as Map)['date']})",
                        description: (achList.first as Map)['description'].toString(),
                      ),
                    if (certList.isNotEmpty)
                      _buildAwardGridCard(
                        badgeNum: "02",
                        title: (certList.first as Map)['title'].toString(),
                        issuerAndDate:
                        "${(certList.first as Map)['issuer']} (${(certList.first as Map)['date']})",
                        description: "Verified Credential: ${(certList.first as Map)['link']}",
                      ),
                  ],
                ).avoidPageBreakInside(),
                _buildRightRibbonHeader("PUBLICATIONS", _svgPublicationDoc)
                    .meta(bookmark: "5. Publications"),
                ...List.generate(pubList.length, (i) {
                  final item = pubList[i] as Map<String, dynamic>;
                  return _buildTimelineNode(
                    title: item['title'].toString(),
                    subtitle: item['subtitle'].toString(),
                    dateRange: item['date'].toString(),
                    description: item['description'].toString(),
                    isLast: i == pubList.length - 1,
                  );
                }),
                _buildRightRibbonHeader("COVER LETTER", _svgBriefcaseExp)
                    .meta(bookmark: "6. Cover Letter"),
                CanvasBox(
                  width: 340,
                  margin: EdgeInsets.only(left: 16.0, bottom: 14.0),
                  padding: EdgeInsets.all(14.0),
                  direction: FlexDir.column,
                  gap: 6.0,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFFBF9F5,
                    borderColor: _kGoldPrimary,
                    borderWidth: EdgeInsets.only(
                      left: 3.5,
                      top: 0.8,
                      right: 0.8,
                      bottom: 0.8,
                    ),
                    borderRadius: EdgeInsets.all(8.0),
                  ),
                  children: [
                    CanvasText(
                      "ROLE: ${coverLetter['role']}  •  ${coverLetter['company']}",
                      color: _kTextDark,
                      fontSize: 11.0,
                      weight: 800,
                    ),
                    CanvasText(
                      coverLetter['body'].toString(),
                      color: _kTextMuted,
                      fontSize: 10.2,
                      lineHeight: 1.42,
                    ),
                  ],
                ).avoidPageBreakInside(),
                _buildRightRibbonHeader("DECLARATION", _svgPublicationDoc)
                    .meta(bookmark: "7. Declaration"),
                CanvasBox(
                  width: 340,
                  margin: EdgeInsets.only(left: 16.0),
                  padding: EdgeInsets.all(14.0),
                  direction: FlexDir.column,
                  gap: 16.0,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFF8FAFC,
                    borderRadius: EdgeInsets.all(8.0),
                    borderColor: 0xFFE2E8F0,
                    borderWidth: EdgeInsets.all(1.0),
                  ),
                  children: [
                    CanvasText(
                      declarationText,
                      color: _kTextMuted,
                      fontSize: 10.2,
                      fontStyle: FontStyle.italic,
                      lineHeight: 1.4,
                    ),
                    CanvasBox(
                      widthPct: 100,
                      direction: FlexDir.row,
                      justifyContent: FlexJustify.spaceBetween,
                      alignItems: FlexAlign.flexEnd,
                      children: [
                        CanvasBox(
                          direction: FlexDir.column,
                          gap: 2.0,
                          children: [
                            CanvasText(
                              "Place: ${personal['location']}",
                              color: _kTextDark,
                              fontSize: 10.0,
                              weight: 700,
                            ),
                            CanvasText(
                              "Date: October 2026",
                              color: _kTextMuted,
                              fontSize: 9.5,
                            ),
                          ],
                        ),
                        CanvasBox(
                          direction: FlexDir.column,
                          alignItems: FlexAlign.center,
                          gap: 3.0,
                          children: [
                            CanvasText(
                              personal['fullName'].toString(),
                              fontFamily: 'Times',
                              fontStyle: FontStyle.italic,
                              color: _kGoldDarkFold,
                              fontSize: 15.0,
                              weight: 700,
                            ),
                            CanvasBox(
                              width: 110,
                              height: 1.5,
                              decoration: CanvasDecoration(backgroundColor: _kTextDark),
                            ),
                            CanvasText(
                              "AUTHORIZED SIGNATURE",
                              color: _kTextMuted,
                              fontSize: 8.5,
                              weight: 700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).avoidPageBreakInside(),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
      needsImageFile: true,
    );
  }

  // ============================================================================
  // TEMPLATE 2 ("Charles Sanchez" Diamond Spine Style - 1.jpg Exact Replica)
  // ============================================================================
  static const int _kSlateNavy = 0xFF333C4D;
  static const int _kSpineGrey = 0xFFD1D5DB;
  static const int _kHeadingBlack = 0xFF1F2937;
  static const int _kBodyCharcoal = 0xFF374151;
  static const int _kSubItalicGrey = 0xFF4B5563;

  static String _buildDiamondBadgeSvg(String innerIconPathD) {
    return "<svg viewBox='0 0 36 36'>"
        "<path fill='#333C4D' d='M18 0 L36 18 L18 36 L0 18 Z'/>"
        "<path fill='#FFFFFF' d='M18 3.2 L32.8 18 L18 32.8 L3.2 18 Z'/>"
        "<path fill='#333C4D' d='M18 4.6 L31.4 18 L18 31.4 L4.6 18 Z'/>"
        "<path fill='#FFFFFF' d='$innerIconPathD'/>"
        "</svg>";
  }

  static const String _svgSmallDiamondBullet =
      "<svg viewBox='0 0 12 12'><path fill='#333C4D' d='M6 0 L12 6 L6 12 L0 6 Z'/></svg>";

  static const String _dPathBriefcase =
      "M23 14h-2.5v-1.5c0-.8-.7-1.5-1.5-1.5h-2c-.8 0-1.5.7-1.5 1.5V14H13c-.8 0-1.5.7-1.5 1.5v7c0 .8.7 1.5 1.5 1.5h10c.8 0 1.5-.7 1.5-1.5v-7c0-.8-.7-1.5-1.5-1.5zm-6-1.5h2V14h-2v-1.5z";
  static const String _dPathSkillsPuzzle =
      "M19.5 11c-.8 0-1.5.7-1.5 1.5V14h-4v4h-1.5c-.8 0-1.5.7-1.5 1.5s.7 1.5 1.5 1.5H14v4h4v-1.5c0-.8.7-1.5 1.5-1.5s1.5.7 1.5 1.5V24h3v-4h1.5c.8 0 1.5-.7 1.5-1.5S26.3 17 25.5 17H24v-3h-3v-1.5c0-.8-.7-1.5-1.5-1.5z";
  static const String _dPathGraduation =
      "M18 11l-8 4.4 8 4.4 6.5-3.6v5.1h1.5v-5.9L18 11zm-5 6.3v3.3l5 2.7 5-2.7v-3.3l-5 2.7-5-2.7z";
  static const String _dPathCode =
      "M15.5 21.5L12 18l3.5-3.5-1-1L10 18l4.5 4.5 1-1zm5 0L24 18l-3.5-3.5 1-1L26 18l-4.5 4.5-1-1z";
  static const String _dPathTrophy =
      "M23 12h-1.5v-1h-7v1H13c-.8 0-1.5.7-1.5 1.5v.8c0 1.9 1.4 3.5 3.3 3.7.5 1.1 1.5 2 2.7 2.2V22H15v1.5h6V22h-2.5v-1.8c1.2-.2 2.2-1.1 2.7-2.2 1.9-.2 3.3-1.8 3.3-3.7v-.8c0-.8-.7-1.5-1.5-1.5z";
  static const String _dPathDocument =
      "M20 11h-6c-.8 0-1.5.7-1.5 1.5v11c0 .8.7 1.5 1.5 1.5h8c.8 0 1.5-.7 1.5-1.5V15l-3.5-4zm1.5 11.5h-7v-1.2h7v1.2zm0-2.8h-7v-1.2h7v1.2zm-2-3.7v-3.5l3.5 3.5h-3.5z";

  static CanvasBox _buildDiamondSectionHeader(
      String title,
      String innerIconPathD, {
        bool connectTopLine = true,
      }) {
    return CanvasBox(
      width: 523,
      height: 46,
      direction: FlexDir.row,
      alignItems: FlexAlign.center,
      children: [
        CanvasBox(
          width: 36,
          height: 46,
          alignItems: FlexAlign.center,
          justifyContent: FlexJustify.center,
          children: [
            CanvasBox(
              width: 1.5,
              height: connectTopLine ? 46 : 23,
              posType: PosType.absolute,
              top: connectTopLine ? 0 : 23,
              left: 17.25,
              decoration: CanvasDecoration(backgroundColor: _kSpineGrey),
            ),
            CanvasSvg(
              svgXml: _buildDiamondBadgeSvg(innerIconPathD),
              width: 36,
              height: 36,
            ),
          ],
        ),
        CanvasBox(
          padding: EdgeInsets.only(left: 12.0),
          children: [
            CanvasText(
              title,
              color: _kHeadingBlack,
              fontSize: 16.0,
              weight: 800,
            ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildDiamondTimelineEntry({
    required String dateText,
    required String title,
    String? italicSubtitle,
    String? bodyText,
    List<String>? bulletLines,
    bool drawBottomLine = true,
  }) {
    return CanvasBox(
      width: 523,
      direction: FlexDir.row,
      alignItems: FlexAlign.stretch,
      children: [
        CanvasBox(
          width: 36,
          alignItems: FlexAlign.center,
          children: [
            CanvasBox(
              width: 1.5,
              heightPct: drawBottomLine ? 100 : 18,
              posType: PosType.absolute,
              top: 0,
              left: 17.25,
              decoration: CanvasDecoration(backgroundColor: _kSpineGrey),
            ),
            CanvasBox(
              width: 11,
              height: 11,
              margin: EdgeInsets.only(top: 4.0),
              children: [
                CanvasSvg(svgXml: _svgSmallDiamondBullet, width: 11, height: 11),
              ],
            ),
          ],
        ),
        CanvasBox(
          width: 82,
          padding: EdgeInsets.only(left: 12.0, top: 2.0, bottom: 14.0),
          children: [
            CanvasText(
              dateText,
              color: _kHeadingBlack,
              fontSize: 10.0,
              weight: 700,
              lineHeight: 1.35,
            ),
          ],
        ),
        CanvasBox(
          width: 405,
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          direction: FlexDir.column,
          alignItems: FlexAlign.flexStart,
          gap: 3.0,
          children: [
            if (title.isNotEmpty)
              CanvasText(
                title,
                color: _kHeadingBlack,
                fontSize: 12.5,
                weight: 800,
              ),
            if (italicSubtitle != null && italicSubtitle.isNotEmpty)
              CanvasText(
                italicSubtitle,
                color: _kSubItalicGrey,
                fontSize: 10.5,
                fontStyle: FontStyle.italic,
              ),
            if (bodyText != null && bodyText.isNotEmpty)
              CanvasBox(
                margin: EdgeInsets.only(top: 3.0),
                children: [
                  CanvasText(
                    bodyText,
                    color: _kBodyCharcoal,
                    fontSize: 10.2,
                    lineHeight: 1.42,
                  ),
                ],
              ),
            if (bulletLines != null && bulletLines.isNotEmpty)
              CanvasBox(
                margin: EdgeInsets.only(top: 4.0, left: 6.0),
                direction: FlexDir.column,
                gap: 3.5,
                children: bulletLines.map((b) {
                  final String cleanLine =
                  b.trim().startsWith('•') ? b.trim() : "•  ${b.trim()}";
                  return CanvasText(
                    cleanLine,
                    color: _kBodyCharcoal,
                    fontSize: 10.2,
                    lineHeight: 1.38,
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    ).avoidPageBreakInside();
  }

  static CanvasBox _buildDiamondBulletListBlock(
      List<String> items, {
        bool drawBottomLine = true,
      }) {
    return CanvasBox(
      width: 523,
      direction: FlexDir.row,
      alignItems: FlexAlign.stretch,
      children: [
        CanvasBox(
          width: 36,
          alignItems: FlexAlign.center,
          children: [
            CanvasBox(
              width: 1.5,
              heightPct: drawBottomLine ? 100 : 25,
              posType: PosType.absolute,
              top: 0,
              left: 17.25,
              decoration: CanvasDecoration(backgroundColor: _kSpineGrey),
            ),
            CanvasBox(
              width: 11,
              height: 11,
              margin: EdgeInsets.only(top: 4.0),
              children: [
                CanvasSvg(svgXml: _svgSmallDiamondBullet, width: 11, height: 11),
              ],
            ),
          ],
        ),
        CanvasBox(
          width: 487,
          padding: EdgeInsets.only(left: 20.0, top: 1.0, bottom: 16.0),
          direction: FlexDir.column,
          gap: 4.0,
          children: items.map((line) {
            return CanvasText(
              "•   $line",
              color: _kBodyCharcoal,
              fontSize: 10.4,
              lineHeight: 1.38,
            );
          }).toList(),
        ),
      ],
    ).avoidPageBreakInside();
  }

  // ============================================================================
  // CASE 7.2: "CHARLES SANCHEZ" DIAMOND TIMELINE RESUME (1.jpg Replica)
  // ============================================================================
  static TestCase _case7_2() {
    final data = getDummyResumeData();
    final personal = data['personal_details'] as Map<String, dynamic>;
    final objective = (data['objective'] as Map<String, dynamic>)['text'] as String;
    final expList = (data['experience'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final eduList = (data['education'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final skillsList = (data['skills'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final projList = (data['projects'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final certList = (data['certifications'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final achList = (data['achievements'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final interestsList = (data['interests'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final langList = (data['languages'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final refList = (data['references'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final coverLetter = data['cover_letter'] as Map<String, dynamic>;
    final pubList =
    (data['custom_demo_publications_002'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final declarationText =
    (data['custom_demo_declaration_001'] as Map<String, dynamic>)['text'] as String;

    return TestCase(
      "7.2 Diamond Spine Timeline Resume (1.jpg Replica)",
      CanvasDocument(
        title: "${personal['fullName']} - Diamond Spine Resume",
        author: personal['fullName'].toString(),
        format: CanvasFormat.a4,
        pageMode: PdfPageMode.useOutlines,
        body: CanvasBox(
          width: 595,
          direction: FlexDir.column,
          alignItems: FlexAlign.flexStart,
          decoration: CanvasDecoration(backgroundColor: 0xFFFFFFFF),
          children: [
            CanvasBox(
              width: 595,
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 26.0),
              direction: FlexDir.column,
              alignItems: FlexAlign.flexStart,
              gap: 5.0,
              decoration: CanvasDecoration(backgroundColor: _kSlateNavy),
              children: [
                CanvasText(
                  personal['fullName'].toString(),
                  color: 0xFFFFFFFF,
                  fontSize: 32.0,
                  weight: 800,
                ),
                CanvasBox(height: 2.0),
                CanvasBox(
                  direction: FlexDir.row,
                  gap: 6.0,
                  children: [
                    CanvasText("Address", color: 0xFFFFFFFF, fontSize: 10.5, weight: 800),
                    CanvasText(
                      personal['location'].toString(),
                      color: 0xFFE5E7EB,
                      fontSize: 10.5,
                    ),
                  ],
                ),
                CanvasBox(
                  direction: FlexDir.row,
                  gap: 12.0,
                  children: [
                    CanvasText("Phone", color: 0xFFFFFFFF, fontSize: 10.5, weight: 800),
                    CanvasText(
                      personal['phone'].toString(),
                      color: 0xFFE5E7EB,
                      fontSize: 10.5,
                    ),
                  ],
                ),
                CanvasBox(
                  direction: FlexDir.row,
                  gap: 12.0,
                  children: [
                    CanvasText("E-mail", color: 0xFFFFFFFF, fontSize: 10.5, weight: 800),
                    CanvasText(
                      "${personal['email']}   •   ${personal['linkedin']}   •   ${personal['github']}",
                      color: 0xFFE5E7EB,
                      fontSize: 10.5,
                    ),
                  ],
                ),
              ],
            ),
            CanvasBox(
              width: 595,
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 20.0),
              direction: FlexDir.column,
              alignItems: FlexAlign.flexStart,
              children: [
                CanvasBox(
                  width: 523,
                  margin: EdgeInsets.only(bottom: 16.0),
                  children: [
                    CanvasText(
                      objective,
                      color: _kBodyCharcoal,
                      fontSize: 10.5,
                      lineHeight: 1.45,
                    ),
                  ],
                ),
                _buildDiamondSectionHeader(
                  "Work History",
                  _dPathBriefcase,
                  connectTopLine: false,
                ).meta(bookmark: "1. Work History"),
                ...expList.map((e) {
                  final item = e as Map<String, dynamic>;
                  final List<String> bullets = item['description']
                      .toString()
                      .split('\n')
                      .where((s) => s.trim().isNotEmpty)
                      .toList();
                  return _buildDiamondTimelineEntry(
                    dateText: "${item['startDate']} -\n${item['endDate']}",
                    title: item['jobTitle'].toString(),
                    italicSubtitle: "${item['company']}, ${item['location']}",
                    bulletLines: bullets,
                  );
                }),
                _buildDiamondSectionHeader("Skills", _dPathSkillsPuzzle)
                    .meta(bookmark: "2. Skills"),
                _buildDiamondBulletListBlock(
                  skillsList.map((s) {
                    final map = s as Map<String, dynamic>;
                    return "${map['skill']} (Proficiency: ${map['rating']}/5)";
                  }).toList(),
                ),
                _buildDiamondSectionHeader("Education", _dPathGraduation)
                    .meta(bookmark: "3. Education"),
                ...eduList.map((ed) {
                  final item = ed as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: "${item['startDate']} -\n${item['endDate']}",
                    title: "${item['degree']} (${item['grade']})",
                    italicSubtitle: item['school'].toString(),
                  );
                }),
                _buildDiamondSectionHeader("Projects", _dPathCode)
                    .meta(bookmark: "4. Projects"),
                ...projList.map((p) {
                  final item = p as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: "${item['startDate']} -\n${item['endDate']}",
                    title: item['title'].toString(),
                    italicSubtitle: "${item['techStack']}  |  ${item['link']}",
                    bodyText: item['description'].toString(),
                  );
                }),
                _buildDiamondSectionHeader("Publications", _dPathDocument)
                    .meta(bookmark: "5. Publications"),
                ...pubList.map((pub) {
                  final item = pub as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: item['date'].toString(),
                    title: item['title'].toString(),
                    italicSubtitle: item['subtitle'].toString(),
                    bodyText: item['description'].toString(),
                  );
                }),
                _buildDiamondSectionHeader(
                  "Certifications & Awards",
                  _dPathTrophy,
                ).meta(bookmark: "6. Certifications & Awards"),
                ...certList.map((c) {
                  final item = c as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: item['date'].toString(),
                    title: item['title'].toString(),
                    italicSubtitle: "${item['issuer']}  •  ${item['link']}",
                  );
                }),
                ...achList.map((a) {
                  final item = a as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: item['date'].toString(),
                    title: item['title'].toString(),
                    italicSubtitle: item['issuer'].toString(),
                    bodyText: item['description'].toString(),
                  );
                }),
                _buildDiamondSectionHeader(
                  "Languages & Interests",
                  _dPathSkillsPuzzle,
                ).meta(bookmark: "7. Languages & Interests"),
                _buildDiamondBulletListBlock([
                  ...langList.map((l) {
                    final map = l as Map<String, dynamic>;
                    return "Language: ${map['name']} — ${map['proficiency']}";
                  }),
                  "Interests: ${interestsList.join('  •  ')}",
                ]),
                _buildDiamondSectionHeader(
                  "References & Cover Letter",
                  _dPathBriefcase,
                ).meta(bookmark: "8. References & Cover Letter"),
                ...refList.map((r) {
                  final item = r as Map<String, dynamic>;
                  return _buildDiamondTimelineEntry(
                    dateText: "Reference",
                    title: "${item['name']} (${item['designation']})",
                    italicSubtitle: item['company'].toString(),
                    bodyText: "Email: ${item['email']}  |  Phone: ${item['phone']}",
                  );
                }),
                _buildDiamondTimelineEntry(
                  dateText: "Cover\nLetter",
                  title: "${coverLetter['role']} — ${coverLetter['company']}",
                  bodyText: coverLetter['body'].toString(),
                ),
                _buildDiamondSectionHeader("Declaration", _dPathDocument)
                    .meta(bookmark: "9. Declaration"),
                _buildDiamondTimelineEntry(
                  dateText: "Oct 2026",
                  title: "Official Candidate Declaration",
                  italicSubtitle: "${personal['fullName']} — ${personal['location']}",
                  bodyText: declarationText,
                  drawBottomLine: false,
                ),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // ============================================================================
  // TEMPLATE 3 ("Amelia Parker" Cyber-Navy & Chamfered Gold - temp21.jpg)
  // ============================================================================
  static const int _kCyberOuterBlack = 0xFF020614;
  static const int _kCyberFrameBorder = 0xFF1E3A8A;
  static const int _kNeonCyan = 0xFF00E5FF;
  static const int _kNeonMint = 0xFF2DD4BF;
  static const int _kDarkPillBg = 0xFF030712;

  static const String _svgPushPin =
      "<svg viewBox='0 0 48 48'>"
      "<path fill='#64748B' d='M28 28 L42 42 L38 44 L24 30 Z'/>"
      "<ellipse cx='16' cy='16' rx='12' ry='8' transform='rotate(-35 16 16)' fill='#E2E8F0'/>"
      "<path fill='#94A3B8' d='M14 22 L24 12 L32 22 L20 32 Z'/>"
      "<ellipse cx='27' cy='27' rx='13' ry='9' transform='rotate(-35 27 27)' fill='#CBD5E1'/>"
      "<ellipse cx='15' cy='15' rx='9' ry='5' transform='rotate(-35 15 15)' fill='#FFFFFF'/>"
      "</svg>";

  static const String _svgTopRightNeonStripes =
      "<svg viewBox='0 0 320 26'>"
      "<path fill='#22C55E' d='M0 2 L45 2 L55 8 L10 8 Z'/>"
      "<path fill='#22C55E' d='M65 2 L140 2 L150 8 L75 8 Z'/>"
      "<path fill='#22C55E' d='M160 2 L210 2 L220 8 L170 8 Z'/>"
      "<path fill='#22C55E' d='M50 12 L195 12 L208 22 L63 22 Z'/>"
      "<path fill='#4ADE80' d='M215 10 L260 10 L275 24 L230 24 Z'/>"
      "<path fill='#22C55E' d='M270 10 L305 10 L320 24 L285 24 Z'/>"
      "</svg>";

  static const String _svgBottomLeftCircuit =
      "<svg viewBox='0 0 180 180'>"
      "<circle cx='12' cy='16' r='5.5' fill='#22C55E'/>"
      "<path fill='#22C55E' d='M10.5 16 L13.5 16 L13.5 142 L34 162 L152 162 L152 165 L32 165 L10.5 144 Z'/>"
      "<circle cx='154' cy='163.5' r='6' fill='#22C55E'/>"
      "<circle cx='28' cy='46' r='4.5' fill='#4ADE80'/>"
      "<path fill='#4ADE80' d='M26.5 46 L29.5 46 L29.5 132 L45 147 L116 147 L116 150 L43 150 L26.5 134 Z'/>"
      "<circle cx='118' cy='148.5' r='4.5' fill='#4ADE80'/>"
      "</svg>";

  static const String _svgHalftoneDots =
      "<svg viewBox='0 0 80 120'>"
      "<circle cx='10' cy='10' r='2' fill='#38BDF8'/>"
      "<circle cx='24' cy='20' r='2' fill='#38BDF8'/>"
      "<circle cx='10' cy='30' r='2' fill='#38BDF8'/>"
      "<circle cx='38' cy='30' r='2.2' fill='#38BDF8'/>"
      "<circle cx='24' cy='40' r='2.2' fill='#38BDF8'/>"
      "<circle cx='52' cy='40' r='2.5' fill='#38BDF8'/>"
      "<circle cx='10' cy='50' r='2' fill='#38BDF8'/>"
      "<circle cx='38' cy='50' r='2.5' fill='#38BDF8'/>"
      "<circle cx='66' cy='50' r='2.8' fill='#38BDF8'/>"
      "<circle cx='24' cy='60' r='2.2' fill='#38BDF8'/>"
      "<circle cx='52' cy='60' r='2.5' fill='#38BDF8'/>"
      "<circle cx='10' cy='70' r='2' fill='#38BDF8'/>"
      "<circle cx='38' cy='70' r='2.2' fill='#38BDF8'/>"
      "<circle cx='24' cy='80' r='2' fill='#38BDF8'/>"
      "<circle cx='10' cy='90' r='1.8' fill='#38BDF8'/>"
      "</svg>";

  static const String _kChamferBottomLeftPath =
      "M 26 0 L 294 0 C 308 0 320 12 320 26 L 320 254 C 320 268 308 280 294 280 L 58 280 L 0 222 L 0 26 C 0 12 12 0 26 0 Z";

  static const String _kChamferTopRightPath =
      "M 26 0 L 262 0 L 320 58 L 320 264 C 320 278 308 290 294 290 L 26 290 C 12 290 0 278 0 264 L 0 26 C 0 12 12 0 26 0 Z";

  static CanvasText _buildJustifiedText(
      String text, {
        required double width,
        double fontSize = 9.8,
        int color = 0xFFF8FAFC,
        int weight = 400,
        double lineHeight = 1.38,
      }) {
    return CanvasText(
      text,
      width: width,
      fontFamily: 'Roboto',
      fontSize: fontSize,
      color: color,
      weight: weight,
      align: TextAlign.justify,
      lineHeight: lineHeight,
    );
  }

  static CanvasBox _buildJustifiedBullet(
      String rawBulletText, {
        required double textWidth,
        double fontSize = 9.6,
        int color = 0xFFF8FAFC,
      }) {
    final String clean =
    rawBulletText.replaceFirst(RegExp(r'^[•\-]\s*'), '').trim();
    return CanvasBox(
      width: textWidth + 14.0,
      margin: EdgeInsets.only(bottom: 7.0),
      direction: FlexDir.row,
      alignItems: FlexAlign.flexStart,
      children: [
        CanvasBox(
          width: 14.0,
          children: [
            CanvasText(
              "•",
              color: 0xFFFFFFFF,
              fontSize: fontSize + 2.0,
              weight: 900,
            ),
          ],
        ),
        _buildJustifiedText(
          clean,
          width: textWidth,
          fontSize: fontSize,
          color: color,
          lineHeight: 1.36,
        ),
      ],
    );
  }

  static CanvasBox _buildDarkPillHeader(String title, {double width = 172}) {
    return CanvasBox(
      width: width,
      height: 32,
      justifyContent: FlexJustify.center,
      alignItems: FlexAlign.center,
      decoration: CanvasDecoration(
        backgroundColor: _kDarkPillBg,
        borderRadius: EdgeInsets.all(16.0),
        borderColor: 0xFF1E293B,
        borderWidth: EdgeInsets.all(1.0),
        shadow: CanvasShadow(
          color: 0x88000000,
          offsetX: 0.0,
          offsetY: 4.0,
          blurRadius: 8.0,
        ),
      ),
      children: [
        CanvasText(
          title.toUpperCase(),
          color: 0xFFFFFFFF,
          fontSize: 13.0,
          weight: 800,
          letterSpacing: 0.8,
        ),
      ],
    );
  }

  static CanvasBox _buildWhitePillHeader(String title, {double width = 168}) {
    return CanvasBox(
      width: width,
      height: 32,
      justifyContent: FlexJustify.center,
      alignItems: FlexAlign.center,
      decoration: CanvasDecoration(
        backgroundColor: 0xFFF8FAFC,
        borderRadius: EdgeInsets.all(16.0),
        shadow: CanvasShadow(
          color: 0x55000000,
          offsetX: 0.0,
          offsetY: 3.0,
          blurRadius: 6.0,
        ),
      ),
      children: [
        CanvasText(
          title.toUpperCase(),
          color: 0xFF0F172A,
          fontSize: 13.0,
          weight: 900,
          letterSpacing: 0.8,
        ),
      ],
    );
  }

  static CanvasBox _buildCyberSkillStrip(String label, {double width = 205}) {
    return CanvasBox(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      margin: EdgeInsets.only(bottom: 7.0),
      decoration: CanvasDecoration(
        gradient: const [0xFF020617, 0xFF0F172A, 0xFF071436],
        borderRadius: EdgeInsets.all(6.0),
        borderColor: 0xFF1E293B,
        borderWidth: EdgeInsets.only(
          left: 2.5,
          top: 0.6,
          right: 0.6,
          bottom: 0.6,
        ),
      ),
      children: [
        CanvasText(
          label,
          color: 0xFFF1F5F9,
          fontSize: 9.8,
          weight: 500,
        ),
      ],
    );
  }

  static CanvasBox _buildCyberPageFrame({
    required List<CanvasWidget> pageChildren,
  }) {
    return CanvasBox(
      width: 595,
      height: 842,
      padding: EdgeInsets.all(14.0),
      decoration: CanvasDecoration(backgroundColor: _kCyberOuterBlack),
      children: [
        CanvasBox(
          width: 567,
          height: 814,
          decoration: CanvasDecoration(
            gradient: const [0xFF06112B, 0xFF0A1940, 0xFF050E24],
            gradientAngle: 135.0,
            borderRadius: EdgeInsets.all(24.0),
            borderColor: _kCyberFrameBorder,
            borderWidth: EdgeInsets.all(1.5),
          ),
          children: [
            CanvasBox(
              width: 280,
              height: 22,
              posType: PosType.absolute,
              top: 2,
              right: 18,
              children: [
                CanvasSvg(svgXml: _svgTopRightNeonStripes, width: 280, height: 22),
              ],
            ),
            CanvasBox(
              width: 50,
              height: 90,
              posType: PosType.absolute,
              top: 110,
              left: 4,
              decoration: CanvasDecoration(opacity: 0.35),
              children: [
                CanvasSvg(svgXml: _svgHalftoneDots, width: 50, height: 90),
              ],
            ),
            CanvasBox(
              width: 65,
              height: 105,
              posType: PosType.absolute,
              bottom: 30,
              right: 8,
              decoration: CanvasDecoration(opacity: 0.35),
              children: [
                CanvasSvg(svgXml: _svgHalftoneDots, width: 65, height: 105),
              ],
            ),
            CanvasBox(
              width: 155,
              height: 155,
              posType: PosType.absolute,
              bottom: 4,
              left: 4,
              children: [
                CanvasSvg(svgXml: _svgBottomLeftCircuit, width: 155, height: 155),
              ],
            ),
            ...pageChildren,
          ],
        ),
      ],
    );
  }

  // ============================================================================
  // CASE 7.3: "AMELIA PARKER" CYBER-NAVY & CHAMFERED GOLD RESUME (temp21.jpg)
  // ============================================================================
  static TestCase _case7_3() {
    final data = getDummyResumeData();
    final personal = data['personal_details'] as Map<String, dynamic>;
    final objective = (data['objective'] as Map<String, dynamic>)['text'] as String;
    final expList = (data['experience'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final eduList = (data['education'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final skillsList = (data['skills'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final projList = (data['projects'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final certList = (data['certifications'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final achList = (data['achievements'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final interestsList = (data['interests'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final langList = (data['languages'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final refList = (data['references'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final coverLetter = data['cover_letter'] as Map<String, dynamic>;
    final pubList =
    (data['custom_demo_publications_002'] as Map<String, dynamic>)['list'] as List<dynamic>;
    final declarationText =
    (data['custom_demo_declaration_001'] as Map<String, dynamic>)['text'] as String;

    final exp1 = expList.first as Map<String, dynamic>;
    final exp2 = expList.length > 1 ? expList[1] as Map<String, dynamic> : exp1;
    final edu1 = eduList.first as Map<String, dynamic>;
    final proj1 = projList.first as Map<String, dynamic>;
    final pub1 = pubList.first as Map<String, dynamic>;

    final List<String> exp1Bullets = exp1['description']
        .toString()
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final List<String> exp2Bullets = exp2['description']
        .toString()
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return TestCase(
      "7.3 Cyber-Gold Chamfered Resume (temp21.jpg + MS Word Justify)",
      CanvasDocument(
        title: "${personal['fullName']} - Cyber-Gold Resume",
        author: personal['fullName'].toString(),
        format: CanvasFormat.a4,
        pageMode: PdfPageMode.useOutlines,
        body: CanvasBox(
          width: 595,
          height: 1684,
          direction: FlexDir.column,
          children: [
            _buildCyberPageFrame(
              pageChildren: [
                CanvasBox(
                  width: 515,
                  height: 176,
                  posType: PosType.absolute,
                  top: 32,
                  left: 26,
                  padding: EdgeInsets.only(
                    left: 178.0,
                    right: 20.0,
                    top: 18.0,
                    bottom: 22.0,
                  ),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  gap: 4.0,
                  decoration: CanvasDecoration(
                    gradient: const [0xFF141109, 0xFF6B5314, 0xFFB48A1E],
                    gradientAngle: 20.0,
                    borderRadius: EdgeInsets.all(22.0),
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                    shadow: CanvasShadow(
                      color: 0x99000000,
                      offsetX: 0.0,
                      offsetY: 10.0,
                      blurRadius: 20.0,
                    ),
                  ),
                  children: [
                    CanvasText(
                      personal['fullName'].toString(),
                      color: 0xFFFFFFFF,
                      fontSize: 28.0,
                      weight: 900,
                      fontStyle: FontStyle.italic,
                    ),
                    CanvasText(
                      exp1['jobTitle'].toString(),
                      color: _kNeonMint,
                      fontSize: 14.5,
                      weight: 600,
                      fontStyle: FontStyle.italic,
                    ),
                    CanvasBox(height: 4.0),
                    _buildJustifiedText(
                      objective,
                      width: 312,
                      fontSize: 9.6,
                      color: 0xFFF8FAFC,
                      lineHeight: 1.38,
                    ),
                  ],
                ).meta(bookmark: "1. Profile & Objective"),
                CanvasBox(
                  width: 148,
                  height: 168,
                  posType: PosType.absolute,
                  top: 22,
                  left: 42,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFE2E8F0,
                    borderRadius: EdgeInsets.all(16.0),
                    isClip: true,
                    borderColor: 0xFFFFFFFF,
                    borderWidth: EdgeInsets.all(2.5),
                    shadow: CanvasShadow(
                      color: 0xAA000000,
                      offsetX: 4.0,
                      offsetY: 8.0,
                      blurRadius: 16.0,
                    ),
                  ),
                  children: [
                    CanvasImage(
                      base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                      width: 148,
                      height: 168,
                      fit: ImageFit.cover,
                    ),
                  ],
                ),
                CanvasBox(
                  width: 42,
                  height: 42,
                  posType: PosType.absolute,
                  top: 8,
                  left: 26,
                  children: [
                    CanvasSvg(svgXml: _svgPushPin, width: 42, height: 42),
                  ],
                ),
                CanvasBox(
                  width: 446,
                  height: 26,
                  posType: PosType.absolute,
                  top: 195,
                  left: 60,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  direction: FlexDir.row,
                  justifyContent: FlexJustify.spaceBetween,
                  alignItems: FlexAlign.center,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFF8FAFC,
                    borderRadius: EdgeInsets.all(13.0),
                    shadow: CanvasShadow(
                      color: 0x77000000,
                      offsetX: 0.0,
                      offsetY: 4.0,
                      blurRadius: 10.0,
                    ),
                  ),
                  children: [
                    CanvasText(
                      personal['phone'].toString(),
                      color: 0xFF1E293B,
                      fontSize: 9.8,
                      weight: 700,
                    ),
                    CanvasText(
                      personal['email'].toString(),
                      color: 0xFF1E293B,
                      fontSize: 9.8,
                      weight: 700,
                    ),
                    CanvasText(
                      personal['location'].toString(),
                      color: 0xFF1E293B,
                      fontSize: 9.8,
                      weight: 700,
                    ),
                  ],
                ),
                CanvasBox(
                  width: 195,
                  posType: PosType.absolute,
                  top: 254,
                  left: 34,
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  gap: 10.0,
                  children: [
                    _buildDarkPillHeader("EDUCATION", width: 175),
                    CanvasBox(
                      padding: EdgeInsets.only(left: 16.0, top: 4.0),
                      direction: FlexDir.column,
                      alignItems: FlexAlign.flexStart,
                      gap: 5.0,
                      children: [
                        CanvasText(
                          edu1['degree'].toString(),
                          color: 0xFFFFFFFF,
                          fontSize: 12.0,
                          weight: 800,
                          lineHeight: 1.3,
                        ),
                        CanvasText(
                          edu1['school'].toString(),
                          color: 0xFFCBD5E1,
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                          lineHeight: 1.3,
                        ),
                        CanvasBox(height: 2.0),
                        CanvasText(
                          "${edu1['startDate']} – ${edu1['endDate']}",
                          color: 0xFFFFFFFF,
                          fontSize: 11.0,
                          weight: 800,
                        ),
                        CanvasText(
                          "Grade: ${edu1['grade']}",
                          color: 0xFFE2E8F0,
                          fontSize: 10.5,
                        ),
                      ],
                    ),
                  ],
                ).meta(bookmark: "2. Education"),
                CanvasBox(
                  width: 320,
                  height: 280,
                  posType: PosType.absolute,
                  top: 238,
                  right: 22,
                  padding: EdgeInsets.all(20.0),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  decoration: CanvasDecoration(
                    gradient: const [0xFFB48A1E, 0xFF6B5314, 0xFF090A0F],
                    gradientAngle: 35.0,
                    isClip: true,
                    clipSvgPath: _kChamferBottomLeftPath,
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                    shadow: CanvasShadow(
                      color: 0x99000000,
                      offsetX: 0.0,
                      offsetY: 8.0,
                      blurRadius: 18.0,
                    ),
                  ),
                  children: [
                    CanvasBox(
                      widthPct: 100,
                      direction: FlexDir.row,
                      justifyContent: FlexJustify.end,
                      margin: EdgeInsets.only(bottom: 12.0),
                      children: [
                        _buildWhitePillHeader("EXPERIENCE", width: 170),
                      ],
                    ),
                    CanvasText(
                      exp1['jobTitle'].toString(),
                      color: _kNeonCyan,
                      fontSize: 12.5,
                      weight: 800,
                    ),
                    CanvasBox(
                      margin: EdgeInsets.only(left: 10.0, top: 2.0, bottom: 10.0),
                      children: [
                        CanvasText(
                          "${exp1['company']} ( ${exp1['startDate']} - ${exp1['endDate']} )",
                          color: 0xFFFFFFFF,
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                    CanvasBox(
                      margin: EdgeInsets.only(left: 14.0),
                      direction: FlexDir.column,
                      children: exp1Bullets
                          .map((b) => _buildJustifiedBullet(b, textWidth: 246))
                          .toList(),
                    ),
                  ],
                ).meta(bookmark: "3. Experience"),
                CanvasBox(
                  width: 320,
                  height: 290,
                  posType: PosType.absolute,
                  top: 492,
                  left: 24,
                  padding: EdgeInsets.all(20.0),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  decoration: CanvasDecoration(
                    gradient: const [0xFF090A0F, 0xFF6B5314, 0xFFB48A1E],
                    gradientAngle: 45.0,
                    isClip: true,
                    clipSvgPath: _kChamferTopRightPath,
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                    shadow: CanvasShadow(
                      color: 0x99000000,
                      offsetX: 0.0,
                      offsetY: 8.0,
                      blurRadius: 18.0,
                    ),
                  ),
                  children: [
                    CanvasBox(
                      margin: EdgeInsets.only(bottom: 14.0),
                      children: [
                        _buildWhitePillHeader("EXPERIENCE", width: 170),
                      ],
                    ),
                    CanvasText(
                      exp2['jobTitle'].toString(),
                      color: _kNeonCyan,
                      fontSize: 12.5,
                      weight: 800,
                    ),
                    CanvasBox(
                      margin: EdgeInsets.only(left: 10.0, top: 2.0, bottom: 10.0),
                      children: [
                        CanvasText(
                          "${exp2['company']} ( ${exp2['startDate']} - ${exp2['endDate']} )",
                          color: 0xFFFFFFFF,
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                    CanvasBox(
                      margin: EdgeInsets.only(left: 8.0),
                      direction: FlexDir.column,
                      children: exp2Bullets
                          .map((b) => _buildJustifiedBullet(b, textWidth: 252))
                          .toList(),
                    ),
                  ],
                ),
                CanvasBox(
                  width: 205,
                  posType: PosType.absolute,
                  top: 545,
                  right: 18,
                  direction: FlexDir.column,
                  alignItems: FlexAlign.center,
                  children: [
                    _buildDarkPillHeader("SKILL", width: 170),
                    CanvasBox(height: 14.0),
                    ...skillsList.map((s) {
                      final map = s as Map<String, dynamic>;
                      return _buildCyberSkillStrip(
                        map['skill'].toString(),
                        width: 205,
                      );
                    }),
                  ],
                ).meta(bookmark: "4. Skills"),
              ],
            ),
            _buildCyberPageFrame(
              pageChildren: [
                CanvasBox(
                  width: 195,
                  posType: PosType.absolute,
                  top: 38,
                  left: 28,
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  children: [
                    _buildDarkPillHeader("LANGUAGES", width: 175),
                    CanvasBox(height: 12.0),
                    ...langList.map((l) {
                      final map = l as Map<String, dynamic>;
                      return _buildCyberSkillStrip(
                        "${map['name']} — ${map['proficiency']}",
                        width: 190,
                      );
                    }),
                    CanvasBox(height: 14.0),
                    _buildDarkPillHeader("INTERESTS", width: 175),
                    CanvasBox(height: 12.0),
                    ...interestsList.map((interest) {
                      return _buildCyberSkillStrip(
                        interest.toString(),
                        width: 190,
                      );
                    }),
                  ],
                ).meta(bookmark: "5. Languages & Interests"),
                CanvasBox(
                  width: 320,
                  height: 280,
                  posType: PosType.absolute,
                  top: 34,
                  right: 22,
                  padding: EdgeInsets.all(20.0),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  decoration: CanvasDecoration(
                    gradient: const [0xFFB48A1E, 0xFF6B5314, 0xFF090A0F],
                    gradientAngle: 35.0,
                    isClip: true,
                    clipSvgPath: _kChamferBottomLeftPath,
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                  ),
                  children: [
                    CanvasBox(
                      widthPct: 100,
                      direction: FlexDir.row,
                      justifyContent: FlexJustify.end,
                      margin: EdgeInsets.only(bottom: 10.0),
                      children: [
                        _buildWhitePillHeader("PROJECTS & PUBS", width: 180),
                      ],
                    ),
                    CanvasText(
                      proj1['title'].toString(),
                      color: _kNeonCyan,
                      fontSize: 12.0,
                      weight: 800,
                    ),
                    CanvasText(
                      "${proj1['techStack']} ( ${proj1['startDate']} - ${proj1['endDate']} )",
                      color: 0xFFFFFFFF,
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                    ),
                    CanvasBox(height: 4.0),
                    _buildJustifiedBullet(
                      proj1['description'].toString(),
                      textWidth: 252,
                    ),
                    CanvasBox(height: 6.0),
                    CanvasText(
                      pub1['title'].toString(),
                      color: _kNeonCyan,
                      fontSize: 12.0,
                      weight: 800,
                    ),
                    CanvasText(
                      "${pub1['subtitle']} ( ${pub1['date']} )",
                      color: 0xFFFFFFFF,
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                    ),
                    CanvasBox(height: 4.0),
                    _buildJustifiedBullet(
                      pub1['description'].toString(),
                      textWidth: 252,
                    ),
                  ],
                ).meta(bookmark: "6. Projects & Publications"),
                CanvasBox(
                  width: 320,
                  height: 290,
                  posType: PosType.absolute,
                  top: 310,
                  left: 24,
                  padding: EdgeInsets.all(20.0),
                  direction: FlexDir.column,
                  alignItems: FlexAlign.flexStart,
                  decoration: CanvasDecoration(
                    gradient: const [0xFF090A0F, 0xFF6B5314, 0xFFB48A1E],
                    gradientAngle: 45.0,
                    isClip: true,
                    clipSvgPath: _kChamferTopRightPath,
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                  ),
                  children: [
                    CanvasBox(
                      margin: EdgeInsets.only(bottom: 12.0),
                      children: [
                        _buildWhitePillHeader("COVER LETTER", width: 170),
                      ],
                    ),
                    CanvasText(
                      "Role: ${coverLetter['role']}",
                      color: _kNeonCyan,
                      fontSize: 12.5,
                      weight: 800,
                    ),
                    CanvasBox(
                      margin: EdgeInsets.only(top: 2.0, bottom: 10.0),
                      children: [
                        CanvasText(
                          "Target Company: ${coverLetter['company']}",
                          color: 0xFFFFFFFF,
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                    _buildJustifiedText(
                      coverLetter['body'].toString(),
                      width: 274,
                      fontSize: 9.8,
                      color: 0xFFF8FAFC,
                      lineHeight: 1.42,
                    ),
                  ],
                ).meta(bookmark: "7. Cover Letter"),
                CanvasBox(
                  width: 205,
                  posType: PosType.absolute,
                  top: 335,
                  right: 18,
                  direction: FlexDir.column,
                  alignItems: FlexAlign.center,
                  children: [
                    _buildDarkPillHeader("AWARDS & CERTS", width: 180),
                    CanvasBox(height: 10.0),
                    ...certList.map((c) {
                      final map = c as Map<String, dynamic>;
                      return _buildCyberSkillStrip(
                        "${map['title']}\n${map['issuer']} (${map['date']})",
                        width: 205,
                      );
                    }),
                    ...achList.map((a) {
                      final map = a as Map<String, dynamic>;
                      return _buildCyberSkillStrip(
                        "🏆 ${map['title']} (${map['date']})\n${map['description']}",
                        width: 205,
                      );
                    }),
                    CanvasBox(height: 10.0),
                    _buildDarkPillHeader("REFERENCE", width: 180),
                    CanvasBox(height: 10.0),
                    ...refList.map((r) {
                      final map = r as Map<String, dynamic>;
                      return _buildCyberSkillStrip(
                        "${map['name']} — ${map['designation']}\n${map['company']}\n${map['email']}",
                        width: 205,
                      );
                    }),
                  ],
                ).meta(bookmark: "8. Awards & Reference"),
                CanvasBox(
                  width: 515,
                  height: 135,
                  posType: PosType.absolute,
                  bottom: 24,
                  left: 26,
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  direction: FlexDir.column,
                  justifyContent: FlexJustify.spaceBetween,
                  decoration: CanvasDecoration(
                    gradient: const [0xFF141109, 0xFF5C4710, 0xFF9A7418],
                    borderRadius: EdgeInsets.all(18.0),
                    borderColor: 0xFFD9A526,
                    borderWidth: EdgeInsets.all(1.2),
                  ),
                  children: [
                    CanvasBox(
                      widthPct: 100,
                      direction: FlexDir.row,
                      justifyContent: FlexJustify.spaceBetween,
                      alignItems: FlexAlign.center,
                      children: [
                        _buildWhitePillHeader("DECLARATION", width: 155),
                        CanvasText(
                          "Place: ${personal['location']}   |   Date: Oct 2026",
                          color: _kNeonCyan,
                          fontSize: 10.0,
                          weight: 700,
                        ),
                      ],
                    ),
                    _buildJustifiedText(
                      declarationText,
                      width: 470,
                      fontSize: 10.0,
                      color: 0xFFFFFFFF,
                      lineHeight: 1.38,
                    ),
                    CanvasBox(
                      widthPct: 100,
                      direction: FlexDir.row,
                      justifyContent: FlexJustify.end,
                      children: [
                        CanvasText(
                          "Signed: ${personal['fullName']} (Authorized Signature)",
                          color: _kNeonMint,
                          fontSize: 11.0,
                          weight: 800,
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),
                  ],
                ).meta(bookmark: "9. Declaration"),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
      needsImageFile: true,
    );
  }
}