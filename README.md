# ALU Connect
### A Mobile-First Campus Engagement Platform for African Leadership University

ALU Connect is a Flutter application built to solve a real problem ALU students face every day — 
there is no central place to find out what is happening on campus. Hackathons, internships, 
workshops, and club events get shared through scattered WhatsApp groups and emails, and students 
miss opportunities simply because they never saw the announcement.

This app brings everything into one platform. Organizers post directly to a shared feed. 
Students discover, filter, RSVP, chat, and track their campus involvement — all from their phones.

>  Built with Flutter (Dart) &nbsp;|&nbsp;  Mock data & local state management &nbsp;|&nbsp;  Runs on Android emulator and Chrome

---

##  Features

###  Authentication & Onboarding
- Animated splash screen with ALU Connect branding
- 3-slide onboarding carousel introducing the platform's value before sign up
- Sign Up with full form validation and real-time password strength indicator
- Login with email and password validation
- Forgot Password with 2-step email confirmation flow
- Role selection during sign up — **Student** or **Organizer**
- Google SSO button (UI ready, OAuth integration pending)

###  Home Feed & Discovery
- Personalized greeting with upcoming deadline count
- Filter chips: All, Hackathons, Internships, Fellowships, Events, Programs
- **Trending Now** section with featured opportunity cards
- **Upcoming Deadlines** list with urgency indicators
- Tap through to full event detail screen

###  Communities & Chat
- Browse and join community hubs (e.g. Founders Circle, Tech Ventures)
- Lightweight chat interface within event and community spaces
- Discussion feeds per community

###  RSVP & Event Management
- RSVP to events directly from the feed or event detail screen
- Track upcoming and past RSVPs
- Organizer view for posting and managing events

###  Profile & Settings
- Student profile with name, class year, and program
- **Impact Score** out of 1000 with progress bar and global ranking
- **Achievement Badges**: Global Leader, Hacker Extra, Mentor, Top Contributor
- Joined Hubs display
- Portfolio section to showcase projects with tags, descriptions, and Featured label
- Account settings and management

---

##  Getting Started

### Prerequisites
Make sure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio or VS Code with Flutter extension
- Git

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/ArnoldEloiBM/alu_connect.git
cd alu_connect
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Run the app**
```bash
# On Android emulator
flutter run

# On Chrome browser
flutter run -d chrome
```

### Dependencies

| Package | Purpose |
|---|---|
| `google_fonts` | Consistent typography across all screens |
| `shared_preferences` | Lightweight local data persistence |
| `cupertino_icons` | iOS-style icon support |

---
---

## Team — Cohort 4, Team 18

| Name | Branch | Responsibility |
|---|---|---|
| Laura Karangwa Kwizera | `profile/authentication` | Authentication & Onboarding |
| Rolande Tumugane | `feature/home-feed` | Home Feed & Discovery |
| Peter Michael Angelo Rucakibungo | `community-chat` | Communities & Chat |
| Arnold Eloi Muvunyi Buyange | `main & events-rsvp` | RSVP & Event Management |
| Tabitha Dorcas Akimana | `profile-settings` | Profile & Settings |

---

##  AI Usage Disclosure

AI tools (Claude by Anthropic) were used during this project to support code scaffolding, 
resolve import errors, and structure the authentication flow. The use of AI was treated as a productivity aid, not a replacement for 
understanding. Every design choice and implementation detail in this submission reflects 
the team's own thinking and judgment.

---

##  Course Information

**Mobile Application Development**    
**Formative Assignment 1 | Cohort 4, Team 18 | 2026**
