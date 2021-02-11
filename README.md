FuckYou Tube (GPLv3)
===

Turn your screen off without Youtube Music (TM)

### ⚠️ There are .apk in the release tab!

### Why would you make this app when YouTube Vanced exists?
I really like when the next song in the playlist is already buffered, and
there's a smooth transition between tracks. Yes, I lost weeks of my short
life for this.

### Before you keep on reading

This is a small PoC of mine. The code quality is very low, and there are only
few features: it's only the minimal ones that I wanted: being able to look up my channel,
and play any of my playlists with cool transitions and my screen locked.

If you wish to contribute, I highly advise you to start by de-spaghettifying the code.

### Exeperiment outcome

What a fucking mess of a project this is. I loved tinkering with ytdl and eploring
the media capabilities of modern web browsers.
But really? CORS had to ruin all the fun. No joke, my mental health took a hit from this.
Anyways I've also learned that `adb logcat` is a lifesaver

To run this in your chromium-based desktop browser, use --disable-web-security

This is a proof of concept more than anything else, but if you're interested in contributing,
feel free to say hi!

## Cool ideas that could be reality

* Download songs as they get streamed
* Better UI & playlist management
* [On-screen controls when the screen is locked](https://www.npmjs.com/package/cordova-plugin-music-controls)
* This app not being a real spaghetti plate
* My cheap ass phone has trouble making a fluid playback, how about optimization?

## Install the dependencies
```bash
npm install
```

If you have issues in `ytdl` or any package like this saying something with `URL`
go to said package and comment out the `import URL` statement at the top of the file

### Start the app in development mode (hot-code reloading, error reporting, etc.)
```bash
quasar dev
```

### Build the app for production
```bash
quasar build
```

## Make a fucking app
1. I shit on CORS (at least when making cordova/capacitor apps, it makes no fucking sense in this context)
2. `$ npm i -g phonegap`
3. `$ phonegap create release && cd release`
4. https://github.com/phonegap/phonegap-cli/issues/749#issuecomment-774092746 and make sure to use npm i everytime it spits a missing module at you
   And while I'm at it 'android-versions compare-func' too
5. In config.xml, remove the icon resources, using defaults is great
6. `$ phonegap plugin add cordova-plugin-whitelist` and add the few lines of xml below if not already there
7. In your "real project" ide, do `$ quasar build`
8. copy from project/dist/spa to release/www
9. `$ phonegap build android` I have no clue what this does
10. `$ cordova run android`

As easy as ABC!

Yes I know, PhoneGap has been killed by Adobe for years now, but yet it's the only way I found to get the whitelist plugin
to actually work. So I'll stick with it. If you're a pro and have better ways please show me.

```xml
<access origin="*" />
<allow-navigation href="*" />
<allow-intent href="http://*/*" />
<allow-intent href="https://*/*" />
<preference name="OverrideUserAgent" value="My desktop browser 1.2.3" />
```

Thank you so much to everyone who contributed to open-source projects making this possible

There's no warranty and please read the license, and only listen to NoCopyrightSounds thank you

### Customize the configuration
See [Configuring quasar.conf.js](https://quasar.dev/quasar-cli/quasar-conf-js).
