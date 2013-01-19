// AIRFIELD
// Editables JS -- Functionality associated with in-place editable
//  content regions.

(function() {
  var Airfield = {};
  window.Airfield = Airfield;
  Airfield.ContentItem = Backbone.Model.extend({
    url: "/content",
    defaults: {}, // name: "New Post", matter: "This is the body text of your new post."
    toJSON: function(){
      return _.extend({
        type: this.type,
        content: this.attributes
      });
    },
    log: function() {
      console.log("Airfield Content#"+this.id+":");
      console.log(this);
    }
  });
})();
console.log("Airfield.ContentItem JS class defined.");


$(function(){

  /**
  /* Edit Trigger: Activate edit mode: **/
  $("#edit-mode-toggle").on("click", function(e){
    e.preventDefault();
    var $toggle = $(this);
    if ($toggle.hasClass("highlight")) {
      $toggle.removeClass("highlight").html( $toggle.html().replace("Editing...","Edit") )
      $("[data-content-item]").trigger("disableEdit");
      $("[data-edit-ui]").removeClass("activated");
      // TODO: Insertable
    }
    else {
      $toggle.addClass("highlight").html( $toggle.html().replace("Edit","Editing...") )
      $("[data-content-item]").trigger("enableEdit");
      $("[data-edit-ui]").addClass("activated");
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
  $("body").on("enableEdit", "[data-content-item]", function(e){
    makeEditable( $(this) );
  });


  /** Editable: Disable the current editing mode for existing on-page content: */
  $("body").on("disableEdit", "[data-content-item]", function(e){
    revokeEditable( $(this) );
  });


  /** Editable: Take action when a user focused on an editable field: */
  $("body").on("halloactivated", "[data-content-item] [data-content-attr]", function(e, data){});


  /** Editable: Send updates to server when a user blurs from an editable field: */
  $("body").on("hallodeactivated", "[data-content-item] [data-content-attr]", function(e, data){
    var $field = $(this);
    var $container = $field.parents("[data-content-item]").first();

    if ( $field.hasClass("isModified") ){
      var $toggle = $("#edit-mode-toggle");
      contentItem = new Airfield.ContentItem({ id: $container.attr("data-content-item") });
      contentItem.set( $field.attr("data-content-attr"), markdownize($field.html()) );
      console.log("Airfield.ContentItem object:");
      contentItem.log();
      contentItem.save(null, {
        success: function(model, response, options){
          // TODO: Replace the on-screen content with the content from server?
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
        if (data) {
          $button.after(data);
          $newTemplate = $collection.find("[data-content-new]").first();
          $newTemplate.trigger("enableEdit");
        }
      }
    );
  });


  /** Insertable: Enable editing mode on newly-inserted content within a collection: */
  $("[data-content-collection]").on("enableEdit", "[data-content-new]", function(e){
    makeEditable( $(this) );
  });


  /** Insertable: Disable editing mode on newly-inserted content within a collection: */
  $("[data-content-collection]").on("disableEdit", "[data-content-new]", function(e){
    revokeEditable( $(this) );
  });


  /** Insertable: Trigger save event for new content when user clicks Save button: */
  $("[data-content-collection]").on("click", "a[data-button=save]", function(e){
    e.preventDefault();
    var $button = $(this);
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
    contentItem.save(null, {
      success: function(model, response, options){
        $insertable.hide().after(response.rendered);
      },
      error: function(model, xhr, options){
        $insertable.hide().after("<span class=\"error parse-error ui-state-error\">Failed to save new content</span>");
      }
    });
    $("#edit-mode-toggle").click();
  });


});
