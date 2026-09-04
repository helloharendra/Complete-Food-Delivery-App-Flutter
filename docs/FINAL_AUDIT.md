# Dierb production audit

Status is evidence-based and must not be interpreted as a guarantee that an unavailable external service works.

| Area | Status | Evidence |
|---|---|---|
| Shared domain | PASS | `dart analyze` and `dart test` in CI |
| Customer Android | PASS | Analyze, tests, release APK and AAB CI jobs |
| Merchant Android | PASS | Analyze, tests, release APK and AAB CI jobs |
| Rider Android | PASS | Analyze, tests, release APK and AAB CI jobs |
| Admin Web | PASS | Analyze, tests and release web build CI job |
| Admin legacy Firebase removal | FIXED | `admin_web_portal/web/index.html` uses Flutter bootstrap only |
| Firebase public discovery | PASS | Production constrained REST queries returned an approved store and a published community post |
| Arabic source encoding | PASS | Repository Dart mojibake scan returned zero matches |
| COD data contract | FIXED | Explicit payment state and rider cash-collection fields; Firestore rule validation |
| Online payment | EXTERNAL CREDENTIAL REQUIRED | Provider-neutral contract exists; feature remains disabled |
| Subscription/ledger architecture | FIXED | Minor-unit models, access rules and tests added |
| VPS image upload | BLOCKED | `169.58.246.131:8091` timed out from external verification |
| Google Play signing | EXTERNAL CREDENTIAL REQUIRED | CI supports keystore secrets; fallback artifacts are not Play production signing |
| Real authenticated E2E | BLOCKED | Requires authorized production test accounts and live upload service |

## Security decisions

- A client cannot create/update payments, subscriptions or ledger entries.
- Clients cannot self-promote to admin, approved merchant/rider, verified, featured or paid.
- Online payment success is reserved for the future trusted webhook backend.
- COD delivery records who collected cash and when.
- Historical order financial snapshots use integer minor units.

## Latest verification commands

- `dart analyze && dart test` in `packages/dierb_core`
- `flutter analyze --no-fatal-warnings --no-fatal-infos`
- `flutter test`
- `flutter build apk --release`
- `flutter build appbundle --release`
- `flutter build web --release` for Admin
