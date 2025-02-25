# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] Implement a custom camera view.

The following **additional** features are implemented:

- [x] Fade animation
- [x] Grid view of user's posts

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Working with nib files
2. AutoLayout on collection view and table view cells

## Video Walkthrough

Here's a walkthrough of implemented user stories:


<img src='https://github.com/rigrergl/instagram/blob/main/ezgif.com-video-to-gif-2.gif' title='Video Walkthrough' width='600' alt='Video Walkthrough' />
sign up, login, user persistence
 - User can take a photo, add a caption, and post it to "Instagram"
 - Custom camera view
 - Allow the logged in user to add a profile photo
 - Display the profile photo with each post
 - After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
 -  Show the username and creation time for each post
 -  User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
 -  Style the login page to look like the real Instagram login page.
 -  Style the feed to look like the real Instagram feed.
 -  User can view the last 20 posts submitted to "Instagram"


<img src='https://github.com/rigrergl/instagram/blob/main/ezgif.com-video-to-gif-3.gif' title='Video Walkthrough' width='300' alt='Video Walkthrough' />
 - User can tap a post to view post details, including timestamp and caption.

<img src='https://github.com/rigrergl/instagram/blob/main/ezgif.com-video-to-gif.gif' title='Video Walkthrough' width='300' alt='Video Walkthrough' />
 - User can like a post and see number of likes for each post in the post details screen.
 - Run your app on your phone and use the camera to take the photo
<img src='https://github.com/rigrergl/instagram/blob/main/refresh.gif' title='Video Walkthrough' width='300' alt='Video Walkthrough' />
 - Pull to refresh


<img src='https://github.com/rigrergl/instagram/blob/main/infinite_scroll_and_profile_image_tap.gif' title='Video Walkthrough' width='300' alt='Video Walkthrough' />
 - Tapping on a post's username or profile photo goes to that user's profile page
 - User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.


GIF created with [Kap](https://getkap.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

## License

    Copyright 2021 Rigre R. Garciandia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
