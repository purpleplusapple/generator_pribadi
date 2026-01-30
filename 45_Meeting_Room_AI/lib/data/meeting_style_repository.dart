import '../model/meeting_style.dart';

class MeetingStyleRepository {
  static const _baseAssetPath = 'assets/style_sources';

  // Helper to get cycled images
  static List<String> _getImages(int index) {
    // We have ~30 images. We need 4 per style.
    // We cycle through them using modulo.
    final start = (index * 2) % 30; // Shift by 2 each time
    return [
      '$_baseAssetPath/source_${(start % 30) + 1}.jpg', // +1 because files are 1-based? No, I formatted 001.
      '$_baseAssetPath/source_${((start + 1) % 30) + 1}.jpg',
      '$_baseAssetPath/source_${((start + 2) % 30) + 1}.jpg',
      '$_baseAssetPath/source_${((start + 3) % 30) + 1}.jpg',
    ].map((s) {
       // Fix 0 padding if I used %03d in python
       // Python: f"source_{i+1:03d}.jpg" -> source_001.jpg
       // Here: I need to pad manually or use a helper.
       // Simpler: Just rely on string interpolation logic below.
       final id = int.parse(s.split('_').last.split('.').first);
       return '$_baseAssetPath/source_${id.toString().padLeft(3, '0')}.jpg';
    }).toList();
  }

  static final List<StyleControl> _commonControls = [
    const StyleControl(
      id: 'capacity',
      label: 'Capacity',
      type: ControlType.stepper,
      min: 2,
      max: 24,
      step: 1,
      defaultValue: 8,
    ),
    const StyleControl(
      id: 'table_shape',
      label: 'Table Shape',
      type: ControlType.chips,
      options: ['Rectangular', 'Round', 'U-Shape', 'Classroom', 'Oval'],
      defaultValue: 'Rectangular',
    ),
    const StyleControl(
      id: 'av_level',
      label: 'AV Technology',
      type: ControlType.chips,
      options: ['Basic', 'Pro', 'Studio', 'Hidden'],
      defaultValue: 'Pro',
    ),
    const StyleControl(
      id: 'lighting',
      label: 'Lighting',
      type: ControlType.chips,
      options: ['Task', 'Ambient', 'Daylight', 'Dramatic'],
      defaultValue: 'Daylight',
    ),
    const StyleControl(
      id: 'acoustics',
      label: 'Acoustics',
      type: ControlType.chips,
      options: ['Standard', 'High Absorption', 'Studio Quality'],
      defaultValue: 'Standard',
    ),
     const StyleControl(
      id: 'note',
      label: 'Notes',
      type: ControlType.text,
      defaultValue: '',
    ),
  ];

  static final List<MeetingStyle> styles = [
    // 1. Executive Boardroom
    MeetingStyle(
      id: 'executive_boardroom',
      name: 'Executive Boardroom',
      description: 'Premium, authoritative, high-end finishes.',
      moodboardImages: _getImages(0),
      basePrompt: 'executive boardroom, expensive wood table, leather chairs, dark graphite walls, premium lighting, cinematic',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'luxury_level', label: 'Luxury Level', type: ControlType.slider, min: 1, max: 10, defaultValue: 8),
      ],
    ),
    // 2. Modern Minimal
    MeetingStyle(
      id: 'modern_minimal',
      name: 'Modern Minimal',
      description: 'Clean lines, white surfaces, clutter-free.',
      moodboardImages: _getImages(1),
      basePrompt: 'modern minimal meeting room, all white, clean lines, glass walls, scandinavian furniture, bright',
      controls: _commonControls,
    ),
    // 3. Glass Walled
    MeetingStyle(
      id: 'glass_walled',
      name: 'Glass Conference',
      description: 'Transparent, open, airy, tech-forward.',
      moodboardImages: _getImages(2),
      basePrompt: 'glass walled conference room, transparency, modern office view, sleek metal furniture',
      controls: _commonControls,
    ),
    // 4. Industrial Loft
    MeetingStyle(
      id: 'industrial_loft',
      name: 'Industrial Collaboration',
      description: 'Exposed brick, pipes, raw wood, creative.',
      moodboardImages: _getImages(3),
      basePrompt: 'industrial loft meeting room, exposed brick walls, ductwork, raw wood table, metal chairs, pendant lights',
      controls: _commonControls,
    ),
    // 5. Creative Agency
    MeetingStyle(
      id: 'creative_agency',
      name: 'Creative Agency',
      description: 'Colorful, modular, inspiring, writable walls.',
      moodboardImages: _getImages(4),
      basePrompt: 'creative agency meeting room, colorful accents, whiteboard walls, bean bags, casual seating, modular',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'color_pop', label: 'Accent Color', type: ControlType.chips, options: ['Teal', 'Orange', 'Yellow', 'Blue'], defaultValue: 'Teal'),
      ],
    ),
    // 6. Startup Pod
    MeetingStyle(
      id: 'startup_pod',
      name: 'Startup Huddle',
      description: 'Small, agile, tech-focused, casual.',
      moodboardImages: _getImages(5),
      basePrompt: 'startup huddle room, small meeting pod, soundproof, neon sign, tech startup vibe',
      controls: _commonControls,
    ),
    // 7. Luxury Black
    MeetingStyle(
      id: 'luxury_black',
      name: 'Midnight Executive',
      description: 'Dark mode real life, brass accents, moody.',
      moodboardImages: _getImages(6),
      basePrompt: 'luxury black meeting room, matte black walls, brass accents, marble table, moody lighting',
      controls: _commonControls,
    ),
    // 8. Scandinavian Bright
    MeetingStyle(
      id: 'scandi_bright',
      name: 'Scandinavian Bright',
      description: 'Light wood, plants, soft textiles, cozy.',
      moodboardImages: _getImages(7),
      basePrompt: 'scandinavian meeting room, light oak wood, plants, soft grey textiles, hygge, natural light',
      controls: _commonControls,
    ),
    // 9. Japandi Calm
    MeetingStyle(
      id: 'japandi_calm',
      name: 'Japandi Zen',
      description: 'Japanese minimalism meets Scandi comfort.',
      moodboardImages: _getImages(8),
      basePrompt: 'japandi meeting room, low profile furniture, wood slats, bonsai, zen atmosphere, beige and wood',
      controls: _commonControls,
    ),
    // 10. Mid-Century
    MeetingStyle(
      id: 'mid_century',
      name: 'Mid-Century Modern',
      description: 'Retro vibes, teak wood, iconic chairs.',
      moodboardImages: _getImages(9),
      basePrompt: 'mid-century modern meeting room, teak furniture, eames chairs, retro lamp, warm tones',
      controls: _commonControls,
    ),
    // 11. Hotel Suite
    MeetingStyle(
      id: 'hotel_suite',
      name: 'Hotel Conference',
      description: 'Hospitality feel, carpeted, formal yet soft.',
      moodboardImages: _getImages(10),
      basePrompt: 'hotel conference suite, patterned carpet, heavy drapes, serving credenza, hospitality vibe',
      controls: _commonControls,
    ),
    // 12. Training Room
    MeetingStyle(
      id: 'training_room',
      name: 'Training Classroom',
      description: 'Rows of desks, front screen, educational.',
      moodboardImages: _getImages(11),
      basePrompt: 'corporate training room, classroom setup, rows of desks, instructor podium, smartboard',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'rows', label: 'Rows', type: ControlType.stepper, min: 1, max: 6, defaultValue: 3),
      ],
    ),
    // 13. Brainstorm Focus
    MeetingStyle(
      id: 'brainstorm',
      name: 'Brainstorm Lab',
      description: 'Walls covered in whiteboards, standing desks.',
      moodboardImages: _getImages(12),
      basePrompt: 'brainstorming room, floor to ceiling whiteboards, standing high tables, sticky notes, markers',
      controls: _commonControls,
    ),
    // 14. Acoustic Comfort
    MeetingStyle(
      id: 'acoustic',
      name: 'Acoustic Studio',
      description: 'Sound panels, soft surfaces, quiet focus.',
      moodboardImages: _getImages(13),
      basePrompt: 'acoustic meeting room, felt wall panels, carpet, soft furniture, soundproof studio look',
      controls: _commonControls,
    ),
    // 15. Video Conf Pro
    MeetingStyle(
      id: 'vc_pro',
      name: 'Video Conference Pro',
      description: 'Optimized for camera, green screen option.',
      moodboardImages: _getImages(14),
      basePrompt: 'video conference room, dual screens, camera eye level, acoustic treatment, optimized lighting for video',
      controls: [
        ..._commonControls,
        const StyleControl(id: 'screens', label: 'Screens', type: ControlType.chips, options: ['Single', 'Dual', 'Wall'], defaultValue: 'Dual'),
      ],
    ),
    // 16. Town Hall
    MeetingStyle(
      id: 'town_hall',
      name: 'Town Hall Stage',
      description: 'Small stage, podium, audience seating.',
      moodboardImages: _getImages(15),
      basePrompt: 'town hall meeting space, small stage, podium, microphone, tiered seating, presentation',
      controls: _commonControls,
    ),
    // 17. U-Shape Strategy
    MeetingStyle(
      id: 'u_shape',
      name: 'War Room U-Shape',
      description: 'Center focus, screens everywhere, tactical.',
      moodboardImages: _getImages(16),
      basePrompt: 'strategy war room, u-shape table, multiple monitors, maps on wall, intense atmosphere',
      controls: _commonControls,
    ),
    // 18. Classroom
    MeetingStyle(
      id: 'classroom',
      name: 'Seminar Room',
      description: 'Standard education layout, functional.',
      moodboardImages: _getImages(17),
      basePrompt: 'seminar room, functional furniture, bright lighting, projector screen, lecture style',
      controls: _commonControls,
    ),
    // 19. Round Table
    MeetingStyle(
      id: 'round_table',
      name: 'Round Table',
      description: 'Equality, discussion, face-to-face.',
      moodboardImages: _getImages(18),
      basePrompt: 'round table meeting room, circular discussion, equal seating, centerpiece, intimate',
      controls: _commonControls,
    ),
    // 20. Minimal Monochrome
    MeetingStyle(
      id: 'mono_minimal',
      name: 'Monochrome Grey',
      description: 'Shades of grey, texture over color.',
      moodboardImages: _getImages(19),
      basePrompt: 'monochrome grey meeting room, concrete texture, grey fabric, tonal design, sophisticated',
      controls: _commonControls,
    ),
    // 21. Warm Wood
    MeetingStyle(
      id: 'warm_wood',
      name: 'Warm Wood Executive',
      description: 'Rich timber, inviting, traditional yet modern.',
      moodboardImages: _getImages(20),
      basePrompt: 'warm wood meeting room, walnut paneling, timber ceiling, warm light, inviting corporate',
      controls: _commonControls,
    ),
    // 22. LED Wall
    MeetingStyle(
      id: 'led_wall',
      name: 'High-Tech LED',
      description: 'Massive screen wall, futuristic, impressive.',
      moodboardImages: _getImages(21),
      basePrompt: 'high tech meeting room, massive LED video wall, futuristic lighting, sleek black table',
      controls: _commonControls,
    ),
    // 23. Legal Classic
    MeetingStyle(
      id: 'legal_classic',
      name: 'Legal Firm Classic',
      description: 'Bookshelves, heavy wood, imposing.',
      moodboardImages: _getImages(22),
      basePrompt: 'law firm conference room, bookshelves, heavy mahogany table, leather chairs, traditional prestige',
      controls: _commonControls,
    ),
    // 24. Healthcare Clean
    MeetingStyle(
      id: 'healthcare',
      name: 'Healthcare Clean',
      description: 'Sterile but comfortable, white and blue.',
      moodboardImages: _getImages(23),
      basePrompt: 'medical meeting room, clean white surfaces, blue accents, hygienic materials, bright',
      controls: _commonControls,
    ),
    // 25. Finance Graphite
    MeetingStyle(
      id: 'finance_graphite',
      name: 'Finance Corporate',
      description: 'Serious, steel, glass, city view.',
      moodboardImages: _getImages(24),
      basePrompt: 'finance corporate boardroom, skyscraper view, steel and glass, serious atmosphere, graphite tones',
      controls: _commonControls,
    ),
    // 26. Coworking Booth
    MeetingStyle(
      id: 'coworking',
      name: 'Coworking Booth',
      description: 'Tiny, soundproof, vibrant, practical.',
      moodboardImages: _getImages(25),
      basePrompt: 'coworking phone booth, small meeting pod, acoustic felt, glass door, compact',
      controls: _commonControls,
    ),
    // 27. Huddle Room
    MeetingStyle(
      id: 'huddle',
      name: 'Small Huddle',
      description: 'Casual, 4 people, quick sync.',
      moodboardImages: _getImages(26),
      basePrompt: 'small huddle room, casual seating, round table, whiteboard, coffee mugs',
      controls: _commonControls,
    ),
    // 28. Large Conference
    MeetingStyle(
      id: 'large_conf',
      name: 'Large Conference',
      description: '20+ people, mic systems, formal.',
      moodboardImages: _getImages(27),
      basePrompt: 'large conference hall, long table, microphone system, formal seating, corporate event',
      controls: _commonControls,
    ),
    // 29. Budget Practical
    MeetingStyle(
      id: 'budget',
      name: 'Budget Practical',
      description: 'Simple, ikea-esque, functional.',
      moodboardImages: _getImages(28),
      basePrompt: 'budget meeting room, simple white tables, plastic chairs, functional, clean, office basics',
      controls: _commonControls,
    ),
    // 30. Premium Signature
    MeetingStyle(
      id: 'signature',
      name: 'Signature Collection',
      description: 'The ultimate bespoke meeting experience.',
      moodboardImages: _getImages(29),
      basePrompt: 'signature bespoke meeting room, custom art, italian furniture, architectural lighting, masterpiece',
      controls: _commonControls,
    ),
    // Custom
    MeetingStyle(
      id: 'custom',
      name: 'Custom (Advanced)',
      description: 'Build your own prompt from scratch.',
      moodboardImages: _getImages(0), // Fallback
      basePrompt: '', // Empty, relies on user input
      controls: [
         const StyleControl(id: 'custom_prompt', label: 'Custom Prompt', type: ControlType.text, defaultValue: ''),
         const StyleControl(id: 'negative_prompt', label: 'Negative Prompt', type: ControlType.text, defaultValue: 'blurry, distorted, low quality'),
         ..._commonControls,
      ],
    ),
  ];

  static MeetingStyle getById(String id) {
    return styles.firstWhere((s) => s.id == id, orElse: () => styles.first);
  }
}
