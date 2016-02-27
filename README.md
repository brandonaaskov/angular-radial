# angular-radial

This is a simple directive as created as part of the [Fullscreen Creator Platform](https://community.fullscreen.net/). It's intended to be used with percentages to just show completion status in a less... progressy-bar kind of way. It doesn't rely on any libraries outside of Angular itself. The arc is drawn using the `arc()` method on the [Canvas API](https://developer.mozilla.org/en-US/docs/HTML/Canvas).

# Installation

`bower install https://github.com/brandonaaskov/angular-radial.git`

Wherever your `bower_components` folder lives, you'll see an angular-radial folder in there. If you want to use the compressed build files, check the `build` directory. If you want to use the source file, all you need is the `angular-radial.js` file in the `src` folder.

# Usage

#### Simplest Use
```html
<radial percent-complete="myPercentageValue"></radial>
```

#### All the Options
```html
<radial percent-complete="myPercentageValue"
        font-family="'Comic Sans', 'Marker Felt', sans_serif"
        radius="180"
        line-width="75"
        line-cap="round"
        bg-color="e0f1cb"
        color="9ad154"
        font-color="#fff"></radial>
```
_note: please never use comic sans or marker felt in production_

# Examples/Demos

You can see the examples by going to the [demo site](https://angular-radial.firebaseapp.com/) (_note: you don't need Firebase for this app - they just have a dead-simple deployment process so I used them_). If you're developing locally, then running `gulp` should start up [a localhost server for you running on port 3000](http://localhost:3000).
