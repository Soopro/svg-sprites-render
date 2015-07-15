# Svg Sprites Render

Idea is load multiple svg sprites files into sprites object, then render to `<svg>` on html page.


## Usage

1. Load into html of course. `<script src="scripts/svg-sprites-render.js"></script>`.
1. Place `<svg>` tag into html, with `svg-sprite` format is `<groupname>:<svg-id>`
1. Create a svgSprites object in js.
1. Load svg sprites files with group name.
1. render the svgSprites object.

```javascript
<script>
  svgSet = new svgSprites()
  svgSet.load('../styles/sprites.svg', 'group1')
  svgSet.load('../styles/sprites2.svg', 'group2')
  svgSet.load('../styles/sprites3.svg', 'group3')
  svgSet.render()
</script>
```

```html
<svg svg-sprite="group1:svg-id" width="100" height="100"></svg>
```

***note***

`svg-id` is the id you set by sprite generator, etc., icomoon.io
this srcipt support all generator which can produce 'id' and `viewBox` attributes for sprites.

#### Method

***svgSprites.load***

Load svg sprites files, cross origin or local file might not work at this time.
You should have start up a web server e ```loaclhost```.

***svgSprites.render***

Render svg sprites to page, after all sprites files is loaded.

You might need re-render after dynamic modifed any `<svg>` tags.
After you load new sprites files, you have to re-render too.


## Installation
from bower：

```
bower install svg-sprites-render
```

from github:
just download from this repo...
