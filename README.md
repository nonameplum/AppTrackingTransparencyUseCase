# App Tracking Transparency Use Case

## Description

Demo application requesting tracking authorization with given circumstances specified below.
The app shows a custom alert, before requesting the authorization which results in presenting iOS's "IDFA" alert.

## BDD Specs:

```
Given the user installs the app for the first time
Or updates the app with the IDFA check logic rolled out
And the device has disabled IDFA permission (globally in the system settings)
When he makes a search and goes back to the home screen
Then the app shows the IDFA pop-up
```

```
Given the user opened the app already 2 times
And the device has disabled IDFA permission
And the user has made at least one search before
When he opens the app for 3rd time
Then the app shows the IDFA pop-up
```

```
Given the user opened the app already 8 times
And has disabled IDFA permission
And the user has made at least one search before
When he opens the app for the 9th time
Then the app shows the IDFA pop-up
```

```
Given the user launched the app 9 times
And didn't do a search
When the user launches the app 10th time
And makes a search and goes back to the home screen
Then the app will show the pop-up
```

```
Given the user has allowed using IDFA
When the user opens the app
Then the app will not show IDFA pop-up view
```

```
Given the user launched the app for the first time
And made a search
And killed the app (the user didn't see the popup yet)
When the user launches the app for the second time
And the app doesn't show the pop-up
And the user launches the app for the third time
Then the app will show the pop-up again
```

```
Given the user launched the app for the first time
And killed the app (the user didn't see the popup yet)
And the user launched the app for the second time
And the user made a search
And killed the app (the user didn't see the popup yet)
When the user launches the app for the third time
Then the app will show the pop-up
And the app won't show the pop-up again in that session
(eg. by making another search and going by to the home screen)
```

```
Given the user launched the app 9 times
And didn't do the search
When the user launches the app 10th time
And makes the search
And goes back to the home screen
Then the app will show the pop-up
```
