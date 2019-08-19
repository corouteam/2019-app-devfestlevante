# DevFest Levante 2019 - Official App

The official app for [Dev Fest Levante 2019](http://devfestlevante.eu/) written in **Flutter**.

<a href="https://play.google.com/store/apps/details?id=com.github.corouteam.devfestlevante2019"><img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" width="300" /></a>

## Structure
The app is divided in 3 main sections:

### Schedule page
<img src="https://github.com/corouteam/2019-app-devfestlevante/blob/master/pics/screen_1.png" width="300"> <img src="https://github.com/corouteam/2019-app-devfestlevante/blob/master/pics/screen_2.png" width="300">

### Favourites
<img src="https://github.com/corouteam/2019-app-devfestlevante/blob/master/pics/screen_4.png" width="300">

### Info
<img src="https://github.com/corouteam/2019-app-devfestlevante/blob/master/pics/screen_5.png" width="300">

## Firebase
### Cloud Firestore
All **Talks, Speakers and FAQ** are hosted on **Cloud Firestore**.

You can find more about our data structure in [lib/repository](https://github.com/corouteam/2019-app-devfestlevante/tree/master/lib/repository) folder classes.

### Auth
We use Firebase Authentication to authenticate users and sync bookmarks for each one.

### Cloud Messaging
We also added Cloud messaging and deployed some code on Cloud Functions to send and manage user notifications. You can find all in the */functions* folder.

## About and Licence
DevFest Levante 2019 was made by Corouteam, a small team at **GDG Bari**.

The code is shared under Apache 2.0. Feel free to fork the project and use it for your event!
