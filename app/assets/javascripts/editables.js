// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

$(function(){

  /** Edit Link Trigger: Set all on-page editables ready-to-go: */
  $("#edit-mode-toggle").click(function(e){
    e.preventDefault();
    var $toggle = $(this);
    if ($toggle.hasClass("highlight"))
      $toggle.trigger("deactivateEdit");
    else
      $toggle.trigger("activateEdit");
  });


  /** Starter: Begin editable mode on this page: */
  $("#edit-mode-toggle").on("activateEdit", function(e){
    e.preventDefault();
    var $toggle = $(this);
    $toggle.addClass("highlight").html( $toggle.html().replace("Edit","Editing...") );

    // Make editable fields active:
    $(".editable .field, .insertable .field").addClass("activated").hallo({
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
    console.log( $(".editable .field").length + " editable fields enabled on page.");

    // Make edit-only UI elements active:
    $(".edit-ui").addClass("activated");

    // Make insertable/create fields active:
    $(".insertable").addClass("activated");
  });


  /** Stopper: Stop Editing */
  $("#edit-mode-toggle").on("deactivateEdit", function(e){
    e.preventDefault();
    $(this).removeClass("highlight").html( $(this).html().replace("Editing...","Edit") );

    // Deactivate editable fields on the page:
    $(".editable .field").removeClass("activated").hallo({editable:false});

    // Deactivate edit-only UI elements:
    $(".edit-ui").removeClass("activated");

    // Deactivate insertable/create fields:
    $(".insertable").removeClass("activated");
  });


  /** Markdown Conversion: Support HTML->Markdown processing: */
  var markdownize = function(content) {
    var html = content.split("\n").map($.trim).filter(function(line) {
      return line != "";
    }).join("\n");
    return toMarkdown(html);
  };


  /** Activation: When user focues on field, take action: */
  $(".editable .field").on("halloactivated", function(e, data){});


  /** Deactivation: When user unfocues from field, send updates to server: */
  $(".editable .field").on("hallodeactivated", function(e, data){
    console.log("Editable has been deactivated by user. Server save likely here.");

    var $field = $(this);
    var $editable = $field.parents(".editable").first();

    if ( $field.hasClass("isModified") ){
      console.log("Content has been modified. Saving");
      var $toggle = $("#edit-mode-toggle");
      $.ajax({
        type: "PUT",          // PUT maps to update action
        dataType: "json",
        url: $toggle.prop("href"),
        data: {
          type: $editable.attr("data-content-type"),
          id: $editable.attr("data-content-id"),
          key: $field.attr("data-content-key"),
          value: markdownize($field.html())
        },
        success: function(data, status, xhr){
          $field.removeClass("isModified");
          console.log("Content successfully saved to server.");
        }
      });
      console.log("Server request for content update sent to server.");
    }
  });



  /** Insertable: Click Add Content Button: */
  $(".add-content-button").click(function(e){
    e.preventDefault();
    var $button = $(this);
    $.get(
      $button.prop("href"),
      {type: $button.attr("data-content-type")},
      function(data, status, xhr){
        console.log("New content response received from server:");
        console.log(data);
        if (data) {
          $button.hide().after(data);
          console.log("New form item rendered to page.");
          $("#edit-mode-toggle").trigger("activateEdit");
          $(".insertable .save-button").click(function(e){
            e.preventDefault();
            $(this).parents(".insertable").first().trigger("saveContent");
          }
        }
      }
    );
    console.log("New content request sent to server.");
  });


  /** Insertable: Save new content to server: */
  $(".insertable").on("saveContent", function(e){
    e.preventDefault();
    var $insertable = $(this);
    var $saveButton = $insertable.find(".save-button").first();

    var contentData = new Array();
    $insertable.find(".field").each(function(idx, el){
      var $field = $(this);
      contentData.push({key: $field.attr("data-content-key"), value: markdownize($field.html()) });
    });

    console.log("Will send insertable save to "+$saveButton.prop("href"));
    console.log("contentData to send:");
    console.log(contentData);

    $.ajax({
      type: "POST",
      dataType: "json",
      url: $saveButton.prop("href"),
      data: {
        type: $insertable.attr("data-content-type"),
        content: contentData
      },
      success: function(data, status, xhr){
        console.log("Server response returned to script. Inserting new content, now.");
        if (data.success && data.rendered) {
          $insertable.hide().after(data.rendered);
        } else {
          $insertable.hide().after("<span class=\"error parse-error ui-state-error\">Failed to save new content</span>");
        }
      },
      error: function(xhr, status, message){
        $insertable.hide().after("<span class=\"error parse-error ui-state-error\">Failed to save new content: "+message+"</span>");
      }
    });
    console.log("Server request for content creation sent to server.");
    $("#edit-mode-toggle").trigger("deactivateEdit");
  });

});
