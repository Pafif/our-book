# Our Book

Our private book as an app for our phones: the story, photos, notes, places, someday list and watch list.
It is a web app you install from Chrome. It is hosted free on GitHub Pages, and Supabase (free plan)
keeps the entries and photos and handles signing in.

Setup takes about 20 minutes and is done once. Do steps 1 to 6 on a computer.

---

## 1. Create the Supabase project

1. Go to https://supabase.com and sign up (signing in with GitHub is fine).
2. Click **New project**. Name it `our-book`, choose a database password (save it somewhere, you
   will rarely need it), pick the region **Central EU (Frankfurt)**, and create it.
   Wait a minute or two until it says the project is ready.

## 2. Create the book and bring your entries across

1. In the project, open **SQL Editor** (left sidebar) and click **New query**.
2. Open `supabase/setup.sql` from this folder, copy all of it, and paste it in.
3. Near the top, replace `your.email@example.com` and `her.email@example.com` with the two email
   addresses you will sign in with. **Only these two emails can ever open the book.**
4. Click **Run**. It should end with "Success. No rows returned".

This also brings over everything already in the book: your names, the start date, the title,
the watch list, Bratislava and "Match cosplays".

## 3. Create your two accounts

1. Open **Authentication** > **Sign In / Providers**, and switch **off** "Allow new users to sign up".
   Save. (Nobody new can create an account; only the two you add next.)
2. Open **Authentication** > **Users** > **Add user** > **Create new user**.
   Enter your email and a password, tick **Auto Confirm User**, and create it.
3. Do the same for her email. Tell her the password privately.

The emails must be the same ones you wrote into `setup.sql`.

## 4. Connect the app to Supabase

1. In Supabase open **Project Settings** > **Data API** and copy the **Project URL**.
2. Open **Project Settings** > **API Keys**. Copy the **anon public** key (on the
   "Legacy API Keys" tab), or the **publishable** key if that is what you see.
3. Open `config.js` in this folder with any text editor and paste both values in place of
   `https://YOUR-PROJECT.supabase.co` and `YOUR-ANON-KEY`. Keep the quote marks. Save.

These two values are meant to be public. The members list and access rules from step 2 are what
keep the book private.

## 5. Put it on GitHub Pages

1. On GitHub, click **+** > **New repository**. Name it `our-book`, set it to **Public**
   (free GitHub Pages needs a public repository), and create it without a README.
2. On the new repository's page, click **uploading an existing file**, drag in **everything in
   this folder** (including the `icons` and `supabase` folders), and click **Commit changes**.
3. Open **Settings** > **Pages**. Under "Build and deployment", set Source to
   **Deploy from a branch**, Branch to **main** and folder **/ (root)**, and click **Save**.
4. After a minute or two the page shows your address, something like
   `https://YOUR-GITHUB-NAME.github.io/our-book/`. Open it on the computer: you should see the
   sign-in card. Sign in once to check it works.

The repository being public means anyone could read the app's code. The book's contents, photos
and your emails are not in it; they live in Supabase behind your sign-in.

## 6. Install it on both phones

On each Android phone:

1. Open the address from step 5 in **Chrome** and sign in.
2. Tap **Install app** at the top right. If that button doesn't appear, open Chrome's **⋮** menu and
   choose **Add to home screen** > **Install**.
3. The book now has its own icon and opens full-screen, like any other app.

You stay signed in. Anything one of you adds appears on the other phone straight away.

---

## Good to know

- **Offline:** the app opens without internet and shows the book as it was the last time it was
  online. Adding or changing things needs a connection; it tells you if you are offline.
  Photos need a connection to load.
- **Supabase pauses free projects after a week with no use at all.** Opening the app now and then
  keeps it awake. If it ever stops loading, sign in at supabase.com and press **Restore project**;
  nothing is lost.
- **Space:** the free plan holds 1 GB of photos. Photos are shrunk before uploading
  (to at most 1800 pixels on the long side, usually 200 to 600 KB), so that is a few thousand photos.
- **Forgotten password:** in Supabase open **Authentication** > **Users**, delete that user, and
  add them again with a new password (step 3). The book's contents are not tied to the account,
  so nothing is lost.
- **Changing the app later:** after editing any file, open `sw.js` and raise the number in
  `const VERSION = 'our-book-v1'` (to `v2`, `v3`…), so the phones pick up the new version.
  Upload the changed files to the GitHub repository the same way as in step 5.
- **Backup:** in Supabase, **Table Editor** > `memories` > **Export to CSV** saves all the entries.

## What's in this folder

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `config.js` | Your Supabase address and key (step 4) |
| `manifest.webmanifest`, `icons/` | Name and icons for installing on the phone |
| `sw.js` | Lets the app open fast and offline |
| `supabase/setup.sql` | One-time database setup, with your existing entries (step 2) |
