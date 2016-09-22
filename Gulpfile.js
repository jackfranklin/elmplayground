var gulp = require('gulp');
var liveServer = require('live-server');
var $ = require('gulp-load-plugins')({});
var del = require('del');

function watchElmAndRun(...args) {
  return gulp.watch('**/*.elm', args);
}

gulp.task('build', function() {
  return gulp.src('App.elm')
    .pipe($.plumber({
      errorHandler: $.notify.onError({ sound: false, message: 'Elm error' })
    }))
    .pipe($.elm.bundle('App.js', { warn: true }))
    .pipe(gulp.dest('build/'));
});

gulp.task('prod:elm', ['prod:clean'], function() {
  return gulp.src('App.elm')
    .pipe($.elm.bundle('App.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('dist/build'));
});

gulp.task('prod:clean', function() {
  return del(['dist']);
});

gulp.task('prod:vendor', ['prod:clean'], function() {
  return gulp.src('vendor/*').pipe(gulp.dest('dist/vendor'));
});

gulp.task('prod:html', ['prod:clean'], function() {
  return gulp.src('index.html').pipe(gulp.dest('dist'));
});

function makeProdBumpTask(level) {
  gulp.task('prod:' + level, ['prod:vendor', 'prod:html', 'prod:elm'], function() {
    return gulp.src(['./package.json', './elm-package.json'])
      .pipe($.bump({ type: level }))
      .pipe(gulp.dest('./'))
      .pipe($.filter('package.json'))
      .pipe($.tagVersion());
  });
}

makeProdBumpTask('patch');
makeProdBumpTask('minor');
makeProdBumpTask('major');

gulp.task('build-prod', function() {
  $.util.log('You need to use `gulp prod:` with `patch`, `minor` or `major`');
});

gulp.task('deploy', function() {
  $.util.log('Deploying version: ', require('./package.json').version);
  return $.surge({
    project: './dist',
    domain: throw new Error("Define the domain for deploying to!")
  });
});

gulp.task('start', ['build'], function() {
  watchElmAndRun('build');
});

gulp.task('test', $.shell.task(['elm-test'], {
  ignoreErrors: true
}));

gulp.task('watch-test', ['test'], function() {
  watchElmAndRun('test');
});


gulp.task('serve', function() {
  liveServer.start({
    open: false,
    ignore: /elm-stuff/
  });
});
