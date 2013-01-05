// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

$(function(){

  /** Edit Link Trigger: Set all on-page editables ready-to-go: */
  $("#edit-mode-toggle").click(function(e){
    var $toggle = $(this);
    if ($toggle.hasClass("active"))
      $toggle.removeClass("active").trigger("deactivateEdit");
    else
      $toggle.addClass("active").trigger("activateEdit");
  });

  /** Starter: Begin editable mode on this page: */
  $("#edit-mode-toggle").on("activateEdit", function(e){
    e.preventDefault();
    $(this).addClass("active");
    $(".editable").addClass("activated").hallo({
      editable: true,
      toolbar: "halloToolbarContextual",    // halloToolbarFixed
      toolbarCssClass: "ui-widget-header",
      toolbarPositionAbove: true,
      plugins: {
        "halloformat": {},
        "halloheadings": {headers: [2,3]},
        // "hallojustify": {},
        "hallolists": {},
        "hallolink": {},
        "halloimage": {}
      },
    });
    console.log( $(".editable").length + " editable regions enabled on page.");
  });

  /** Stopper: Stop Editing */
  $("#edit-mode-toggle").on("deactivateEdit", function(e){
    e.preventDefault();
    $(this).removeClass("active");
    $(".editable").removeClass("activated").hallo({editable:false});
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
  // $(".editable").on("hallomodified", function(e, data){
  //   console.log("Editable modified. Content converted to Markdown:");
  //   console.log( markdownize(data.content) );
  // });

  // $(".editable").on("halloselected", function(e, data){
  //   console.log("Editable has active selection.");
  // });

  // $(".editable").on("hallounselected", function(e, data){
  //   console.log("Editable has inactive selection.");
  // });

  // $(".editable").on("hallorestored", function(e, data){
  //   console.log("Editable restored.");
  // });

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
      var src = markdownize(editable.html());
      console.log(src);

      $.ajax({
        type: "PUT",          // PUT maps to update action
        dataType: "json",
        url: "http://airfield.dev/content",
        data: {
          type: editable.attr("data-content-type"),
          id: editable.attr("data-content-id"),
          key: editable.attr("data-content-key"),
          value: src
        },
        success: function(data, status, xhr){
          console.log("Content update posted to server and return successful:");
          console.log(data);
        }
      });
      console.log("Server request for update sent to server.");
      editable.removeClass("isModified");
    } else {
      console.log("Content has not been modified. Abstaining.");
    }
  });

});
