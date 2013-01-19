# AIRFIELD
# ContentController -- manage site content

class ContentController < ApplicationController

  # Display a template/form for content creation
  def new
    begin
      klass = params[:type].camelcase.constantize
      partial_name = "new_#{klass.to_s.downcase.underscore}"

      render :partial=>partial_name, :object=>klass.new, :locals=>{}
    rescue NameError => ne
      render :text=>"Error loading new content form for type #{params[:type]}.", :status=>500
    end
  end

  # Create content
  def create
    raise Exception.new("Can't create right now");
    klass = params[:type].camelcase.constantize
    obj = klass.new()
    params[:content].each do |idx, data|
      content_key =  data[:key]
      content_value = data[:value]

      logger.debug "#{content_key} => #{content_value}"

      if content_key && content_key == "name"
        obj.name = content_value
      elsif content_key && content_key != "content"
        # Strongly-keyed content with regions (like pages):
        obj.content[content_key] = content_value
      else
        # Single text content (like Posts):
        obj.content = content_value
      end
    end

    raise Exception.new("Funky exception")

    obj.author = current_user if obj.respond_to?(:author=)
    obj.save

    partial_name = klass.to_s.downcase.underscore

    render :json=>{success:true, object:obj, content:obj.content, rendered:render_to_string(:partial=>"site/#{partial_name}", :collection=>[obj], :locals=>{new_record:true})}
  end

  # Update content
  def update
    data = params[:content]
    if content = Content.where(:id=>data[:id]).first
      data.delete(:id)
      data.each {|attr, val| content.send("#{attr}=", val) }
      content.save
      render :json=>{success:true, content:content}
    else
      render :json=>{success:false, error:"Content not found."}, :status=>404
    end
  end


  # Destroy content
  def destroy
  end

end
