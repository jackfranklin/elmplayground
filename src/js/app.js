var Elm = require('../App.elm');

var app = Elm.MyApp.fullscreen({ 'github_token': process.env.GITHUB_TOKEN });

app.ports.newTitle.subscribe(function(value) {
  if (value) {
    document.title = value + ' | The Elm Playground'
  } else {
    document.title = 'The Elm Playground'
  }
});
