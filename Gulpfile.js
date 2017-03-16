var gulp = require('gulp');
var liveServer = require('live-server');
var $ = require('gulp-load-plugins')({});
var del = require('del');

function watchElmAndRun(...args) {
  return gulp.watch('**/*.elm', args);
}

gulp.task('build', function() {
  return gulp.src('src/App.elm')
    .pipe($.plumber({
      errorHandler: $.notify.onError({ sound: false, message: 'Elm error' })
    }))
    .pipe($.elm.bundle('App.js', {
      warn: true,
      debug: true
    }))
    .pipe(gulp.dest('build/'));
});

gulp.task('prod:elm', ['prod:clean'], function() {
  return gulp.src('src/App.elm')
    .pipe($.elm.bundle('App.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('dist/build'));
});

gulp.task('prod:clean', function() {
  return del(['dist/**/*']);
});

gulp.task('prod:vendor', ['prod:clean'], function() {
  return gulp.src('vendor/*').pipe(gulp.dest('dist/vendor'));
});

gulp.task('prod:html', ['prod:clean'], function() {
  return gulp.src('index.html')
    .pipe($.rename('200.html'))
    .pipe(gulp.dest('dist'));
});

gulp.task('prod:css', ['prod:clean'], function() {
  return gulp.src('style.css').pipe(gulp.dest('dist'));
});

gulp.task('prod:img', ['prod:clean'], function() {
  return gulp.src('img/*').pipe(gulp.dest('dist/img'));
});

gulp.task('prod:js', ['prod:clean'], function() {
  return gulp.src('js/*').pipe(gulp.dest('dist/js'));
});

gulp.task('prod:content', ['prod:clean'], function() {
  return gulp.src('content/**/*', { base: 'content' }).pipe(gulp.dest('dist/content'));
});

gulp.task('deploy', [
  'prod:vendor', 'prod:html', 'prod:css',
  'prod:js', 'prod:img', 'prod:content', 'prod:elm'
], function() {
  $.util.log('Deploying version: ', require('./package.json').version);
  return $.surge({
    project: './dist',
    domain: 'elmplayground.com'
  });
});

gulp.task('start', ['build'], function() {
  watchElmAndRun('build');
});

gulp.task('serve', function() {
  liveServer.start({
    open: false,
    ignore: /elm-stuff/,
    file: 'index.html'
  });
});
