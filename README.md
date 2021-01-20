<img src="https://github.com/jyotirmoy-paul/private-room/blob/master/images/feature-image.png" />

# privateroom

An E2EE messaging application using Flutter and Firebase.

## Note

The flie `lib/utility/sensitive_constants.dart` is intentionally omitted from pushing to GitHub.

`sensitive_constants.dart` contains a password of length 32, stored by the developer, which is used in combination with the **user provided** password to generate a strong password combination, which is finally used for encryption.

Basically just to add a layer of security, in case the user password is very easy to guess.

The content of `sensitive_constants.dart` is as follows:
`const developerKey = '<here-goes-your-long-developer-password>';`


## Read on Medium

Read the story of [private-room](https://medium.com/@mr.jyotirmoy.paul/building-an-private-room-chat-application-using-flutter-d11306a0623c?source=friends_link&sk=f0d69451d76d3f52e9ddc120bf851a3b)
