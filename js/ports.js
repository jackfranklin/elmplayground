var app = Elm.MyApp.fullscreen();
app.ports.newTitle.subscribe(function(value) {
  if (value) {
    document.title = value + ' | The Elm Playground'
  } else {
    document.title = 'The Elm Playground'
  }
});
