# Dierb go-live checklist

## Done in repository and CI

- [x] Production Firebase project identifiers use `dierb-29548`.
- [x] Customer, Merchant and Rider package IDs are fixed.
- [x] Admin web no longer initializes the legacy Firebase project.
- [x] Admin authorization checks `admins/{uid}`.
- [x] COD order records preserve integer-piaster financial snapshots.
- [x] Canonical order transitions are shared by all apps.
- [x] Customer, Merchant and Rider release APK/AAB builds run in CI.
- [x] Admin static web release build runs in CI.
- [x] Arabic mojibake scan is clean.
- [x] Online-payment, refund, webhook-idempotency, subscription and ledger domain contracts exist with tests.
- [x] Online payment stays disabled until a verified server adapter exists.

## Needs external credential or infrastructure

- [ ] Register a dedicated Firebase Web app and replace the temporary Admin web `appId`.
- [ ] Add Android upload-keystore secrets to GitHub Actions.
- [ ] Restore and expose the image service on HTTPS; port 8091 must pass `/health` and an authenticated upload test.
- [ ] Supply the real payment provider documentation and secrets.
- [ ] Deploy the verified payment/webhook backend before enabling online payment.

## Needs one-time production operation

- [ ] Deploy `firestore.rules` and `firestore.indexes.json` to `dierb-29548`.
- [ ] Create the first trusted `admins/{uid}` record.
- [ ] Seed cities and categories using the trusted seed process.
- [ ] Create authorized Customer, Merchant, Rider and Admin acceptance-test accounts.
- [ ] Complete a real COD order lifecycle on production Firestore.
- [ ] Configure backup, uptime/error monitoring, support contact and legal URLs.

## Needs business/legal decision

- [ ] Confirm support phone/WhatsApp and operating entity details.
- [ ] Approve merchant trial days, subscription price, grace period and commission settings.
- [ ] Approve privacy, terms, merchant terms and refund wording.
