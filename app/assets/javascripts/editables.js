// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

$(function(){

  /**
  /* Edit Trigger: Activate edit mode: **/
  $("#edit-mode-toggle").on("click", function(e){
    e.preventDefault();
    var $toggle = $(this);
    if ($toggle.hasClass("highlight")) {
      $toggle.removeClass("highlight").html( $toggle.html().replace("Editing...","Edit") )
      $("[data-content-item]").trigger("disableEdit");
      // TODO: Insertable
    }
    else {
      $toggle.addClass("highlight").html( $toggle.html().replace("Edit","Editing...") )
      $("[data-content-item]").trigger("enableEdit");
      // TODO: Insertable
    }
  });


  /**
  /* Editable/Insertable: Enable editing mode: **/
  // PREVIOUS: $(".editable, .insertable").on("enableEdit", function(e){...});
  $("[data-content-item]").on("enableEdit", function(e){
    var $container = $(this);
    var $fields = $container.find("[data-content-attr]");
    $fields.addClass("activated").hallo({
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
      }
    });
  });


  /**
  /* Editable/Insertable: Disable the current editing mode: */
  // PREVIOUS: $(".editable, .insertable").on("disableEdit", function(e){...});
  $("[data-content-item]").on("disableEdit", function(e){
    var $container = $(this);
    var $fields = $container.find("[data-content-attr]");
    $fields.removeClass("activated").hallo({editable:false});
  });


  /** Markdown Conversion: Support HTML->Markdown processing: */
  var markdownize = function(content) {
    var html = content.split("\n").map($.trim).filter(function(line) {
      return line != "";
    }).join("\n");
    return toMarkdown(html);
  };


  /**
  /* Activation: When user focues on field, take action: */
  // PREVIOUS: $(".editable, .insertable").on("halloactivated", ".field", function(e, data){...});
  $("[data-content-item]").on("halloactivated", "[data-content-attr]", function(e, data){
    var $field = $(this);
  });


  /** Deactivation: When user unfocues from field, send updates to server: */
  // PREVIOUS: $(".editable").on("hallodeactivated", ".field", function(e, data){...});
  $("[data-content-item]").on("hallodeactivated", "[data-content-attr]", function(e, data){
    var $field = $(this);
    var $container = $field.parents("[data-content-item]").first();

    if ( $field.hasClass("isModified") ){
      console.log("Content has been modified. Saving");
      var $toggle = $("#edit-mode-toggle");
      contentItem = new Airfield.ContentItem({ id: $container.attr("data-content-item") });
      contentItem.set( $field.attr("data-content-attr"), markdownize($field.html()) );
      console.log("Airfield.ContentItem object:");
      contentItem.log();
      contentItem.save(null, {
        success: function(model, response, options){
          alert("Saved!");
          console.log("Successful save of editable item. Server response:");
          console.log(response);
        },
        error: function(model, xhr, options){
          console.log("Error saving editable item. XHR and options:");
          console.log(xhr);
          console.log(options);
        }
      });
    }
  });


  /** Insertion: Click Add Content Button: */
  $(".add-content-button").on("click", function(e){
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
        }
      }
    );
    console.log("New content request sent to server.");
  });


  /** Insertion: Trigger a save when user clicks Save button: */
  $(".insertable").on("click", ".save-button", function(e){
    e.preventDefault();
    console.log("Clicking save on button:");
    console.log( $(this) );
    $(this).parents(".insertable").first().trigger("saveContent");
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

    // TODO: Replace direct call to $.ajax with Backbone model interaction

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
