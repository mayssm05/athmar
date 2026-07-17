<div dir="rtl">

# أثمر 🌱

**وفّر… وشوف فلوسك تُثمر.**

أثمر ميزة ادخار مبتكرة داخل تطبيق **مصرف الإنماء** تحوّل التوفير من التزام ثقيل إلى رحلة ممتعة — كل ريال توفّره يسقي نبتة تكبر معك، خطوة بخطوة، حتى تُثمر ويتحقق هدفك.

## 💡 الفكرة

أغلب الناس يعرفون أن الادخار مهم، لكن قلة يستمرون عليه. المشكلة مو في المعرفة — المشكلة في الدافع. أثمر يحل هذي المشكلة بطريقة بسيطة وذكية:

- **حوّلنا الادخار إلى نمو حي:** بدل أرقام جامدة في حساب بنكي، تشوفين نبتتك تنمو من بذرة إلى شجرة مثمرة مع كل مبلغ توفّرينه.
- **عداد الالتزام:** يحفّزك تحافظين على استمراريتك يوم بعد يوم.
- **المزارع الذكي 🧑‍🌾:** مستشار مالي بالذكاء الاصطناعي يتكلم لغتك، يجاوب على أسئلتك، ويشجعك لما تحتاجين دفعة.

## ✨ المميزات

| الميزة | الوصف |
|---|---|
| 🎯 تحديد الهدف | اختاري هدفك (طوارئ، سفر، سيارة...) والمبلغ والمدة |
| 🌱 نبتة تنمو معك | ٦ مراحل نمو حيّة تعكس تقدمك الفعلي |
| 🔥 عداد الالتزام | يحسب أيام استمراريتك ويحفّزك ما تنقطعين |
| 🧑‍🌾 المزارع الذكي | محادثة ذكاء اصطناعي بالعربي تقدم نصائح ادخار مخصصة |
| 📱 تصميم عربي أصيل | واجهة عربية كاملة من اليمين لليسار بتجربة جوال سلسة |

## 🎯 الأثر

الادخار عادة، والعادات تُبنى بالتحفيز المستمر. أثمر يستهدف جيل كامل يبغى يبني مستقبله المالي لكن يحتاج أسلوب يناسبه — أسلوب مرئي، تفاعلي، ويتكلم لغته.

</div>

---

# Athmar 🌱

**Save… and watch your money bear fruit.**

Athmar (Arabic for *"to bear fruit"*) is a savings feature designed for the **Alinma Bank** app. It turns saving money from a chore into a living journey — every riyal you save waters a plant that grows with you, stage by stage, until it fruits and your goal is reached.

## 💡 The Idea

Most people know saving matters; few stick with it. The problem isn't knowledge — it's motivation. Athmar solves this with one simple, powerful loop:

- **Savings you can see grow:** instead of cold numbers in a bank account, you watch your plant grow from a seed to a fruiting tree with every deposit.
- **Commitment streak:** a daily counter that keeps your momentum alive.
- **The Smart Farmer 🧑‍🌾:** an AI financial companion that speaks your language, answers your questions, and cheers you on.

## ✨ Features

| Feature | Description |
|---|---|
| 🎯 Goal setup | Pick a goal (emergency fund, travel, car...), amount, and timeline |
| 🌱 A plant that grows with you | 6 living growth stages mirroring your real progress |
| 🔥 Commitment streak | Tracks your consistency and keeps you motivated |
| 🧑‍🌾 Smart Farmer AI | Arabic AI chat offering personalized savings advice |
| 📱 Authentic Arabic design | Full RTL Arabic interface with a polished mobile experience |

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart) — compiled to web, phone-mockup experience
- **Backend:** Node.js + Express (TypeScript)
- **AI:** OpenAI via Replit AI Integrations
- **Monorepo:** pnpm workspaces
- **Typography:** IBM Plex Sans Arabic

## 🚀 Run Locally

```bash
# Install dependencies
pnpm install

# Start the API server
pnpm --filter @workspace/api-server run dev

# Start the Athmar web app
pnpm --filter @workspace/athmar run dev
```

To rebuild the Flutter app after changing Dart code:

```bash
cd artifacts/athmar/app
flutter pub get
flutter build web --base-href /athmar/ --release --pwa-strategy=none
cd .. && node postbuild.mjs
```

## 🌐 Live Demo

**[athmora.com](https://athmora.com)**

---

<div align="center">

صُنع بحب 🌱 *Made with love — watch your savings bear fruit.*

</div>
