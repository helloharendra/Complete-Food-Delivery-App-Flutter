# Payment provider integration

Online payments are intentionally disabled until a real provider is selected. Cash on delivery remains the launch payment method.

## Provider handoff inputs

- Provider name and API documentation
- Merchant/account identifier
- Public/client key, when the hosted checkout requires one
- Server secret/API key
- Webhook signing secret and signature algorithm
- Sandbox and production API URLs
- Approved callback URL and webhook URL
- Enabled payment methods and EGP support
- Native marketplace/split-settlement capability
- Refund and partial-refund capability
- Recurring/subscription-payment capability

## Required server behavior

Implement `PaymentGateway` in a private backend, never in Flutter or the Admin web bundle. The backend must create sessions, verify webhook signatures and amounts, store provider event IDs idempotently, update `payments`, and only then move an online order into the merchant-visible state.

Required environment variables should use provider-specific names and a secret manager. No server secret belongs in Git, an APK, or `firebase_options.dart`.

## Endpoints to supply later

- `POST /payments`: authenticated pending payment/session creation
- `GET /payments/{id}`: authenticated status query
- `POST /payments/{id}/refunds`: privileged refund request
- `POST /webhooks/{provider}`: raw-body signature verification and idempotent event handling
- `POST /subscriptions/{merchantId}/payments`: subscription checkout creation

The webhook is authoritative. A browser redirect or mobile callback must never mark a payment as paid.
