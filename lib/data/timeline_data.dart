import 'package:flutter/material.dart';
import 'package:memory_weave/models/memory_model.dart';

// بتاع صفحة الهوم
final List<Map<String, dynamic>> timelineData = [
  {
    'title': 'Amazing day at the Pyramids 🇪🇬',
    'image': 'images/pyramids.jpg',
    'friendsNames': ['Ahmed', 'Sara', 'Mahmoud'],
    'extraCount': 5,
  },
  {
    'title': 'Business breakfast with the new team ',
    'image': 'images/work breakfast.jpg',
    'friendsNames': ['Yassin', 'Layla'],
    'extraCount': 2,
  },
  {
    'title': 'Mountain Camping Trip ',
    'image': 'images/safari trip.jpg',
    'friendsNames': ['Karim', 'Nour', 'Omar', 'Salma'],
    'extraCount': 12,
  },
  {
    'title': 'Best friends graduation ceremony 🎓',
    'image': 'images/graduation.jpg',
    'friendsNames': ['Mariam'],
    'extraCount': 0,
  },
  {
    'title': 'Exciting football match ',
    'image': 'images/football.jpg',
    'friendsNames': ['Hany', 'Ziad', 'Ramy'],
    'extraCount': 8,
  },
  {
    'title': 'Coding and App Development Workshop ',
    'image': 'images/developing apps.jpg',
    'friendsNames': ['Ibrahim', 'Mazen'],
    'extraCount': 15,
  },
  {
    'title': 'Warm family dinner ',
    'image': 'images/dinner.jpg',
    'friendsNames': ['Khaled', 'Fatima', 'Ola'],
    'extraCount': 4,
  },
  {
    'title': 'Brainstorming session for the new project ',
    'image': 'images/brainstorming.jpg',
    'friendsNames': ['Youssef', 'Sherif', 'Gamal', 'Mona'],
    'extraCount': 1,
  },
  {
    'title': 'Morning Running Marathon ',
    'image': 'images/marathon.jpg',
    'friendsNames': ['Tarek'],
    'extraCount': 22,
  },
  {
    'title': 'Visiting the Annual Art Exhibition ',
    'image': 'images/art.jpg',
    'friendsNames': ['Hind', 'Wael'], // مصفوفة فارغة لتجربة الـ UI بدون أصدقاء
    'extraCount': 0,
  },
];

// Timeline دول عشان صفحة ال
final List<Map<String, String>> timelineScreenData = [
  {
    "title": "The Silence of Alpine Dawn",
    "date": "October 2025",
    "description":
        "Waking up before the world to the crisp air of the Dolomites. The silence was heavy yet comforting, like a physical weight.",
    "image": "images/tl0.jpg",
  },
  {
    "title": "Urban Rhythms",
    "date": "September 2025",
    "description":
        "The neon glow of Shinjuku at midnight. A sea of people, yet everyone is in their own world. The city never truly sleeps.",
    "image": "images/tl1.jpg",
  },
  {
    "title": "Coastal Whispers",
    "date": "August 2025",
    "description":
        "The sound of waves crashing against the cliffs of Moher. Salt in the air and the feeling of being at the edge of the world.",
    "image": "images/Coastal Whispers.jpg",
  },
  {
    "title": "Golden Hour in Tuscany",
    "date": "July 2025",
    "description":
        "Walking through the vineyards as the sun dips below the hills. Everything is bathed in a warm, amber light.",
    "image": "images/Golden Hour in Tuscany.jpg",
  },
];

// Memories دول عشان صفحة ال
//attributes من المودل ده واديها ال objects  وبعد كده بهمل ليست واحط فيها  attributes عشان اديه ال class model الحتة دي مهمة اوي انا عملت
final List<MemoryItem> memoriesData = [
  MemoryItem(
    title: 'Sunday Harvest Dinner',
    date: 'OCTOBER 24, 2023',
    image: 'images/dinner.jpg',
    type: MemoryType.story,
    duration: null,
    badge: 'STORY AI',
    // عشان يعرف ده كارت كبير ولا لا
    isFeatured: true,
  ),

  MemoryItem(
    title: 'Wildflower Walk',
    date: 'SEP 12',
    image: 'images/marathon.jpg',
    type: MemoryType.photo,
    duration: null,
    badge: null,
    isFeatured: false,
  ),
  MemoryItem(
    title: "Grandma's Cookie Recipe",
    date: 'AUG 05',
    image: '', // voice — مش محتاجة صورة
    type: MemoryType.voice,
    duration: '2:45 MIN',
    badge: null,
    isFeatured: false,
  ),
  // ③ كارت كبيرة تانية
  MemoryItem(
    title: 'Cloud Peaks',
    date: 'SUMMER 2023',
    image: 'images/safari trip.jpg',
    type: MemoryType.photo,
    duration: null,
    badge: 'RK',
    isFeatured: true,
  ),
  // ④ كارتين صغيرين جنب بعض
  MemoryItem(
    title: 'Forgotten Notes',
    date: 'JUN 22',
    image: 'images/art.jpg',
    type: MemoryType.note,
    duration: null,
    badge: null,
    isFeatured: false,
  ),
  MemoryItem(
    title: 'First Steps',
    date: 'MAY 10',
    image: 'images/graduation.jpg',
    type: MemoryType.photo,
    duration: null,
    badge: null,
    isFeatured: false,
  ),
];
// دي برضو عشان صفحة الميموريز بس عشان لما اختار القسمهي اللي هتشيل الداتا لحظيا
List<MemoryItem> displayedMemories = [];

// عشان صفحة البروفايل
List<String> profileText = [
  "Account Security",
  "Notification Preference",
  "Privacy & Weaving",
  "Export Archive",
];
List<IconData> profileCardIcons = [
  Icons.security,
  Icons.notifications_active_rounded,
  Icons.bookmarks_rounded,
  Icons.cloud_download,
];
