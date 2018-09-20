// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require foundation.min
//= require what-input
//= require ckeditor/init
//= require foundation-datetimepicker
//= require turbolinks
//= require chart
//= require turbolinks-compatibility
//= session_timeout_prompter
//= require highcharts
//= require_tree .




$(function(){ $(document).foundation(); });

$(function(){
  if(sessionTimeoutPrompter) {

    // Ping server on scroll
    $(window).on('scroll', function() {
      serverPinger.pingServerWithThrottling();
    });

    // Ping server when typing or clicking
    $(document).on('keydown click', function() {
      serverPinger.pingServerWithThrottling();
    });

    // Ping server when scrolling inside a modal window
    // (the ajax-modal-show event in this example is from ajax_modal in the epiJs gem)
    $(document).on('ajax-modal-show', function() {
      $('#modalWindow').scroll( function() {
        serverPinger.pingServerWithThrottling();
      });
    });

    // Ping server when a key is pressed in CKEditor
    CKEDITOR.on('instanceCreated', function(e) {
      e.editor.on('change', function() {
        serverPinger.pingServerWithThrottling();
      });
    });

  }
});


