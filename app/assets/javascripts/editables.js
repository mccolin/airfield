// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

$(function(){

  /** At Load Trigger: Enabled Editing on all editable content: */
  $(".editable").hallo({
    editable: true,
    toolbar: "halloToolbarContextual",    // halloToolbarFixed
    toolbarCssClass: "ui-widget-header",
    toolbarPositionAbove: true,
    plugins: {
      "halloformat": {},
      "halloheadings": {headers: [2,3]},
      "hallojustify": {},
      "hallolists": {},
      "hallolink": {},
      "halloimage": {}
    },
  });
  console.log( $(".editable").length + " editable regions enabled on page.");

  // /** Trigger: Begin Editing */
  // $(".edit-trigger").click(function(e){
  //   e.preventDefault();
  //   var containerId = $(this).attr("data-editable");
  //   $("#"+containerId+" .editable").hallo({
  //     editable: true,
  //     toolbar: "halloToolbarContextual",
  //     plugins: {
  //       "halloformat": {},
  //       "halloheadings": {headers: [2,3,4,5,6]},
  //       "hallojustify": {},
  //       "hallolists": {},
  //       "hallolink": {},
  //       "halloimage": {}
  //     },
  //   });
  //   console.log("Editable container \""+containerId+"\" has been triggered.");
  // });

  // /** Stopper: Stop Editing */
  // $(".edit-stopper").click(function(e){
  //   e.preventDefault();
  //   var containerId = $(this).attr("data-editable");
  //   $("#"+containerId+" .editable-content").hallo({editable: false});
  //   console.log("Editable container \""+containerId+"\" has been stopped.");
  // });

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

    // console.log("Editable modified. Content converted to Markdown:");
    // console.log( markdownize(data.content) );
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
    // console.log(data);
    // console.log("Object passed to deactivate event:");
    // console.log( $(this) );

    var editable = $(this);
    if ( editable.hasClass("isModified") ){
      console.log("Content has been modified. Saving");
      // TODO: Save content
      var src = markdownize(editable.html());
      console.log(src);
      editable.removeClass("isModified");
    } else {
      console.log("Content has not been modified. Abstaining.");
    }
  });

});
