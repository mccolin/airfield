# AIRFIELD
# ContentController -- manage site content

class ContentController < ApplicationController

  # Create content
  def create
  end

  # Update content
  def update
    begin
      content_klass = params[:type].camelcase.constantize
      content_obj = content_klass.where(:id=>params[:id]).first()
      content_key = params[:key]
      content_value = params[:value]
      if content_key && content_key == "name"
        content_obj.name = content_value
      elsif content_key && content_key != "content"
        # Strongly-keyed content with regions (like pages):
        content_obj.content[content_key] = content_value
      else
        # Single text content (like Posts):
        content_obj.content = content_value
      end
      content_obj.save

      render :json=>{success:true, object:content_obj, content:content_obj.content[content_key]}
    end
  end

  # Destroy content
  def destroy
  end

end
