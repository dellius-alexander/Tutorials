# Creating a service account

A service account's credentials include a generated email address that is unique and at least one public/private key pair. If domain-wide delegation is enabled, then a client ID is also part of the service account's credentials.

If your application runs on Google App Engine, a service account is set up automatically when you create your project.

If your application runs on Google Compute Engine, a service account is also set up automatically when you create your project, but you must specify the scopes that your application needs access to when you create a Google Compute Engine instance. For more information, see Preparing an instance to use service accounts.

If your application doesn't run on Google App Engine or Google Compute Engine, you must obtain these credentials in the Google API Console. To generate service-account credentials, or to view the public credentials that you've already generated, do the following:

1. Open the `Service accounts` page.
2. If prompted, select a project, or create a new one.
3. Click + `Create service account`.
Under Service account details, type a name, ID, and description for the service account, then click Create.
Optional: Under Service account permissions, select the IAM roles to grant to the service account, then click Continue.
Optional: Under Grant users access to this service account, add the users or groups that are allowed to use and manage the service account.
Click add Create key, then click Create.