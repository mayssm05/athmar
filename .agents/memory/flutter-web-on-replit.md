---
name: Flutter web on Replit
description: How to serve a Flutter (Dart) app in this monorepo's artifact preview, and the service-worker pitfall.
---

**Rule:** There is no Flutter artifact type. Install the `flutter` nix package, scaffold under `artifacts/<slug>/app/`, build with `flutter build web --base-href <previewPath> --release --pwa-strategy=none`, and serve `app/build/web` with a tiny node static server (`server.mjs`) that reads `PORT`/`BASE_PATH` and strips the base prefix (SPA fallback to index.html, `cache-control: no-store` in dev).

**Why:** The vite scaffold's dev server can't serve Flutter; the managed workflow only injects PORT/BASE_PATH into the artifact's `dev` script, so replacing the `dev` script with the node server keeps proxy routing intact.

**Service-worker pitfall:** Flutter's `flutter_service_worker.js` caches aggressively and wedges the proxied preview on rebuilds (blank page, console shows "Updating service worker"). Even `--pwa-strategy=none` still leaves `serviceWorkerSettings` in `flutter_bootstrap.js`. Fix: post-build script strips `serviceWorkerSettings` from `flutter_bootstrap.js` and replaces `flutter_service_worker.js` with a kill-switch worker that unregisters itself and clears caches (see `artifacts/athmar/postbuild.mjs`).

**Fonts:** don't rely on the `google_fonts` package at runtime; bundle .ttf files under `assets/fonts/` and declare them in pubspec — runtime fetch silently falls back to default Naskh.

**Images blank in preview/screenshots:** CanvasKit's CPU-only fallback (no WebGL in the proxied preview/headless browsers) silently fails to draw browser-decoded images — `Image.asset` reports frame 0 loaded but nothing paints. Fix: decode PNGs in pure Dart (`image` package) and feed raw RGBA to `ui.decodeImageFromPixels` + `RawImage` (see `artifacts/athmar/app/lib/raw_asset_image.dart`).

**Screenshotting inner routes:** use named routes + hash URLs (`/#/route`) so the Screenshot tool can reach non-home screens.
