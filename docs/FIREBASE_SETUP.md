# Dierb production Firebase setup

The repository uses the production Firebase project `dierb-29548`.

1. Email/Password Authentication and the native `(default)` Firestore database must remain enabled.
2. Android registrations are `com.capbeltagy.dierb`, `com.dierb.merchant`, and `com.dierb.rider`.
3. The committed customer `google-services.json` must continue to match project `dierb-29548` and package `com.capbeltagy.dierb`.
4. Create a dedicated Firebase Web app for the admin portal and replace only its generated web options when available; do not change the project ID or schema.
5. From `admin_web_portal`, deploy `firestore.rules` and `firestore.indexes.json`. `.firebaserc` is pinned to `dierb-29548` to prevent accidental deployment to the legacy project.
6. Create the first `admins/{uid}` record from the Firebase Console or a trusted server environment. Never allow a client to create its own admin record.
7. Seed `config/seeds/dierb_launch.json` and `config/seeds/marketplace_taxonomy.json` from a trusted Admin/CLI process. Until the first seed, clients use the same centralized launch taxonomy as a safe configuration fallback.
8. Product/store images use the separately operated Dierb upload service. Firebase Storage is not required for the current Spark deployment.

Never point `.firebaserc` or any app back to the legacy Food Delivery Firebase project.
