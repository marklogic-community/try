/*jshint node: true */

'use strict';

var gulp = require('gulp');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var clean = require('gulp-clean');
var minifyCss = require('gulp-minify-css');

gulp.task('clean', function() {
  gulp.src('build', {read: false})
    .pipe(clean());
});

gulp.task('build', ['build-js', 'build-css', 'copy-xqy', 'copy-images']);

gulp.task('copy-xqy', function() {
  return gulp.src(['src/**/*.xqy'])
    .pipe(gulp.dest('build'));
});

gulp.task('copy-html', function() {
  return gulp.src(['src/index.html'])
    .pipe(gulp.dest('build'));
});

gulp.task('copy-images', function() {
  return gulp.src(['src/img/**/*', 'src/favicon.ico'])
    .pipe(gulp.dest('build/img'));
});

gulp.task('build-js', function() {
  return gulp.src([
    'node_modules/codemirror/lib/codemirror.js',
    'node_modules/codemirror/mode/htmlmixed/htmlmixed.js',
    'node_modules/codemirror/mode/javascript/javascript.js',
    'node_modules/codemirror/mode/xml/xml.js',
    'node_modules/codemirror/mode/xquery/xquery.js',
    'node_modules/codemirror/mode/clike/clike.js',
    'node_modules/codemirror/mode/shell/shell.js',
    'node_modules/codemirror/mode/sparql/sparql.js',
    'src/js/json2.js',
    'src/js/base.js'
  ])
    .pipe(concat('tryml.js'))
    .pipe(uglify())
    .pipe(gulp.dest('build/js'));
});

gulp.task('build-css', function() {
  return gulp.src([
    'src/css/base.css',
    'node_modules/codemirror/lib/codemirror.css',
    'node_modules/codemirror/theme/default.css'
  ])
    .pipe(concat('tryml.css'))
    .pipe(minifyCss({compatibility: 'ie8'}))
    .pipe(gulp.dest('build/css'));
});
