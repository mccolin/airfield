// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// // PREVIOUS: require tinymce-jquery
//
//= require jquery
//= require jquery_ujs
//
//= require jquery-ui
//= require rangy-core-1.2.3
//= require hallo
//= require showdown
//= require to-markdown
//
//= require_tree .

console.log("Application CSS loaded");

$(function(){

  /** Trigger: Begin Editing */
  $(".edit-trigger").click(function(e){
    e.preventDefault();
    var containerId = $(this).attr("data-editable");
    $("#"+containerId+" .editable").hallo({
      editable: true,
      toolbar: "halloToolbarContextual",
      plugins: {
        "halloformat": {},
        "halloheadings": {headers: [2,3,4,5,6]},
        "hallojustify": {},
        "hallolists": {},
        "hallolink": {},
        "halloimage": {}
      },
    });
    console.log("Editable container \""+containerId+"\" has been triggered.");
  });

  /** Stopper: Stop Editing */
  $(".edit-stopper").click(function(e){
    e.preventDefault();
    var containerId = $(this).attr("data-editable");
    $("#"+containerId+" .editable-content").hallo({editable: false});
    console.log("Editable container \""+containerId+"\" has been stopped.");
  });

  /** Markdown Editor Support **/
  /** Markdown Editor Support **/
  /** Markdown Editor Support **/

  var markdownize = function(content) {
    var html = content.split("\n").map($.trim).filter(function(line) {
      return line != "";
    }).join("\n");
    return toMarkdown(html);
  };

  // var converter = new Showdown.converter();
  // var htmlize = function(content) {
  //   return converter.makeHtml(content);
  // };

  // // Method that converts the HTML contents to Markdown
  // var showSource = function(content) {
  //   var markdown = markdownize(content);
  //   if (jQuery('#source').get(0).value == markdown) {
  //     return;
  //   }
  //   jQuery('#source').get(0).value = markdown;
  // };

  // var updateHtml = function(content) {
  //   if (markdownize(jQuery('.editable').html()) == content) {
  //     return;
  //   }
  //   var html = htmlize(content);
  //   jQuery('.editable').html(html);
  // };

  /** Markdown Editor Support **/
  /** Markdown Editor Support **/
  /** Markdown Editor Support **/


  /** Editables: Bind to save */
  $(".editable").on("hallomodified", function(e, data){
    // console.log("Editable modified. Content:");
    // console.log(data.content);
    console.log("Editable modified. Content converted to Markdown:");
    console.log( markdownize(data.content) );
  });

  $(".editable").on("halloselected", function(e, data){
    console.log("Editable has active selection.");
  });

  $(".editable").on("hallounselected", function(e, data){
    console.log("Editable has inactive selection.");
  });

  $(".editable").on("hallorestored", function(e, data){
    console.log("Editable restored.");
  });

  $(".editable").on("halloactivated", function(e, data){
    console.log("Editable has been activated by user. Begin edit mode.");
  });

  $(".editable").on("hallodeactivated", function(e, data){
    console.log("Editable has been deactivated by user. Server save likely here.");
  });

});
