import 'package:flutter/material.dart';

class EmergencyProtocolsScreen extends StatelessWidget {
  const EmergencyProtocolsScreen({super.key});

  final List<Map<String, dynamic>> protocols = const [
    {
      "priority": "Critical",
      "title": "Cardiac Arrest",
      "shortDescription": "Immediate CPR and defibrillation protocol",
      "description":
          "• Check responsiveness\n• Call code blue immediately\n• Start CPR with 30:2 compression ratio",
      "icon": Icons.favorite,
      "color": Color(0xFFEF4444),
      "gradient": [Color(0xFFEF4444), Color(0xFFDC2626)],
      "timeFrame": "0-2 mins",
      "steps": [
        "Assess responsiveness",
        "Check breathing (10s max)",
        "Call for help & activate emergency response",
        "Begin chest compressions 100-120/min",
        "Attach AED/defibrillator",
        "Continue CPR until help arrives",
      ],
      "details":
          "Cardiac arrest requires immediate intervention. High-quality CPR is critical.",
    },
    {
      "priority": "Critical",
      "title": "Respiratory Emergency",
      "shortDescription": "Airway management and oxygen therapy",
      "description":
          "• Assess airway\n• Administer high-flow oxygen\n• Prepare intubation",
      "icon": Icons.air,
      "color": Color(0xFF3B82F6),
      "gradient": [Color(0xFF3B82F6), Color(0xFF2563EB)],
      "timeFrame": "0-5 mins",
      "steps": [
        "Open airway",
        "Clear obstructions",
        "Apply high-flow oxygen",
        "Monitor saturation",
        "Prepare bag-mask ventilation",
        "Consider advanced airway",
      ],
      "details": "Early recognition and oxygen therapy prevent deterioration.",
    },
    {
      "priority": "High",
      "title": "Severe Bleeding",
      "shortDescription": "Hemorrhage control and shock prevention",
      "description":
          "• Apply direct pressure to wound\n• Elevate injured extremity\n• Use tourniquet if necessary",
      "icon": Icons.bloodtype,
      "color": Color(0xFF7C3AED),
      "gradient": [Color(0xFF7C3AED), Color(0xFF6D28D9)],
      "timeFrame": "0-3 mins",
      "steps": [
        "Apply direct pressure with sterile gauze",
        "Elevate bleeding extremity above heart level",
        "Apply pressure bandage if bleeding continues",
        "Use tourniquet 2-3 inches above wound if limb bleeding",
        "Monitor vital signs for shock",
        "Prepare fluid resuscitation if hypotensive",
      ],
      "details":
          "Severe hemorrhage can cause shock quickly. Immediate control is essential.",
    },
    {
      "priority": "High",
      "title": "Severe Allergic Reaction",
      "shortDescription": "Anaphylaxis management protocol",
      "description":
          "• Administer epinephrine immediately\n• Maintain airway patency\n• Monitor for biphasic reaction",
      "icon": Icons.warning,
      "color": Color(0xFF059669),
      "gradient": [Color(0xFF059669), Color(0xFF047857)],
      "timeFrame": "0-5 mins",
      "steps": [
        "Remove/stop allergen exposure",
        "Administer epinephrine 0.3mg IM",
        "Place patient supine with legs elevated",
        "Maintain airway & provide oxygen",
        "Start IV for fluid resuscitation",
        "Monitor for biphasic reaction (4-12h)",
      ],
      "details":
          "Anaphylaxis is life-threatening; immediate epinephrine is crucial.",
    },
    {
      "priority": "Medium",
      "title": "Fracture / Bone Injury",
      "shortDescription": "Immobilization and pain management",
      "description":
          "• Assess injury\n• Immobilize with splint\n• Apply ice packs",
      "icon": Icons.bolt,
      "color": Color(0xFFF59E0B),
      "gradient": [Color(0xFFF59E0B), Color(0xFFD97706)],
      "timeFrame": "0-30 mins",
      "steps": [
        "Assess injury site and neurovascular status",
        "Immobilize fracture using splint or support",
        "Apply ice packs to reduce swelling",
        "Elevate limb if possible",
        "Monitor for shock",
        "Transport safely to hospital",
      ],
      "details":
          "Proper immobilization prevents further injury and reduces pain.",
    },
    {
      "priority": "Medium",
      "title": "Burn Injury",
      "shortDescription": "Cooling and wound care",
      "description":
          "• Remove heat source\n• Cool burn area\n• Cover with sterile dressing",
      "icon": Icons.local_fire_department,
      "color": Color(0xFFFB923C),
      "gradient": [Color(0xFFFB923C), Color(0xFFF97316)],
      "timeFrame": "0-20 mins",
      "steps": [
        "Remove patient from heat source",
        "Cool burn with running water 10-20 mins",
        "Remove jewelry or constricting items",
        "Cover burn with sterile non-stick dressing",
        "Assess for shock or airway involvement",
        "Seek medical attention for severe burns",
      ],
      "details": "Immediate cooling reduces tissue damage and pain.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color appBarColor = isDark ? const Color(0xFF1A202C) : const Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Emergency Protocols", style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: protocols.length,
        itemBuilder: (context, index) {
          final protocol = protocols[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ProtocolCard(
              protocol: protocol,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProtocolDetailScreen(protocol: protocol),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//=================== Protocol Card ===================
class ProtocolCard extends StatelessWidget {
  final Map<String, dynamic> protocol;
  final VoidCallback onTap;
  const ProtocolCard({super.key, required this.protocol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBackgroundColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color borderColor = isDark ? Colors.transparent : const Color(0xFFE2E8F0);
    final Color descriptionColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);
    final Color shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.06);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [protocol['color'].withOpacity(0.7), protocol['color']]
                        : protocol['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(protocol['icon'], color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            protocol['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            protocol['shortDescription'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  protocol['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: descriptionColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//=================== Protocol Detail ===================
class ProtocolDetailScreen extends StatelessWidget {
  final Map<String, dynamic> protocol;
  const ProtocolDetailScreen({super.key, required this.protocol});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color cardColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color stepCardColor = isDark
        ? protocol['color'].withOpacity(0.2)
        : protocol['color'].withOpacity(0.1);
    final Color shadowColor = isDark ? Colors.transparent : Colors.black12;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(protocol['title'], style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              protocol['details'],
              style: TextStyle(fontSize: 16, height: 1.6, color: textColor),
            ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: protocol['steps'].length,
                itemBuilder: (context, index) {
                  final step = protocol['steps'][index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: stepCardColor,
                    elevation: isDark ? 0 : 1,
                    shadowColor: shadowColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: protocol['color'],
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(step, style: TextStyle(fontSize: 14, color: textColor)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}