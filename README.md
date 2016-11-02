# purescript-slackbot

This is my attempt at a very simple slackbot written in
[purescript](http://www.purescript.org).  It's very basic, and the heavy
lifting is done by Slack's
[node-slack-sdk](https://github.com/slackhq/node-slack-sdk).

This is still a major WIP, and mostly being used as a learning experiment.


# Setup + Dependencies

* Install [Purescript](https://github.com/purescript/purescript), [Pulp](https://github.com/bodil/pulp), and [Bower](https://github.com/bower/bower)
  * `npm install -g purescript pulp bower`
* Install project dependencies
  * `bower install` (Select newest versions of packages if asked)
  * `npm install`


# Build + Run

* Build/Compile the project
  * `pulp build`
* Run the app
  * `pulp run`
