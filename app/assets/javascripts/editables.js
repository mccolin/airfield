// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

$(function(){

  /** Edit Link Trigger: Set all on-page editables ready-to-go: */
  $("#edit-mode-toggle").click(function(e){
    e.preventDefault();
    var $toggle = $(this);
    if ($toggle.hasClass("highlight"))
      $toggle.removeClass("highlight").html( $toggle.html().replace("Editing...","Edit") ).trigger("deactivateEdit");
    else
      $toggle.addClass("highlight").html( $toggle.html().replace("Edit","Editing...") ).trigger("activateEdit");
  });

  /** Starter: Begin editable mode on this page: */
  $("#edit-mode-toggle").on("activateEdit", function(e){
    e.preventDefault();
    var $toggle = $(this);
    $toggle.addClass("highlight");
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
    var $toggle = $(this);
    $toggle.removeClass("highlight");
    $(".editable").removeClass("activated").hallo({editable:false});
  });

  /** Markdown Conversion: Support HTML->Markdown processing: */
  var markdownize = function(content) {
    var html = content.split("\n").map($.trim).filter(function(line) {
      return line != "";
    }).join("\n");
    return toMarkdown(html);
  };

  /** Activation: When user focues on field, take action: */
  $(".editable").on("halloactivated", function(e, data){});

  /** Deactivation: When user unfocues from field, send updates to server: */
  $(".editable").on("hallodeactivated", function(e, data){
    console.log("Editable has been deactivated by user. Server save likely here.");

    var $editable = $(this);
    if ( $editable.hasClass("isModified") ){
      console.log("Content has been modified. Saving");
      var $toggle = $("#edit-mode-toggle");
      $.ajax({
        type: "PUT",          // PUT maps to update action
        dataType: "json",
        url: $toggle.prop("href"),
        data: {
          type: $editable.attr("data-content-type"),
          id: $editable.attr("data-content-id"),
          key: $editable.attr("data-content-key"),
          value: markdownize($editable.html())
        },
        success: function(data, status, xhr){
          $editable.removeClass("isModified");
          console.log("Content successfully saved to server.");
        }
      });
      console.log("Server request for content update sent to server.");
    }
  });

});
