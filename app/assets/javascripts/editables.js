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


  /** Markdown Conversion: Support HTML->Markdown processing: */
  var markdownize = function(content) {
    var html = content.split("\n").map($.trim).filter(function(line) {
      return line != "";
    }).join("\n");
    return toMarkdown(html);
  };


  /*** EDITING * EDITING * EDITING * EDITING * EDITING * EDITING * EDITING * EDITING * EDITING * EDITING ***/


  /** Make content fields within the given content container editable: */
  function makeEditable($container) {
    console.log("makeEditable called for container:");
    console.log($container);
    var $fields = $container.find("[data-content-attr]");
    $fields.addClass("activated").hallo({
      editable: true,
      toolbar: "halloToolbarContextual",    // halloToolbarFixed
      toolbarCssClass: "ui-widget-header",
      toolbarPositionAbove: true,
      plugins: {
        "halloformat": {},
        "halloheadings": {headers: [2,3,4]},
        // "hallojustify": {},
        "hallolists": {},
        "hallolink": {},
        "halloimage": {}
      }
    });
  }

  /** Revoke edit abilities from content fields within the given container: */
  function revokeEditable($container) {
    var $fields = $container.find("[data-content-attr]");
    $fields.removeClass("activated").hallo({editable:false});
  }


  /** Editable: Enable editing mode for existing on-page content: **/
  // PREVIOUS: $("[data-content-item]").on("enableEdit", function(e){
  $("body").on("enableEdit", "[data-content-item]", function(e){
    makeEditable( $(this) );
  });


  /** Editable: Disable the current editing mode for existing on-page content: */
  //$("[data-content-item]").on("disableEdit", function(e){
  $("body").on("disableEdit", "[data-content-item]", function(e){
    revokeEditable( $(this) );
  });


  /** Editable: Take action when a user focused on an editable field: */
  // PREVIOUS: $("[data-content-item]").on("halloactivated", "[data-content-attr]", function(e, data){});
  $("body").on("halloactivated", "[data-content-item] [data-content-attr]", function(e, data){});


  /** Editable: Send updates to server when a user blurs from an editable field: */
  // PREVIOUS: $("[data-content-item]").on("hallodeactivated", "[data-content-attr]", function(e, data){
  $("body").on("hallodeactivated", "[data-content-item] [data-content-attr]", function(e, data){
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



  /*** INSERTION * INSERTION * INSERTION * INSERTION * INSERTION * INSERTION * INSERTION * INSERTION ***/


  /** Insertable: Pull a template for new content and place it atop a collection for editing: */
  $("a[data-button=add]").on("click", function(e){
    e.preventDefault();
    var $button = $(this);
    var $collection = $(this).parents("[data-content-collection]").first();

    $.get(
      $button.prop("href"),
      { content: {type: $collection.attr("data-content-collection")} },
      function(data, status, xhr){
        console.log("New content response received from server:");
        console.log(data);
        if (data) {
          $button.hide().after(data);
          $newTemplate = $collection.find("[data-content-new]").first();
          console.log("New form item rendered to page. Element:");
          console.log($newTemplate);
          $newTemplate.trigger("enableEdit");
        }
      }
    );
    console.log("New content request sent to server.");
  });


  /** Insertable: Enable editing mode on newly-inserted content within a collection: */
  $("[data-content-collection]").on("enableEdit", "[data-content-new]", function(e){
    alert("Edit mode enabled for a data-content-new:");
    console.log("enableEdit triggered for insertion template:");
    console.log( $(this) );
    makeEditable( $(this) );
  });


  /** Insertable: Disable editing mode on newly-inserted content within a collection: */
  $("[data-content-collection]").on("disableEdit", "[data-content-new]", function(e){
    alert("Edit mode disabled for a data-content-new");
    revokeEditable( $(this) );
  });


  /** Insertable: Trigger save event for new content when user clicks Save button: */
  $("[data-content-collection]").on("click", "a[data-button=save]", function(e){
    e.preventDefault();
    var $button = $(this);
    //var $collection = $button.parents("[data-content-collection]").first();
    var $item = $button.parents("[data-content-new]").first();
    $item.trigger("saveContent");
  });

  /** Insertable: Remove the new content template when user clicks Cancel button: */
  $("[data-content-collection]").on("click", "a[data-button=cancel]", function(e){
    e.preventDefault();
    var $button = $(this);
    var $item = $button.parents("[data-content-new]").first();
    $item.remove();
  });


  /** Insertable: Send create request to server for new content: */
  $("[data-content-collection]").on("saveContent", "[data-content-new]", function(e){
    e.preventDefault();
    var $insertable = $(this);
    var $collection = $insertable.parents("[data-content-collection]").first();

    contentItem = new Airfield.ContentItem({
      type: $insertable.attr("data-content-type"),
      site_id: $collection.attr("data-site-id")
    });
    $insertable.find("[data-content-attr]").each(function(idx, el){
      var $field = $(this);
      contentItem.set( $field.attr("data-content-attr"), $field.html() );
    });
    console.log("Airfield.ContentItem object:");
    contentItem.log();
    contentItem.save(null, {
      success: function(model, response, options){
        console.log("Successful save of inserted content. Server response:");
        console.log(response);
        $insertable.hide().after(response.rendered);
      },
      error: function(model, xhr, options){
        $insertable.hide().after("<span class=\"error parse-error ui-state-error\">Failed to save new content</span>");
        console.log("Error saving inserted content. XHR and options:");
        console.log(xhr);
        console.log(options);
      }
    });
    $("#edit-mode-toggle").trigger("deactivateEdit");
  });


});
