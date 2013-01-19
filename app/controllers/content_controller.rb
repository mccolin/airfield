# AIRFIELD
# ContentController -- manage site content

class ContentController < ApplicationController

  # Display a template/form for content creation
  def new
    begin
      data = params[:content]
      content_type = data[:type]
      klass = content_type.camelcase.constantize
      partial_name = "new_#{klass.to_s.downcase.underscore}"
      render :partial=>partial_name, :object=>klass.new, :locals=>{}
    rescue NameError => ne
      render :text=>"Error loading new content form for type #{content_type}.", :status=>500
    end
  end


  # Create content
  def create
    data = params[:content]
    begin
      content = Content.new(data)
      content.author = current_user if content.respond_to?(:author=)
      content.save
      content = content.type.constantize.where(:id=>content.id).first     # <= Load content through appropriate subclass
      partial_name = content.type.downcase.underscore
      render :json=>{success:true, content:content, rendered:render_to_string(partial:"site/#{partial_name}", :object=>content, :locals=>{})}
    end
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
